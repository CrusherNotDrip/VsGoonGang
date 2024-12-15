@echo off
color 0a
cd ..
@echo on
echo Installing dependencies.
haxelib install lime 8.0.1
haxelib install openfl 9.3.2
haxelib install flixel 5.5.0
haxelib install flixel-addons 3.2.1
haxelib install flixel-ui 2.5.0
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
haxelib git hxdiscord_rpc 1.2.4
haxelib install hxvlc 1.8.2
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib install SScript 7.7.0
haxelib install tjson 1.4.0
echo Finished!
pause