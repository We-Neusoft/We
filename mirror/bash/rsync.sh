#!/bin/bash

LOCK=/tmp/rsyncing
ROOT=/storage/mirror

[ -f $LOCK ] && exit 0

touch $LOCK

# apache
/usr/bin/rsync -azq --delete-delay rsync.apache.org::apache-dist $ROOT/apache/

# centos
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::centos $ROOT/centos/

# CPAN
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::CPAN $ROOT/cpan/

# cygwin
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::sourceware/cygwin/ $ROOT/cygwin/

# eclipse
/usr/bin/rsync -azq --delete-delay download.eclipse.org::eclipseMirror $ROOT/eclipse/

# epel
/usr/bin/rsync -avq --delete-delay mirrors.kernel.org::fedora-epel $ROOT/epel/
[ $? -eq 0 ] && /usr/bin/report_mirror > /dev/null

# gentoo
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::gentoo $ROOT/gentoo/

# putty
/usr/bin/rsync -azq --delete-delay rsync.chiark.greenend.org.uk::ftp/users/sgtatham/putty-website-mirror/ $ROOT/putty/

# pypi
/usr/bin/pep381run -q $ROOT/pypi/

# ubuntu
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::ubuntu $ROOT/ubuntu/

# ubuntu-release
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::ubuntu-releases $ROOT/ubuntu-releases/

# timestamp
date > $ROOT/timestamp.txt

rm -f $LOCK
