param (
    [Parameter(Mandatory=$true)][string]$version
    #~ [string]$password = $( Read-Host "Input password, please" )
 )

$test = $null

function back()
{
	cd $orig_dir
}
function final($code)
{
	back
	#~ write-host $code
	exit $code
}

function makeSlnFiles($x64)
{
	$build_dir = "build-" + $version
	$vsString = "Visual Studio 15 2017"
	$deployDir = "$pwd\Deploy\"
	if($x64)
	{
		$vsString = "$vsString" + " Win64"
		$deployDir = "$deployDir\x64"
		$build_dir = "$build_dir-x64"
	}
	else
	{
		$deployDir = "$deployDir\x86"
	}
	
	cd Sources/libressl
	mkdir $build_dir
	cd $build_dir
	cmake -DBUILD_SHARED_LIBS=ON -G"$vsString" -DCMAKE_INSTALL_PREFIX="$deploydir" ..

}

#Note this function doesn't work yet.
function gitCheckout()
{
	$orig_dir = $pwd
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
}

function main()
{
	
	write-host "Initializing LibreSSL version $version..."
}

Try{
	$orig_dir = $pwd
	main
	makeSlnFiles($false)
	back
	makeSlnFiles($true)
}
Catch
{
	$ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName

	write-host "LibreSSL Init failed: $ErrorMessage - $FailedItem"
}
Finally
{
	final
}
