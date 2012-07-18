#!/bin/bash

LOCK=/tmp/rsyncing

[ -f $LOCK ] && exit 0

touch $LOCK

# apache
/usr/bin/rsync -azq --delete-delay rsync.apache.org::apache-dist /storage/mirror/apache/

# centos
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::centos /storage/mirror/centos/

# CPAN
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::CPAN /storage/mirror/cpan/

# cygwin
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::sourceware/cygwin/ /storage/mirror/cygwin/

# eclipse
/usr/bin/rsync -azq --delete-delay download.eclipse.org::eclipseMirror /storage/mirror/eclipse/

# epel
/usr/bin/rsync -avq --delete-delay mirrors.kernel.org::fedora-epel /storage/mirror/epel/
[ $? -eq 0 ] && /usr/bin/report_mirror > /dev/null

# gentoo
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::gentoo /storage/mirror/gentoo/

# putty
/usr/bin/rsync -azq --delete-delay rsync.chiark.greenend.org.uk::ftp/users/sgtatham/putty-website-mirror/ /storage/mirror/putty/

# pypi
/usr/bin/pep381run -q /storage/mirror/pypi/

# ubuntu
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::ubuntu /storage/mirror/ubuntu/

# ubuntu-release
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::ubuntu-releases /storage/mirror/ubuntu-releases/

# timestamp
date > /storage/mirror/timestamp.txt

rm -f $LOCK
