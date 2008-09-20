#!/bin/sh

FILES=`ls`
for f in $FILES ; do
	if [ $f != 'SYMLINK-CONF.sh' ] ; then
		ln -s ${f} ~/.${f}
	fi
done
