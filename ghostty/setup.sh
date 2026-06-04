#!/bin/zsh

set -Ceu
cd $(dirname $0)

TARGET_DIR=$HOME/.config/ghostty
if ! [ -d $TARGET_DIR ]; then
    mkdir $TARGET_DIR
fi

# ディレクトリ構造を再現
DIRS=`find . -type d -mindepth 1 | sed 's|^\./||'`
for DIR in $DIRS; do
    TARGET_SUB_DIR="$TARGET_DIR/$DIR"
    if ! [ -d $TARGET_SUB_DIR ]; then
        mkdir $TARGET_SUB_DIR
    fi
done

# シンボリックリンクを作成
FILES=`find . -type f ! -name setup.sh | sed 's|\./||'`
for FILE in $FILES; do
    ln -snfv ${PWD}/$FILE $TARGET_DIR/$FILE
done
