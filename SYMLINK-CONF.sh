#!/bin/sh

FILES=`ls`
for f in $FILES ; do
	if [ $f != 'SYMLINK-CONF.sh' ] ; then
		ln -s ${PWD}/${f} ~/.${f}
	fi
done

if [ ! -d ~/tmp ] ; then
	mkdir ~/tmp
fi
