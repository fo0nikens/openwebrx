#!/usr/bin/env bash
set -euo pipefail

debuild -uc -us

cd ..

export GPG_TTY=$(tty)
gpg --batch --import <(echo "$SIGN_KEY")
for DEB in `ls *.deb`; do
    debsigs --sign=maint -k $SIGN_KEY_ID $DEB
done

dpkg-deb -I *.deb

tar cvfz packages.tar.gz *.deb