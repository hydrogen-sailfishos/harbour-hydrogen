This is a wrapper around the [matrix](https://matrix.org) client [hydrogen](https://github.com/vector-im/hydrogen-web) for [SailfishOS](https://sailfishos.org)

Issues, bug reports and feature requests are welcome in the issue tab above.

If you want to help developing, you can either head over to hydrogen, if its specifically about the functionality of hydrogen,
or help here, if it has something to do with SailfishOS. In case of doubt, ask here first.


# Development

## Building:

Overview:
 1. checkout this project
 2. checkout [modified hydrogen web](https://github.com/thigg/hydrogen-web/tree/sfos)
 3. build hydrogen web
 4. link hydrogen build artifacts into this project
 5. build this project

Something like this:
```bash
git clone https://github.com/thigg/hydrogen-web.git
cd hydrogen-web
git switch sfos
yarn install # for build dependencies see the hydrogen-web project
yarn build
cd ..
git clone https://github.com/thigg/sfos-hydrogen.git
cd sfos-hydrogen
ln -s ../hydrogen-web/target ./hydrogen
```
## Developing

If you are working at hydrogen, you can simply simlink the hydrogen folder in `/usr/lib/harbour-hydrogen/hydrogen` to your home folder and rsync your hydrogen files there.

## Debugging

You can get more logs out of hydrogen, if you start it with `EMBED_CONSOLE=1 sailfish-qml harbour-hydrogen`

You can also start the browser the same way: `EMBED_CONSOLE=1 sailfish-browser /usr/share/harbour-hydrogen/hydrogen/index.html`
