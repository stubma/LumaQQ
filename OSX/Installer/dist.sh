rm -rf ../build/Release/LumaQQ/*.framework
rm -rf ../build/Release/LumaQQ/*.mdimporter
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./DreamSound.pkg -proj DreamSound.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./QQSound.pkg -proj QQSound.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./SuperMarioSound.pkg -proj SuperMarioSound.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./WarCraft3Sound.pkg -proj WarCraft3Sound.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./iChatSound.pkg -proj iChatSound.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./TMSound.pkg -proj TMSound.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./IPSeekerQBar.pkg -proj IPSeekerQBar.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./SignatureQBar.pkg -proj SignatureQBar.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./WeatherQBar.pkg -proj WeatherQBar.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./iTunesQBar.pkg -proj iTunesQBar.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./LumaQQ_Main.pkg -proj LumaQQ_Main.pmproj
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -ds -v -p ./LumaQQ.mpkg -proj LumaQQ.pmproj
rm -rf *.pkg
