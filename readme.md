QT minimal static
=================

Minimal project for test static linking with QT5

```bash
    mkdir build
    cd build
    cmake ..
    make
```

Supported OSX 
-------------

LTS 5.12.4 1.07.2019

Supported only latest SDK 10.14. Building and linking with static version allow only on
Mojave 10.14!

Error with static linking on 10.13:

    Undefined symbols for architecture x86_64:
        "_NSAppearanceNameDarkAqua", referenced from:
            qt_mac_applicationIsInDarkMode() in libQt5Core.a(qcore_mac_objc.o)

Minimal deployment target for Qt - 10.12.
Need explicit set(CMAKE_OSX_DEPLOYMENT_TARGET "10.12" CACHE STRING "Minimum OS X deployment version")
or export MACOSX_DEPLOYMENT_TARGET=10.12 when building app. Otherwise Launch Services error on the 
10.13 (run from Finder):

    open -a qtminimal
    LSOpenURLsWithRole() failed with error -10825 for the file /Users/svolkov/Downloads/qtminstatic.app.

In the [Apple Launch Services Docs](https://developer.apple.com/documentation/coreservices/launch_services?language=objc#1661359)
found error kLSIncompatibleSystemVersionErr = -10825

Problems with Qt core not on Mojave
-----------------------------------

**Important!!** If you want build app on 10.13 need QT builded on SDK 10.13 (not supported now!!)
Otherwise static linking finished with error. 

Week linking allow run code compiled from sdk 10.14 on lower platform, but static linking not found this function.
QT tested code on latest platform only!!

Problem with new function which not exist on 10.13.
If build with 10.14 SDK called function specified for this platform. Week linking allow run
this code for normal (shared) Qt. For static build this function not founded on lower platform.

Example using QT_MACOS_PLATFORM_SDK_EQUAL_OR_ABOVE(__MAC_10_14)
 
```c++
# qtbase/src/corelib/kernel/qcore_mac_objc.mm
#
bool qt_mac_applicationIsInDarkMode()
{
#if QT_MACOS_PLATFORM_SDK_EQUAL_OR_ABOVE(__MAC_10_14)
    if (__builtin_available(macOS 10.14, *)) {
        auto appearance = [NSApp.effectiveAppearance bestMatchFromAppearancesWithNames:
                @[ NSAppearanceNameAqua, NSAppearanceNameDarkAqua ]];
        return [appearance isEqualToString:NSAppearanceNameDarkAqua];
    }
#endif
    return false;
}
```

Error with static linking on 10.13:

    Undefined symbols for architecture x86_64:
        "_NSAppearanceNameDarkAqua", referenced from:
            qt_mac_applicationIsInDarkMode() in libQt5Core.a(qcore_mac_objc.o)

On Qt 5.12.4 - bug need patch - bug report QTBUG-76777 created.

```bash
    cd [QT_SRC]
    patch -p1 < <PATH>/qcore.patch
```

Check and select SDK  
 
```bash
# print current SDK
xcode-select -p
# SDK version
xcrun -sdk macosx --show-sdk-path
xcrun --show-sdk-path
xcrun --show-sdk-version
```

SDK 10.13 - in the XCode 9.
 
You can download CommandLineTool from https://developer.apple.com/download

[switch between multiple version of Command Line Tools](https://stackoverflow.com/questions/47455245/how-to-switch-between-multiple-command-line-tools-installations-in-mac-os-x-wit)

Qt static build from source
---------------------------

```bash
# static build QT to QT_INSTALL_DIR/static_64
# Qt LTS 5.12.4
./configure -opensource  -confirm-license -static --prefix=../static_64 -debug-and-release \
    -qt-zlib -qt-libpng -qt-freetype -qt-libjpeg \
    -no-gif -no-cups -no-iconv -no-pch -no-dbus -no-opengl -no-fontconfig -no-openssl \
    -make libs -nomake examples -nomake tests \
    -skip qt3d -skip qtactiveqt -skip qtandroidextras -skip qtcanvas3d -skip qtcharts -skip qtconnectivity \
    -skip qtdatavis3d -skip qtdeclarative -skip qtdoc -skip qtgamepad -skip qtgraphicaleffects \
    -skip qtimageformats -skip qtlocation -skip qtmacextras -skip qtmultimedia -skip qtnetworkauth \
    -skip qtpurchasing -skip qtquickcontrols -skip qtquickcontrols2 -skip qtremoteobjects -skip qtscript -skip qtscxml \
    -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtsvg \
    -skip qttranslations -skip qtvirtualkeyboard -skip qtwayland -skip qtwebchannel -skip qtwebengine \
    -skip qtwebglplugin -skip qtwebsockets -skip qtwebview -skip qtwinextras -skip qtx11extras -skip qtxmlpatterns
make j6
make install
```

change code for static build
----------------------------

   The Qt modules' export macros.
   The options are:
    - defined(QT_STATIC): Qt was built or is being built in static mode
    - defined(QT_SHARED): Qt was built or is being built in shared/dynamic mode

Plugins not loaded in the static build. Need explicitly import plugins.

```c++
    #ifdef QT_STATIC
    QT_BEGIN_NAMESPACE
    Q_IMPORT_PLUGIN (QCocoaIntegrationPlugin);
    Q_IMPORT_PLUGIN (QMacStylePlugin);
    QT_END_NAMESPACE
    #endif
```
