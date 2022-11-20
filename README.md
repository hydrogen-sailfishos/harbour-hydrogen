This is a wrapper around the [matrix](https://matrix.org) client [hydrogen](https://github.com/vector-im/hydrogen-web) for [SailfishOS](https://sailfishos.org)

Issues, bug reports and feature requests are welcome in the issue tab above.

If you want to help developing, you can either head over to hydrogen, if its specifically about the functionality of hydrogen,
or help here, if it has something to do with SailfishOS. In case of doubt, ask here first.


# Development

## Building:

Overview:
 1. checkout this project
 2. run `build.sh`
 3. ignore the non-working steps, but hydrogen should now be setup as submodule and built
 4. build this project

```
## Developing

If you are working at hydrogen, you can simply simlink the hydrogen folder in `/usr/lib/harbour-hydrogen/hydrogen` to your home folder and rsync your hydrogen files there.

## Debugging

You can get more logs out of hydrogen, if you start it with `EMBED_CONSOLE=1 sailfish-qml harbour-hydrogen`

You can also start the browser the same way: `EMBED_CONSOLE=1 sailfish-browser /usr/share/harbour-hydrogen/hydrogen/index.html`
