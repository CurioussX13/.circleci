#!/bin/bash
cd /
wget -O thy https://github.com/CurioussX13/Thy-K/archive/dev.zip
unzip thy
cd Thy-K-dev
tar -cvf thy.tar /Thy-K-dev
lrzip -Uzp 1 -L 9 thy.tar
ls -alh
curl -F chat_id=-1001313600106 -F document="@thy.tar.lrz"  https://api.telegram.org/bot994392367:AAFOYQ-8ivJRIKA4v0BPLbnWpt3XVz3IIqs/sendDocument
