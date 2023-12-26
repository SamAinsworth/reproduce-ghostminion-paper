cd ..
BASE=$(pwd)
git clone https://github.com/arm-university/arm-gem5-rsk.git
wget http://parsec.cs.princeton.edu/download/3.0/parsec-3.0.tar.gz
tar -xvzf parsec-3.0.tar.gz
cd parsec-3.0
rm pkgs/*/*/inputs/input_native.tar
rm ext/splash2x/*/*/inputs/input_native.tar
patch -p1 < ../arm-gem5-rsk/parsec_patches/static-patch.diff
cd ..
mkdir temp
cd temp
wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'
wget -O config.sub 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'
cd ..
cd parsec-3.0
find . -name "config.guess" -type f -print -execdir cp {} config.guess_old \;
find . -name "config.guess" -type f -print -execdir cp $BASE/temp/config.guess {} \;
find . -name "config.sub" -type f -print -execdir cp {} config.sub_old \;
find . -name "config.sub" -type f -print -execdir cp $BASE/temp/config.sub {} \;
# Step below is slightly different from in gem5-rsk.pdf. Hope it works 4 u
cd $BASE
sed -i -e 's/<gcc-linaro directory>/\/usr/g' arm-gem5-rsk/parsec_patches/xcompile-patch.diff
cd parsec-3.0
patch -p1 < ../arm-gem5-rsk/parsec_patches/xcompile-patch.diff
export PARSECPLAT="aarch64-linux" # set the platform
source ./env.sh

parsecmgmt -a build -c gcc-hooks -p blackscholes canneal ferret fluidanimate freqmine streamcluster swaptions
cd $BASE
wget http://dist.gem5.org/dist/current/arm/aarch-system-201901106.tar.bz2
wget http://dist.gem5.org/dist/current/arm/disks/aarch64-ubuntu-trusty-headless.img.bz2
bzip2 -d aarch64-ubuntu-trusty-headless.img.bz2
dd if=/dev/zero bs=1G count=5 >> ./aarch64-ubuntu-trusty-headless.img
sudo parted aarch64-ubuntu-trusty-headless.img resizepart 1 100% # grow partition 1
mkdir disk_mnt
name=$(sudo fdisk -l aarch64-ubuntu-trusty-headless.img | tail -1 | awk -F: '{ print $1 }' \
| awk -F" " '{ print $1 }')
start_sector=$(sudo fdisk -l aarch64-ubuntu-trusty-headless.img | grep $name | awk -F" " '{ print $2 }')
units=$(sudo fdisk -l aarch64-ubuntu-trusty-headless.img | grep Units | awk -F" " '{ print $8 }')
sudo mount -o loop,offset=$(($start_sector*$units)) aarch64-ubuntu-trusty-headless.img disk_mnt
loop=$(df | grep disk_mnt | awk '{ print $1 }')
sudo resize2fs $loop # resize filesystem
df #check that the Available space for disk_mnt is increased
sudo cp -r $BASE/parsec-3.0 disk_mnt/home/root # copy the compiled parsec-3.0 to the image
sudo umount disk_mnt
rm disk_mnt
mkdir aarch_system
cd aarch_system
tar -xvf aarch-system-201901106.tar.bz2
cd ..
mv aarch64-ubuntu-trusty-headless.img aarch_system/disks
cd $BASE
cd gem5/system/arm/dt
make
cd $BASE

cd arm-gem5-rsk/parsec_rcs
for bench in blackscholes canneal ferret fluidanimate freqmine streamcluster swaptions
do
  bash gen_rcs.sh -i simmedium -p $bench -n 4
done
cd $BASE
mkdir run_parsec
cd run_parsec
for bench in blackscholes canneal ferret fluidanimate freqmine streamcluster swaptions
do
  mkdir $bench
done

