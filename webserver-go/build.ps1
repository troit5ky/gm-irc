$env:GOOS="windows"
$env:GOARCH="amd64"
echo "Building win-x64..."
go build main.go
Rename-Item -NewName win-x64.exe -Path .\main.exe

$env:GOARCH="386"
echo "Building win-x32..."
go build main.go
Rename-Item -NewName win-x32.exe -Path .\main.exe

$env:GOOS="linux"
$env:GOARCH="amd64"
echo "Building linux-x64..."
go build main.go
Rename-Item -NewName linux-x64 -Path .\main

$env:GOARCH="386"
echo "Building linux-x32..."
go build main.go
Rename-Item -NewName linux-x32 -Path .\main

echo "Build finished!"