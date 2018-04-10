#!/bin/bash
latexpand --keep-comments texpack.tex > tmpDocs/expanded.tex
cd tmpDocs
perl ./docextract.pl -i expanded.tex -T './' --skeleton=docskeleton.tex -v > docout.tex
