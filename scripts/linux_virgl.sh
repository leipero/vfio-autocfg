#!/bin/bash

## Load the config file
source "${BASH_SOURCE%/*}/config"

## QEMU (VM) command
qemu-system-x86_64 -enable-kvm -M q35 -vga virtio -display gtk,gl=on \
  -m $RAM -cpu host,hypervisor,topoext -rtc clock=host,base=localtime \
  -smp $CORES,sockets=1,cores=$(( $CORES / 2 )),threads=2 \
  -usb -device usb-tablet \
  -soundhw all \
  -drive if=pflash,format=raw,readonly,file=$OVMF \
  -drive if=virtio,file=$LINUX_IMG,format=qcow2,cache=none,aio=threads \
  -drive file=$LINUX_ISO,index=1,media=cdrom >> $LOG 2>&1 &

## NVME emulation:
# -device nvme,drive=NVME1,serial=nvme-1 -drive id=NVME1,if=none,cache=off,aio=threads,format=qcow2,file=$LINUX_IMG \
## VHD: 
# -drive if=virtio,file=$LINUX_IMG,format=qcow2,cache=none,aio=threads \
## Pulseaudio (if too much cracking, could help, replace -soundhw all \):
# -audiodev pa,id=snd,server=/run/user/1000/pulse/native -device ich9-intel-hda -device hda-output,audiodev=snd \
## CDROM:
# -drive file=$LINUX_ISO,index=1,media=cdrom \
# -drive file=$TEMP_ISO,index=2,media=cdrom \
## Virgl:
# If virglrenderer version (now at 0.8.2) have black glitches/boxes etc., downgrade to 0.7.0 version and sumlink (Arch):
# ln -sf /usr/lib/libvirglrenderer.so.0 /usr/lib/libvirglrenderer.so.1

## Wait for QEMU
wait
