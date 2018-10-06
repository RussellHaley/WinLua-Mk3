cd Sources/libressl
mkdir build-vs2017
cd build-vs2017
cmake -DBUILD_SHARED_LIBS=ON -G"Visual Studio 15 2017" ..
