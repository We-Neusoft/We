#!/bin/bash

LOCK=/tmp/rsyncing
ROOT=/storage/mirror

[ -f $LOCK ] && exit 0

touch $LOCK

# apache
echo -1 > $ROOT/.apache.status
/usr/bin/rsync -azq --delete-delay rsync.apache.org::apache-dist $ROOT/apache/
RESULT=$?
echo $RESULT > $ROOT/.apache.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.apache.timestamp
unset RESULT

# centos
echo -1 > $ROOT/.centos.status
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::centos $ROOT/centos/
RESULT=$?
echo $RESULT > $ROOT/.centos.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.centos.timestamp
unset RESULT

# CPAN
echo -1 > $ROOT/.cpan.status
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::CPAN $ROOT/cpan/
RESULT=$?
echo $RESULT > $ROOT/.cpan.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.cpan.timestamp
unset RESULT

# cygwin
echo -1 > $ROOT/.cygwin.status
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::sourceware/cygwin/ $ROOT/cygwin/
RESULT=$?
echo $RESULT > $ROOT/.cygwin.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.cygwin.timestamp
unset RESULT

# eclipse
echo -1 > $ROOT/.eclipse.status
/usr/bin/rsync -azq --delete-delay download.eclipse.org::eclipseMirror $ROOT/eclipse/
RESULT=$?
echo $RESULT > $ROOT/.eclipse.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.eclipse.timestamp
unset RESULT

# epel
echo -1 > $ROOT/.epel.status
/usr/bin/rsync -avq --delete-delay mirrors.kernel.org::fedora-epel $ROOT/epel
RESULT=$?
echo $RESULT > $ROOT/.epel.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.epel.timestamp
[ $RESULT -eq 0 ] && /usr/bin/report_mirror > /dev/null
unset RESULT

# gentoo
echo -1 > $ROOT/.gentoo.status
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::gentoo $ROOT/gentoo/
RESULT=$?
echo $RESULT > $ROOT/.gentoo.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.gentoo.timestamp
unset RESULT

# putty
echo -1 > $ROOT/.putty.status
/usr/bin/rsync -azq --delete-delay rsync.chiark.greenend.org.uk::ftp/users/sgtatham/putty-website-mirror/ $ROOT/putty/
RESULT=$?
echo $RESULT > $ROOT/.putty.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.putty.timestamp
unset RESULT

# pypi
echo -1 > $ROOT/.pypi.status
/usr/bin/pep381run -q $ROOT/pypi/
RESULT=$?
echo $RESULT > $ROOT/.pypi.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.pypi.timestamp
unset RESULT

# ubuntu
echo -1 > $ROOT/.ubuntu.status
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::ubuntu $ROOT/ubuntu/
RESULT=$?
echo $RESULT > $ROOT/.ubuntu.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.ubuntu.timestamp
unset RESULT

# ubuntu-release
echo -1 > $ROOT/.ubuntu-release.status
/usr/bin/rsync -azq --delete-delay mirrors.kernel.org::ubuntu-releases $ROOT/ubuntu-releases/
RESULT=$?
echo $RESULT > $ROOT/.ubuntu-release.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.ubuntu-release.timestamp
unset RESULT

rm -f $LOCK
