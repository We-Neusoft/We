#!/bin/bash

LOCK=/tmp/rsyncing
ROOT=/storage/mirror

[ -f $LOCK ] && exit 0

touch $LOCK

function count {
   find $ROOT/$1 -type f | wc -l > $ROOT/.$1.count
   du -bs $ROOT/$1 | awk '{print $1}' > $ROOT/.$1.size
   date "+%Y-%m-%d %H:%M:%S %Z" > $ROOT/.$1.timestamp
}

function rsync_common {
   echo -1 > $ROOT/.$1.status
   /usr/bin/rsync -aHq --delete-delay --timeout=900 $2 $ROOT/$1/ > /dev/null
   RESULT=$?
   echo $RESULT > $ROOT/.$1.status
   if [ $RESULT -eq 0 ]; then
      count $1
   fi
}

function rsync_rhel {
   echo -1 > $ROOT/.$1.status
   /usr/bin/rsync -aHq --exclude="repomd.xml" --timeout=900 $2 $ROOT/$1/ > /dev/null
   RESULT=$?
   if [ $RESULT -eq 0 ]; then
      /usr/bin/rsync -aq --delete-delay --timeout=900 $2 $ROOT/$1/ > /dev/null
      RESULT=$?
   fi
   echo $RESULT > $ROOT/.$1.status
   if [ $RESULT -eq 0 ]; then
      count $1
   fi
}

function rsync_debian {
   echo -1 > $ROOT/.$1.status
   /usr/bin/rsync -aHq --exclude="Packages*" --exclude="Sources*" --exclude="Release" --timeout=900 $2 $ROOT/$1/ > /dev/null
   RESULT=$?
   if [ $RESULT -eq 0 ]; then
      /usr/bin/rsync -aq --delete-delay --timeout=900 $2 $ROOT/$1/ > /dev/null
      RESULT=$?
   fi
   echo $RESULT > $ROOT/.$1.status
   if [ $RESULT -eq 0 ]; then
      count $1
   fi
}

# centos
rsync_rhel centos mirrors.ustc.edu.cn::centos
unset RESULT

# epel
rsync_rhel epel mirrors.ustc.edu.cn::fedora-epel
if [ $RESULT -eq 0 ]; then
   /usr/bin/report_mirror > /dev/null
fi
unset RESULT

# repoforge
rsync_rhel repoforge apt.sw.be::pub/freshrpms/pub/dag/
unset RESULT

# ubuntu
rsync_debian ubuntu archive.ubuntu.com::ubuntu
if [ $RESULT -eq 0 ]; then
   date -u > $ROOT/ubuntu/project/trace/mirrors.neusoft.edu.cn
fi
unset RESULT

# ubuntu-release
rsync_common ubuntu-releases rsync.releases.ubuntu.com::releases
if [ $RESULT -eq 0 ]; then
   date -u > $ROOT/ubuntu-releases/.trace/mirrors.neusoft.edu.cn
fi
unset RESULT

# archlinux
rsync_common archlinux ftp.tku.edu.tw::archlinux
unset RESULT

# gentoo
rsync_common gentoo rsync.us.gentoo.org::gentoo
unset RESULT

# gentoo-portage
rsync_common gentoo-portage rsync.us.gentoo.org::gentoo-portage
unset RESULT

# cpan
rsync_common cpan cpan-rsync.perl.org::CPAN
unset RESULT

# apache
rsync_common apache rsync.apache.org::apache-dist
unset RESULT

# cygwin
rsync_common cygwin mirrors.kernel.org::sourceware/cygwin/
unset RESULT

# eclipse
rsync_common eclipse download.eclipse.org::eclipseMirror
unset RESULT

# mozilla-current
rsync_common mozilla-current releases-rsync.mozilla.org::mozilla-current
unset RESULT

# putty
rsync_common putty rsync.chiark.greenend.org.uk::ftp/users/sgtatham/putty-website-mirror/
unset RESULT

rm -f $LOCK
