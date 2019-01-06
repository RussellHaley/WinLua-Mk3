param (
    [Parameter(Mandatory=$true)][string]$version
    #~ [string]$password = $( Read-Host "Input password, please" )
 )

$test = $null
function final($code)
{
	cd $orig_dir
	#~ write-host $code
	exit $code
}

function GenerateSLNFiles()
{
	cd Sources/libressl
	mkdir $build_dir
	cd $build_dir
	cmake -DBUILD_SHARED_LIBS=ON -G"Visual Studio 15 2017" ..

	cd ..
	mkdir "$build_dir-x64"
	cd "$build_dir-x64"
	cmake -DBUILD_SHARED_LIBS=ON -G"Visual Studio 15 2017 Win64" ..
}

$orig_dir = $pwd
cd Sources/libressl
 
 write-host "version is $version"
 #~ git branch -l | grep "$version"
 write-host "git branch -l | grep $version"
$test = $(git branch -l | grep '$version')
write-host "recieved $test"
if($test)
{
	#~ $test = $(git checkout "v$version")
	echo $test
	if($test) 
	{
		write-host 'we are good'
	}
	final (1)
}
else
{
	write-host "Not a valid version. Check 'git tag -l'"
	final (-1)
}

$build_dir = "build-" + $version

