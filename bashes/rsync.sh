#!/bin/bash

LOCK=/tmp/rsyncing
ROOT=/storage/mirror

[ -f $LOCK ] && exit 0

touch $LOCK

function rsync {
   echo -1 > $ROOT/.$1.status
   /usr/bin/rsync -azq --delete-delay $2 $ROOT/$1/
   RESULT=$?
   echo $RESULT > $ROOT/.$1.status
   [$RESULT -eq 0] date "+%Y-%m-%d %H:%M:%S %Z" > $ROOT/.$1.timestamp
}

# apache
rsync apache rsync.apache.org::apache-dist
unset RESULT

# centos
rsync centos mirrors.kernel.org::centos
unset RESULT

# cpan
rsync cpan mirrors.kernel.org::CPAN
unset RESULT

# cygwin
rsync cygwin mirrors.kernel.org::sourceware/cygwin/
unset RESULT

# eclipse
rsync eclipse download.eclipse.org::eclipseMirror
unset RESULT

# epel
rsync epel mirrors.kernel.org::fedora-epel
[ $RESULT -eq 0 ] && /usr/bin/report_mirror > /dev/null
unset RESULT

# gentoo
rsync gentoo mirrors.kernel.org::gentoo
unset RESULT

# putty
rsync putty rsync.chiark.greenend.org.uk::ftp/users/sgtatham/putty-website-mirror/
unset RESULT

# ubuntu
rsync ubuntu mirrors.kernel.org::ubuntu
unset RESULT

# ubuntu-release
rsync ubuntu-release mirrors.kernel.org::ubuntu-releases
unset RESULT

# pypi
echo -1 > $ROOT/.pypi.status
/usr/bin/pep381run -q $ROOT/pypi/
RESULT=$?
echo $RESULT > $ROOT/.pypi.status
[ $RESULT -eq 0 ] date "+%Y-%m-%d %H:%M:%S %Z" >> $ROOT/.pypi.timestamp
unset RESULT

rm -f $LOCK
