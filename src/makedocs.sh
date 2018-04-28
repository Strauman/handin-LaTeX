#!/bin/bash
echo "Combining files"
latexpand --keep-comments handinpack.tex > tmpDocs/expanded.tex 2>./expand.log
if [ ! "$?" -eq "0" ];then
  echo "Something went wrong when combining files $exitCode"
  cat ./expand.log
  exit 1;
fi
rm ./expand.log
echo "Parsing docs"
cd tmpDocs
perl ./lib/docextract.pl -i expanded.tex -T './lib' --skeleton=docskeleton.tex -v > docout.tex
if [ ! "$?" -eq "0" ];then
  echo "Something went wrong when parsing docs"
  exit 1;
fi
echo "Cleaning up"
rm expanded.tex
echo "Docs are ready in handin-LaTeX/src/tmpDocs/docout.tex"
