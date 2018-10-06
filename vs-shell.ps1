Import-Module Pscx

#~ Original saved for posterity
#~ function Import-VS9Vars
#~ {
    #~ $vcargs = ?: {$Pscx:Is64BitProcess} {'amd64'} {'x86'}
    #~ Push-EnvironmentBlock -Description "Before importing VS 2008 $vcargs var"
    #~ Invoke-BatchFile "${env:VS90COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
#~ }

function Import-VSVars
{
	$envcmd = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\*\*\Common7\Tools\VsDevCmd.bat"
	$ok = ls $envcmd
	if($ok){
		Echo "Found" $envcmd
		Push-EnvironmentBlock -Description "Before importing VS 2010 $vcargs vars"		
		Invoke-BatchFile $ok.FullName
		#~ ls env:*
    }
    else{
		Echo "Couldn't find" .. $envcmd
    }
    
}

Import-VSVars
