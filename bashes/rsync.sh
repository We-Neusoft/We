#!/bin/bash

LOCK=/tmp/rsyncing
ROOT=/storage/mirror

[ -f $LOCK ] && exit 0

touch $LOCK

function count {
   find $ROOT/$1 -type f | wc -l > /tmp/.$1.count
   du -bs $ROOT/$1 | awk '{print $1}' > /tmp/.$1.size
   date "+%Y-%m-%d %H:%M:%S %Z" > /tmp/.$1.timestamp
   mv /tmp/.$1.* $ROOT
}

function rsync_common {
   echo -1 > $ROOT/.$1.status

   if [ $3 -eq 1 ]
   then
      /usr/bin/rsync -aHq --timeout=900 $2 $ROOT/$1/ > /dev/null
      return
   fi

   /usr/bin/rsync -aHq --delete-delay --timeout=900 $2 $ROOT/$1/ > /dev/null
   RESULT=$?

   echo $RESULT > $ROOT/.$1.status
   if [ $RESULT -eq 0 ]; then
      count $1
   fi
}

function rsync_rhel {
   echo -1 > $ROOT/.$1.status

   if [ $3 -eq 1 ]
   then
      /usr/bin/rsync -aHq --exclude="repomd.xml" --timeout=900 $2 $ROOT/$1/ > /dev/null
      return
   fi

   /usr/bin/rsync -aHq --exclude="repomd.xml" --timeout=900 $2 $ROOT/$1/ > /dev/null

   RESULT=$?
   if [ $RESULT -eq 0 ]
   then
      /usr/bin/rsync -aq --delete-delay --timeout=900 $2 $ROOT/$1/ > /dev/null
      RESULT=$?
   fi

   echo $RESULT > $ROOT/.$1.status
   if [ $RESULT -eq 0 ]
   then
      count $1
   fi
}

function rsync_debian {
   echo -1 > $ROOT/.$1.status

   if [ $3 -eq 1 ]
   then
      /usr/bin/rsync -aHq --exclude="Packages*" --exclude="Sources*" --exclude="Release" --timeout=900 $2 $ROOT/$1/ > /dev/null
      return
   fi

   /usr/bin/rsync -aHq --exclude="Packages*" --exclude="Sources*" --exclude="Release" --timeout=900 $2 $ROOT/$1/ > /dev/null

   RESULT=$?
   if [ $RESULT -eq 0 ]
   then
      /usr/bin/rsync -aq --delete-delay --timeout=900 $2 $ROOT/$1/ > /dev/null
      RESULT=$?
   fi

   echo $RESULT > $ROOT/.$1.status
   if [ $RESULT -eq 0 ]
   then
      count $1
   fi
}

# centos
rsync_rhel centos mirrors.ustc.edu.cn::centos 1
rsync_rhel centos msync.centos.org::CentOS 2
unset RESULT

# epel
rsync_rhel epel mirrors.ustc.edu.cn::fedora-epel 0
if [ $RESULT -eq 0 ]; then
   /usr/bin/report_mirror > /dev/null
fi
unset RESULT

# repoforge
rsync_rhel repoforge apt.sw.be::pub/freshrpms/pub/dag/ 0
unset RESULT

# ubuntu
rsync_debian ubuntu mirrors.ustc.edu.cn::ubuntu 1
rsync_debian ubuntu archive.ubuntu.com::ubuntu 2
if [ $RESULT -eq 0 ]; then
   date -u > $ROOT/ubuntu/project/trace/mirrors.neusoft.edu.cn
fi
unset RESULT

# ubuntu-release
rsync_common ubuntu-releases mirrors.ustc.edu.cn::ubuntu-releases 1
rsync_common ubuntu-releases rsync.releases.ubuntu.com::releases 2
if [ $RESULT -eq 0 ]; then
   date -u > $ROOT/ubuntu-releases/.trace/mirrors.neusoft.edu.cn
fi
unset RESULT

# archlinux
rsync_common archlinux mirrors.ustc.edu.cn::archlinux 1
rsync_common archlinux ftp.tku.edu.tw::archlinux 2
unset RESULT

# gentoo
rsync_common gentoo mirrors.ustc.edu.cn::gentoo 1
rsync_common gentoo ftp.ussg.iu.edu::gentoo-distfiles 2
unset RESULT

# pypi
echo -1 > $ROOT/.pypi.status
/usr/bin/pep381run -q $ROOT/pypi/ > /dev/null
RESULT=$?
echo $RESULT > $ROOT/.pypi.status
if [ $RESULT -eq 0 ]
then
   count pypi
else
   /usr/bin/pep381checkfiles $ROOT/pypi/ > /dev/null &
fi
unset RESULT

# cygwin
rsync_common cygwin mirrors.kernel.org::sourceware/cygwin/ 0
unset RESULT

# eclipse
rsync_common eclipse download.eclipse.org::eclipseMirror 0
unset RESULT

# putty
rsync_common putty rsync.chiark.greenend.org.uk::ftp/users/sgtatham/putty-website-mirror/ 0
unset RESULT

# android
echo -1 > $ROOT/.android.status
/root/shell/android-mirror.py
RESULT=$?
echo $RESULT > $ROOT/.android.status
if [ $RESULT -eq 0 ]; then
   count android
fi
unset RESULT

# qt
rsync_common qt master.qt-project.org::qt-all 0
unset RESULT

rm -f $LOCK
