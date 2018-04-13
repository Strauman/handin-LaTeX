# Contributing
* [Installation](#getting-the-repo)
* [File structure](#file-structure)
* [How to document (.tex)](https://github.com/Strauman/Handin-LaTeX-template/blob/master/documentation-doc.tex)
* [Translations](#translations--languages)


## Getting the repo
Run `https://github.com/Strauman/Handin-LaTeX-template.git /path/to/where/you/want the files`
Then build the `src/main.tex` file with your favorite latex interpreter.

## File structure
If you have ideas and the like, you should first add them to the issue tracker before you start writing the code. This is that you can be sure we want the code in the package before you write it.

Check out [`documentation-doc.tex`](https://github.com/Strauman/Handin-LaTeX-template/blob/master/documentation-doc.tex) for instructions on how to document the code. All the documentation is automatically generated from the comments in the code using a custom `perl`-script. This file shows examples on how to document the code so that it shows up in the documentation properly.
All of the code are distributed within the `src`-folder. Here is an overview. Files in `src/packaging` are not a part of the actual package, but used for "compiling" it down to `handin.sty` and documenting.
### `src/`:
- `languages/` see next header (below) for translation instructions
- [`everypage.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/everypage.tex) contains logic for executing macros at every page. Mostly identical to the [everypage package](http://ctan.org/pkg/everypage)
- [`example.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/example.tex) is the file that will be posted as an example of use on CTAN
- [`exercisecmds.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/exercisecmds.tex) contains all commands related to creating problems and part problems
- [`handinsetup.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/handinsetup.tex)Contains all logic for user options.
- (`layout.tex`) is just used for creating the front page layout preview file on CTAN.
- [`main.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/main.tex) this is the main file you should be working in when you are working on the package
- [`preamble.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/preamble.tex) contains the preamble logic. This is where the user commands `\coursename`, `\institute` etc. are set. Except from that it's including other files and setting margins etc.
- [`settable.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/settable.tex) contains a macro for generating user-settables. See top of file for usage.
- (`texpack.tex`) is built when generating the `.sty` file
- [`titlemaker.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/titlemaker.tex) redefines `\maketitle` and sets front page style.
- [`pagestyle.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/pagestyle.tex) sets geometry, indentation, headers, footers, ect.
#### `src/packaging/`
- (`aftercompile.sh`) is just instructions to perform after the `.sty` and the documentation is created.
- (`packagehead.tex`): All the files are compiled into one `.sty`-file before sent to [CTAN](http://ctan.org). This file contains the top of that `.sty`-file.
- (`README.template.md`) is the template for what is used for the GitHub README file. It contains "variables"  with version and build info which are replaced by an automatic script.
- (`README.txt`) README file for CTAN.
- (`texpackvars.ini`) contains information about the version and the like for automatic package generation

## Translations / Languages
As of now there are not much to translate. However it might expand as the package grows. Here are instructions on how to translate:

In the `src/languages/` folder and check out the other translations.
Copy and paste the `enUS.tex` file and translate.

If you feel up for integrating it, this is what you do:
1. In the top you should change the comment line in the top of your new language file
```
%:$LANGUAGES.=\!item English
```
to
```
%:$LANGUAGES.=\!item theNewLanguage (by \!href{https://github.com/yourGitHubUsername}{yourGitHubUsername})
```
2. Open the `src/languages/languagedelegator.tex` and add this line at the bottom
```
\IfLanguageName{ifLangName}{\input{languages/yourLang}}{}
```
where the `ifLangName` is the name of your language. This is what you have to enter in `babel` to get your language. Most likely it's the language name in the **native** language.

3. Add it in the comments with the other languages in `src/example.tex`.
