cd $sourceDir;
cp $tmpDir/handin.sty ./


# cp bin/example.pdf ./
cp example.tex ./handin
cp img/universityTromsoLogo.pdf ./handin

cp layout.tex handin/

cd handin/
outHandle "Error in latexmk example" latexmk -pdf "example.tex" -outdir="./bin" --shell-escape -interaction=nonstopmode -f
outHandle "Error in latexmk layout" latexmk -pdf "layout.tex" -outdir="./bin" --shell-escape -interaction=nonstopmode -f
cp bin/example.pdf ./
cp bin/layout.pdf ./
rm -rf bin
rm layout.tex
cd ../
# rm example.zip
# zip example.zip example.tex example.pdf img/universityTromso.pdf

# cp example.zip ../
# cp example.zip handin/

rm ../example.tex
cp example.tex ../

rm ../handin.sty
cp handin.sty ../

rm -rf ../img
cp -r ./img ../

rm ../layout.pdf
cp layout.pdf ../

zip handinCTAN.zip -r handin/
mv handinCTAN.zip ../
rm -rf ../handin
mv handin ../
# unzip example.zip -d example
echo "Tag as v${version}b$build"
