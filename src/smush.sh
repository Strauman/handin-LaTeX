#!/bin/bash
infile="smush.tex"
outfile="handin.sty"
cat packagehead.tex > $outfile
latexpand $infile >> $outfile

# Remove all blank lines
sed -i.bak -E '/./!d' $outfile
# Remove all makeatletter and makeatothers (not needed for .sty)
perl -i -pe 's/(\\makeatletter|\\makeatother)//g' $outfile
# Remove all indentation
sed -i -E 's/^[[:blank:]]*//' $outfile
# Remove all newlines
perl -0777 -i.bak -pe 's/\n/ /g' $outfile
# Remove all spaces before commands
perl -i -pe 's/(\\[a-z]+|\})\s+(\\[a-z]+)/\1\2/g' $outfile
# Remove all spaces at beginning of groups
perl -i -pe 's/\{\s+/\{/g' $outfile
# Remove all spaces at end of groups
perl -i -pe 's/\s+\}/\}/g' $outfile
# Add comment to top
cp $outfile tmpOut
echo "%% Source and documentation at https://github.com/Strauman/Handin-LaTeX" > $outfile
cat tmpOut >> $outfile
## Generate dependencylist from packages
perl -pe '/^\\usepackage\{([^\{]+)\}/\1/' packages.tex

## Create quickstart
rm quickstart.zip
zip quickstart.zip example.tex handin.sty img/universityTromso.pdf
pattNoUsepack=
perl -pe 's/^(?!\\usepackage).*//; s/^\\usepackage(?:\[[^\]]+\])?\{([^\{]+)\}/\1/;s/^\n//g' packages.tex > dependencies.txt
perl -i -pe 's/\n/,/g' dependencies.txt

mv quickstart.zip ../
rm handin.sty.bak
rm ../example.tex
rm ../handin.sty
rm -rf ../img
cp -r ./img ../
cp example.tex ../
cp handin.sty ../
cp layout.pdf ../
