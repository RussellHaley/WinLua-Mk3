
$build_dir = "build-" + $args[0]

cd Sources/libressl
mkdir $build_dir
cd $build_dir
cmake -DBUILD_SHARED_LIBS=ON -G"Visual Studio 15 2017" ..

cd ..
mkdir $build_dir + "-64"
cd $build_dir + "-64"
cmake -DBUILD_SHARED_LIBS=ON -G"Visual Studio 15 2017 Win64" ..
