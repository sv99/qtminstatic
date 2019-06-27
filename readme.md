QT minimal static
=================

Minimal project for test static linking QT5

**Important!!** Need static build Qt on sdk 10.13. 
 
    # print current SDK
    xcode-select -p
    # SDK version
    xcrun -sdk macosx --show-sdk-path
    xcrun --show-sdk-path
    xcrun --show-sdk-version

**Important!!** SDK must be 10.13 - if system not Mojave!!  On the fly switch fail.
Need reset cmake cache.  

    # static build QT
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
    make
    make install


Week linking allow run cod compilled from sdk 10.14 allow run function on lower platform.

    # corelib/kernel/qcore_mac_objc.mm
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

Error with static linking on 10.13:

    Undefined symbols for architecture x86_64:
        "_NSAppearanceNameDarkAqua", referenced from:
            qt_mac_applicationIsInDarkMode() in libQt5Core.a(qcore_mac_objc.o)

static linking
--------------
