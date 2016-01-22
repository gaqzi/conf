# Config files

These are my general config files aggrued over a long period of time.
It's likely not useful to anyone but myself.

# Installation

Clone the directory and then run `rake` to clone any submodules and
symlink all files and folders.

## Updated with thoughtbot's laptop script

```
$ mkdir ~/code && cd ~/code
$ git clone git://github.com/thoughtbot/laptop.git
$ bash laptop/mac
$ rehash
$ # copy id_rsa file into place
$ git clone git@github.com:gaqzi/conf.git
$ RCRC=$(pwd)/conf/rcrc rcup
```

# Configuring OSX apps

## iTerm2

1. `Cmd+;`
2. General tab, near the bottom click "Load preferences from a custom folder or
   URL"
3. Browse to `$HOME/code/conf/Mac apps/iTerm2`
4. Restart iTerm2

## IntelliJ

1. Load by going to `File` -> `Import settings`
2. Select `settings.jar` from `~/code/conf/Mac apps/IntelliJIdea15`
