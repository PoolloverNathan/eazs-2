#!/usr/bin/env nix-shell
#!nix-shell -p libarchive -i bash
set -e
cd $(mktemp -d)
trap "rm -rf $PWD" EXIT
ln -s ~-/mods mods
wget "https://nightly.link/Fabricators-of-Create/Create/workflows/build/mc1.20.1%2Ffabric%2Fdev/Artifacts.zip"
unzip Artifacts.zip
rm -f *-sources.jar mods/create-*.jar
mv *.jar mods/
