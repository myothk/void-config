#!/bin/sh
case "$1" in
	*.tar* | *.tgz) tar tf "$1";;
	*.zip) unzip -l "$1";;
	*.rar) unrar l "$1";;
	*.7z) 7z l "$1";;
	*.pdf) echo "This is pdf file. Open it manually";;
	*.png | *.jpg | *.svg) chafa "$1" -f sixel -s "$2x$3" --animate false --polite on
		exit 1;;
#	*)[ -z $(highlight -O ansi "$1" || true) ] && cat "$1" || highlight -O ansi "$1";	
	*) cat "$1";;
esac
