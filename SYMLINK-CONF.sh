#!/bin/bash

cd `dirname $0`

FILES=`ls`
FILES=''
for f in $FILES ; do
	for g in SYMLINK-CONF.sh dot.ssh ; do
		if [[ $f == $g ]] ; then
			continue 2
		fi
	done

	# Create the symlink and ask if the file already exists
	if [ -f $f ] && [ ! -e "${PWD}/.${f}" ] ; then
		ln -s -i ${PWD}/${f} ~/.${f}
	# Directories that start with dot.<dirname> should be named .<dirname>
	elif [ -d $f ] ; then
		if [[ "${f}" =~ "dot." ]] ; then
			ln -s -i "${PWD}/${f} ~/.`echo $f | sed s/dot\.//`"
		else
			ln -s -i "${PWD}/${f} ~/${f}"
		fi
	fi
done

if [ ! -d ~/tmp ] ; then
	mkdir ~/tmp
fi

# Make sure it's easy to swap out the .ssh folder
# Copy all files except the config and then ask if you really want to
# remove all files left in .ssh
if [ -d ~/.ssh ] ; then
	echo "~/.ssh is a directory, swapping it out!"
	for f in $( ls ~/.ssh/ ) ; do
		if [ $f != 'config' ] ; then
			mv -v "${HOME}/.ssh/${f}" "${PWD}/dot.ssh/"
		fi
	done

	rm -ri ~/.ssh
	ln -s $PWD/dot.ssh ~/.ssh
fi
