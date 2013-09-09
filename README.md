iostoolchain
============

1. Requirments : you need to have a  working C compiler and a good internet connection. 
2. Installation : Just make git clone and run ./script.sh . It will install the toolchain under your home directory.
3. Run : To use your cross-compiler : ios-clang yourfile.c(or c++ or m), you can make ios+Tab to see other commands.     
    ldid : codesign tool, with armv7/armv7s support and other changes from orig version. it will be called by ld64.
    ios-clang-wrapper : automatically find SDK and construct proper compilation args.
    ios-switchsdk : switch sdk when multiple version of SDK exist.
    ios-pngcrush: png crush/de-crush tool, like Apple's pngcrush.
    ios-createProject : project templates
    ios-genLocalization : iOS app localization tool based on clang lexer.
    ios-plutil : plist compiler/decompiler.
    ios-xcbuild : convert xcode project to makefile, build xcode project directly under linux. 