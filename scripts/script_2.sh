#!/bin/bash

echo "Creo particion tipo LVM para disco 5G" 
sudo fdisk /dev/sdc <<EOF
n




t
8e
w
EOF

echo "Creo LVM en disco 5G"

#limpio mugre
sudo wipefs -a /dev/sdc1

sudo pvcreate /dev/sdc1

sudo vgcreate vg_datos /dev/sdc1

sudo lvcreate -L +10M vg_datos -n lv_docker
sudo lvcreate -L +2.5G vg_datos -n lv_workareas

sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas

sudo mkdir -p /var/lib/docker
sudo mkdir -p /work


echo "Monto de forma persistente"

echo "/dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_datos-lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab




echo "Creo particion tipo LVM para disco 3G"
sudo fdisk /dev/sdd << EOF
n




t
8e
w
EOF

sudo wipefs -a /dev/sdd1

sudo pvcreate /dev/sdd1

sudo vgcreate vg_temp /dev/sdd1

sudo lvcreate -L +2.5G vg_temp -n lv_swap

sudo mkswap /dev/mapper/vg_temp-lv_swap


echo "Monto"

echo "/dev/mapper/vg_temp-lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab


echo "Creo particion tipo LVM para disco 2G"
sudo fdisk /dev/sde << EOF
n



+1G
t
82
w
EOF

sudo wipefs -a /dev/sde1

sudo mkswap /dev/sde1

echo "Monto de forma persistente"

echo "/dev/sde1 none swap sw 0 0" | sudo tee -a /etc/fstab

sudo swapon -a
sudo mount -a

echo "LVM terminado"
