$dest = "C:\Users\russh\Git\WinLua-Mk3\Deploy\x86\libressl"

cp "C:\\Users\\russh\\git\\WinLua-Mk3\\Sources\\libressl\\build-2.9.0\\apps\\openssl\\Debug\\openssl.exe"  $dest

cp "C:\Users\russh\git\WinLua-Mk3\Sources\libressl\build-2.9.0\crypto\Debug\crypto-*.dll" $dest
cp "C:\Users\russh\git\WinLua-Mk3\Sources\libressl\build-2.9.0\ssl\Debug\ssl-*.dll" $dest
cp "C:\Users\russh\git\WinLua-Mk3\Sources\libressl\build-2.9.0\tls\Debug\tls-*.dll" $dest


$dest = "C:\Users\russh\Git\WinLua-Mk3\Deploy\x64\libressl"


cp "C:\\Users\\russh\\git\\WinLua-Mk3\\Sources\\libressl\\build-2.9.0-x64\\apps\\openssl\\Debug\\openssl.exe"  $dest

cp "C:\Users\russh\git\WinLua-Mk3\Sources\libressl\build-2.9.0-x64\crypto\Debug\crypto-*.dll" $dest
cp "C:\Users\russh\git\WinLua-Mk3\Sources\libressl\build-2.9.0-x64\ssl\Debug\ssl-*.dll" $dest
cp "C:\Users\russh\git\WinLua-Mk3\Sources\libressl\build-2.9.0-x64\tls\Debug\tls-*.dll" $dest
