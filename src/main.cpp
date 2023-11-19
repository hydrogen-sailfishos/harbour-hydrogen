/*
 * Minimal SailfishApp.
 *
 * The sole reason for this is to produce a binary, because the booster-browser
 * service will only launch binaries, not qmlscene, not sailfish-qml, etc.
 *
 */

#include <sailfishapp.h>

int main(int argc, char **argv) {
   return SailfishApp::main(argc,argv);
}
