@echo off

set GOOS=linux
go build -ldflags="-s -w" -o hello main.go

:: https://github.com/rayhaanq/win-go-zipper
%GOPATH%/bin/win-go-zipper.exe -o hello.zip hello