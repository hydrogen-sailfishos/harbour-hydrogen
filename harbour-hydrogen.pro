TEMPLATE = app
TARGET = harbour-hydrogen

CONFIG += sailfishapp

SOURCES += src/$${TARGET}.cpp
INCLUDEPATH += .

DISTFILES += qml/harbour-hydrogen.qml \
    qml/HydrogenWebView.qml \
    qml/cover/CoverPage.qml \
    qml/framescript.js \
    qml/server.py \
    rpm/harbour-hydrogen.changes \
    rpm/harbour-hydrogen.spec \
    translations/*.ts \
    harbour-hydrogen.desktop \
    50-$${TARGET}.conf

webapp.path += /usr/share/harbour-hydrogen/hydrogen
webapp.files = hydrogen/target/*

INSTALLS += webapp

sdconf.files += 50-$${TARGET}.conf
sdconf.path += /usr/lib/systemd/user/user-session.target.d
INSTALLS += sdconf

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-hydrogen-de.ts
