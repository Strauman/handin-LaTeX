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
