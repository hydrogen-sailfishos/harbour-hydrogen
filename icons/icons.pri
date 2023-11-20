# uncommenting this will break qmake!
# OTOH it will enable a pure QML app to be built without the Qt
# devel packages installed:
# TEMPLATE = aux

# Configures svg to png
THEMENAME = sailfish-default
INSTALLS += svg appicon

QMAKE_CLEAN += -r ${_PRO_FILE_PWD_}/icons/z*
QMAKE_CLEAN += -r ${_PRO_FILE_PWD_}/icons/*x*

appicon.sizes = \
    86 \
    108 \
    128 \
    172 \
    256 \
    512 \
    1024

for(iconsize, appicon.sizes) {
    profile = $${iconsize}x$${iconsize}

    system(mkdir -p $${_PRO_FILE_PWD_}/icons/$${profile})

    appicon.commands += /usr/bin/sailfish_svg2png \
        -z 1.0 -s 1 1 1 1 1 1 $${iconsize} \
        $${_PRO_FILE_PWD_}/icons/svgs \
        $${_PRO_FILE_PWD_}/icons/$${profile}/apps &&

    appicon.files += $${_PRO_FILE_PWD_}/icons/$${profile}
}
appicon.commands += true
appicon.path = $$PREFIX/share/icons/hicolor/
appicon.CONFIG += no_check_exist


# also install SVG:
svg.path = $$PREFIX/share/icons/hicolor/scalable/apps
svg.files = $${_PRO_FILE_PWD_}/icons/svgs/$${TARGET}.svg
