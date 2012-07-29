#!/bin/bash

LOCK=/tmp/rsyncing
ROOT=/storage/mirror

[ -f $LOCK ] && exit 0

touch $LOCK

# apache
echo -1 > $ROOT/.apache
/usr/bin/rsync -azq --delete-delay rsync.apache.org::apache-dist $ROOT/apache/
echo $? > $ROOT/.apache

# centos
echo -1 > $ROOT/.centos
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::centos $ROOT/centos/
echo $? > $ROOT/.centos

# CPAN
echo -1 > $ROOT/.cpan
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::CPAN $ROOT/cpan/
echo $? > $ROOT/.cpan

# cygwin
echo $? > $ROOT/.cygwin
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::sourceware/cygwin/ $ROOT/cygwin/
echo $? > $ROOT/.cygwin

# eclipse
echo $? > $ROOT/.eclipse
/usr/bin/rsync -azq --delete-delay download.eclipse.org::eclipseMirror $ROOT/eclipse/
echo $? > $ROOT/.eclipse

# epel
echo $? > $ROOT/.epel
/usr/bin/rsync -avq --delete-delay mirrors.kernel.org::fedora-epel $ROOT/epel
RESULT=$? && echo $RESULT > $ROOT/.epel && [ $RESULT -eq 0 ] && /usr/bin/report_mirror > /dev/null && unset RESULT

# gentoo
echo $? > $ROOT/.gentoo
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::gentoo $ROOT/gentoo/
echo $? > $ROOT/.gentoo

# putty
echo $? > $ROOT/.putty
/usr/bin/rsync -azq --delete-delay rsync.chiark.greenend.org.uk::ftp/users/sgtatham/putty-website-mirror/ $ROOT/putty/
echo $? > $ROOT/.putty

# pypi
echo $? > $ROOT/.pypi
/usr/bin/pep381run -q $ROOT/pypi/
echo $? > $ROOT/.pypi

# ubuntu
echo $? > $ROOT/.ubuntu
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::ubuntu $ROOT/ubuntu/
echo $? > $ROOT/.ubuntu

# ubuntu-release
echo $? > $ROOT/.ubuntu-release
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::ubuntu-releases $ROOT/ubuntu-releases/
echo $? > $ROOT/.ubuntu-release

rm -f $LOCK
