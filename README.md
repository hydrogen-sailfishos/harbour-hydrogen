# hydrogen packaged for sailfishos web

experimental packaging of hydrogen for sailfishos.

TODO:
 - notifications


Please submit bug reports/anything in the issue tracker.

If you are sure, that this is a bug with hydrogen and not with this packaging, please submit it to hydrogen-web directly.

PRs welcome


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


If you are working at hydrogen, you can simply simlink the hydrogen folder in `/usr/lib/harbour-hydrogen/hydrogen` to your home folder and rsync your hydrogen files there.


