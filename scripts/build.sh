# For Ubuntu 21 and higher, run build.sh
# with the following command:
#
# CC=gcc-11 CXX=g++-11 CXXFLAGS="-I/usr/include" LDFLAGS="-L/usr/lib/x86_64-linux-gnu" ./build.sh

cd ../gem5
scons -j4 build/ARM/gem5.opt
cd ../scripts
