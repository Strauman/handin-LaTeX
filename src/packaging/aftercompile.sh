## texpack did add_to_CTANDir $docPDF $docTEX $pkgSTY $sourceDir/README.txt
## Creates example and put it into src/$packageDir
## Create example zip
## Creates src/example/
function latexBuild(){
  outHandle "Error in latexmk" latexmk -pdf "$1" -outdir="./bin" --shell-escape -interaction=nonstopmode -f
}
function make_example_and_layout(){
  # Creates src/example/ and src/example.zip
  pushd . >/dev/null
  cd $sourceDir
    add_to_CTANDir example.tex layout.tex #../img/universityTromsoLogo.pdf
  cd $CTANDir
    latexBuild "example.tex"
    latexBuild "layout.tex"

    cp "bin/example.pdf" $CTANDir
    cp "bin/layout.pdf" $CTANDir

    rm layout.tex

    if [ $clean = true ];then
      echo "Cleaning up example"
      rm -rf "./bin"
    fi
  popd > /dev/null
}
function make_github_readme(){
  rm "$mainDir/README.md.bak"
  mv "$mainDir/README.md" "$mainDir/README.md.bak"
  cp -f "$sourceDir/$packageSettingsDir/README.template.md" "$mainDir/README.md"
  add_version_vars_to "$mainDir/README.md"
}
function readme_tree(){
  pushd . > /dev/null
  cd "$CTANDir"
  file_structure=`tree . | awk "NR > 1" | sed '$d'`
  pattern="s/\#FILES/$file_structure/"
  perl -p -e "$pattern or next;" -i "$CTANDir/README.txt"
  popd > /dev/null
}
function finalize_paths(){
  cd "$mainDir"
  rm -rf "$mainDir/$CTANDirBase"
  mv "$CTANDir" "$mainDir"
  rm "$packagename.zip"
  outHandle "Error in zipping $packagename.zip" zip "$packagename.zip" -r "./$CTANDirBase"
  if [ -d "release" ]; then
    rm -rf "release"
  fi
  mv -f "$CTANDirBase" "release"
}

cd $sourceDir
rm -rf "$mainDir/$packagename/"
make_example_and_layout
readme_tree
make_github_readme
finalize_paths

echo "v${version}"
echo "b${build}"


# Expected files:
# - handin.sty : The handin package
# - handin-doc.pdf : Description of how the package works
# - handin-doc.tex : Source of handin-doc.tex
# - layout.pdf : Contains an overview on which macro goes where in the new \maketitle
# - example.pdf : Output of example.tex
# - example.tex : Contains example code
# - universityTromsoLogo.pdf : An image to be used in the example
