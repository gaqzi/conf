# All files will be matched against this array, if the file starts the same
# then it's ignored for automatic processing
IGNORE_FOR_SYMLINK = %w[SYMLINK-CONF.sh dot.ssh vim-config vimrc emacs.d]

desc 'Check out submodules and symlink all configuration files'
task :default => [:setup_vim, :setup_emacs, :symlink_all_the_things]

desc 'Check out git submodules'
task :checkout_submodules do
  sh 'git submodule init'
  sh 'git submodule update'
end

desc 'Setup vim configuration'
task :setup_vim => [:checkout_submodules] do
  sh "cd '#{File.join(Rake.original_dir, 'vim-config')}' && rake"

  symlink_to_folder = File.join(
    Rake.original_dir, 'vim-config', '.vim', 'custom_config'
  )
  Dir.mkdir(symlink_to_folder) rescue Errno::EEXIST

  local_vim_files = FileList.new(File.join(Rake.original_dir, 'vimrc.local*'))
  local_vim_files.each do |file|
    ln_s(
      file,
      File.join(symlink_to_folder, "#{File.basename(file)}.vim")
    ) rescue Errno::EEXIST
  end
end

desc 'Setup emacs configuration'
task :setup_emacs => [:checkout_submodules] do
  sh "emacs.d/setup.sh"
end

task :symlink_all_the_things => [:symlink_ssh_folder, :create_tmp_folder] do
  FileList.new(File.join(Rake.original_dir, '*')).each do |full_path|
    file = File.basename full_path
    next if IGNORE_FOR_SYMLINK.find {|pattern| file.start_with? pattern}

    begin
      if File.file? full_path
        ln_s(full_path, File.join(ENV['HOME'], ".#{file}"))
      elsif File.directory? full_path
        symlink_name = File.join(ENV['HOME'], file.sub(/^dot/, ''))
        next if File.symlink? symlink_name
        ln_s(full_path, symlink_name)
      else
        puts ' => skipping, unknown file'
      end
    rescue Errno::EEXIST
      puts ' => skipping, already exists'
    end
  end
end

task :symlink_ssh_folder do
  ssh_path = File.join(ENV['HOME'], '.ssh')
  ssh_config_path = File.join(Rake.original_dir, 'dot.ssh')
  next if File.symlink? ssh_path

  puts "#{ssh_path} is not a symlink, swapping it out"

  FileList.new(File.join(ssh_path, '*')).each do |full_path|
    file = File.basename full_path
    next if file == 'config'

    mv(full_path, ssh_config_path, :verbose => true)
  end

  rm_r ssh_path, :verbose => true
  ln_s ssh_config_path, ssh_path
end

task :create_tmp_folder do
  mkdir_p File.join(ENV['HOME'], 'tmp')
end
