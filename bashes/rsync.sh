#!/bin/bash

LOCK=/tmp/rsyncing
ROOT=/storage/mirror

[ -f $LOCK ] && exit 0

touch $LOCK

function set_status {
   echo -e "set $1_status 0 0 ${#2} noreply\r\n$2\r" | nc 127.0.0.1 11211
   echo $2 > $ROOT/.$1.status
}

function rsync {
   /usr/bin/rsync -aHq $3 --timeout=900 $2 $ROOT/$1/ > /dev/null
}

function rsync_call {
   set_status $1 -1

   if [ $3 -eq 1 ]
   then
      rsync $1 $2 "$4"
      return
   fi

   rsync $1 $2 "$4"

   RESULT=$?
   if [ $RESULT -eq 0 ]
   then
      rsync $1 $2 "--delete-delay"
      RESULT=$?
   fi

   set_status $1 $RESULT
   if [ $RESULT -eq 0 ]
   then
      /root/shell/count.sh $1
   fi
}

function rsync_rhel {
   rsync_call $1 $2 $3 "--exclude=\"repomd.xml\""
}

function rsync_debian {
   rsync_call $1 $2 $3 "--exclude=\"*Packages*\" --exclude=\"*Sources*\" --exclude=\"*Release\""
}

function rsync_common {
   rsync_call $1 $2 $3
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

# kali-images
rsync_debian kali-images archive-5.kali.org::kali-images 0
unset RESULT

# linuxmint
rsync_debian linuxmint packages.linuxmint.com::packages 0
unset RESULT

# linuxmint-releases
rsync_debian linuxmint-releases ftp.heanet.ie::pub/linuxmint.com/ 0
unset RESULT

# raspbian
rsync_debian raspbian archive.raspbian.org::archive 0
unset RESULT

# ubuntu-releases
rsync_common ubuntu-releases mirrors.ustc.edu.cn::ubuntu-releases 1
rsync_common ubuntu-releases rsync.releases.ubuntu.com::releases 2
if [ $RESULT -eq 0 ]; then
   date -u > $ROOT/ubuntu-releases/.trace/mirrors.neusoft.edu.cn
fi
unset RESULT

# archlinux
rsync_common archlinux ftp.tku.edu.tw::archlinux 0
unset RESULT

# gentoo
rsync_common gentoo ftp.ussg.iu.edu::gentoo-distfiles 0
unset RESULT

# gentoo-portage
rsync_common gentoo-portage rsync.us.gentoo.org::gentoo-portage 0
unset RESULT

# pypi
set_status pypi -1
/usr/bin/pep381run -q $ROOT/pypi/ > /dev/null
RESULT=$?
set_status pypi $RESULT
if [ $RESULT -eq 0 ]
then
   /root/shell/count.sh pypi
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
set_status android -1
/root/shell/android-mirror.py
RESULT=$?
set_status android $RESULT
if [ $RESULT -eq 0 ]; then
   /root/shell/count.sh android
fi
unset RESULT

# qt
rsync_common qt master.qt-project.org::qt-all 0
unset RESULT

# ldp
rsync_common ldp ftp.ibiblio.org::ldp_mirror 0
unset RESULT

rm -f $LOCK
