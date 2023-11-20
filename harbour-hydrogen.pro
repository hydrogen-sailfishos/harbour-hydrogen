TARGET = harbour-hydrogen

CONFIG += sailfishapp_qml

DISTFILES += \
    qml/harbour-hydrogen.qml \
    qml/HydrogenWebView.qml \
    qml/HydrogenWebViewPage.qml \
    qml/cover/HydrogenCover.qml \
    qml/framescript.js \
    qml/notificationCount.js \
    qml/server.py \
    rpm/harbour-hydrogen.changes \
    rpm/harbour-hydrogen.spec \
    translations/*.ts \
    harbour-hydrogen.desktop \
    harbour-hydrogen-open-url.desktop

webapp.path += /usr/share/harbour-hydrogen/hydrogen
webapp.files = hydrogen/target/*

INSTALLS += webapp

desktop2.path += /usr/share/applications
desktop2.files = $${TARGET}-open-url.desktop

INSTALLS += desktop2

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# add sources only for updating translatin files
lupdate_only {
SOURCES += \
    qml/$${TARGET}.qml \
    qml/*.qml \
    qml/pages/*.qml \
    qml/cover/*.qml \
    qml/components/*.qml
}
TRANSLATIONS += translations/harbour-hydrogen-de.ts\
                translations/harbour-hydrogen-fr.ts\
                translations/harbour-hydrogen-ro.ts
