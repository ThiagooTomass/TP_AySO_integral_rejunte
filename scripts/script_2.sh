#./bin/bash

echo "Creo particion tipo LVM para disco 5G" 
sudo fdisk /dev/sdg <<EOF
n




t
8e
w
EOF

echo "Creo LVM en disco 5G"

#limpio mugre
sudo wipefs -a /dev/sdg1

sudo pvcreate /dev/sdg1

sudo vgcreate vg_datos /dev/sdg1

sudo lvcreate -L +10M vg_datos -n lv_docker
sudo lvcreate -L +2.5G vg_datos -n lv_workareas

sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas


echo "Monto de forma persistente"

sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0 | sudo tee -a /etc/fstab

sudo mount /dev/mapper/vg_datos-lv_workareas /work ext4 defaults 0 0 | sudo tee -a /etc/fstab




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

sudo mkfs.ext4 /dev/mapper/vg_temp-lv_swap


echo "Monto de forma persistente"

sudo mount /dev/mapper/vg_temp-lv_swap "Aca punto de montaje" ext4 defaults 0 0 | sudo tee -a /etc/fstab




echo "Creo particion tipo LVM para disco 2G"
sudo fdisk /dev/sde << EOF
n



+1G
t
82
w
EOF
