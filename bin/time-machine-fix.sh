#! /usr/bin/env bash
echo "If there are problems, you can repair the disk with:
fsck_hfs -drfy /dev/disk1s2
When done, execute:
hdiutil detach /dev/disk1s2
vi /Volumes/TimeMachine/Clarence.sparsebundle/com.apple.TimeMachine.MachineID.plist.
"
set -ex
chflags -R nouchg /Volumes/TimeMachine/Clarence.sparsebundle
hdiutil attach -nomount -noverify -noautofsck /Volumes/TimeMachine/Clarence.sparsebundle
tail -f /var/log/fsck_hfs.log

