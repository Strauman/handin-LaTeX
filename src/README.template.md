# Handin/submission LaTeX template
Light weight template for handing in school submissions using LaTeX. Suitable for math, physics, statistics and the like.
Here is the [handin-doc.pdf](https://raw.githubusercontent.com/Strauman/Handin-LaTeX/master/docs/handin-doc.pdf)

## Table of contents
* Resources:
  * [Latest version (@@VERSIONB) (.zip)](https://raw.githubusercontent.com/Strauman/Handin-LaTeX-template/master/handin.zip)
  * [Package documentation (.pdf)](http://mirrors.ctan.org/macros/latex/contrib/handin/handin-doc.pdf)
  * Layout of front page: [layout.pdf](https://raw.githubusercontent.com/Strauman/Handin-LaTeX-template/master/layout.pdf?raw=true)
  * [How to document this package (.tex)](https://github.com/Strauman/Handin-LaTeX-template/blob/master/documentation-doc.tex)
* [Versions](#versions)  
* [Super quick start](#super-quick-start)
    * [Using TeXLive](#texlive-macos-and-linux-only-if-you-have-texlive-2018)
    * [Using windows (MiKTeX)](#miktex-windows)
* [Quick start](#quickstart)
    * [Quick manual](#quick-docs)
        * [Provided commands](#commands)
        * [Front page](#front-page-maketitle)
* [Internationalisation (Supported langugages)](#internationalisation-supported-langugages)
* [Contributing](#contributing)
    * [Installation](#getting-the-repo)
    * [File structure](#file-structure)
    * [How to document (.tex)](https://github.com/Strauman/Handin-LaTeX-template/blob/master/documentation-doc.tex)
    * [Translations](#translations--languages)

## Versions
The current latest version available on GitHub is @@VERSION (@@DATE) build @@BUILD

The current latest version available on CTAN is v0.0.3 (2018/04/04) build 41

*Note that it can take at least 24-48 hours from the CTAN date above until the package is updated on CTAN, TeXLive and MiKTeX.*

A build has no major changes in the core code (could be changes in documentation, or cosmetic changes in the code). Every time a minor version (that is the middle version number) changes, an upload is made to CTAN. If the patch version change (the last version number) is significant, it will also be uploaded to CTAN. The build number (ideally) never resets.

## Super quick start

### Texlive (MacOS and Linux): Only if you have texlive 2018
1. Install the package from [CTAN](https://ctan.org/pkg/handin). With `texlive`: `tlmgr install handin`
if you dont have texlive 2018, you can pretest it [here](https://www.tug.org/texlive/pretest.html): https://www.tug.org/texlive/pretest.html
2. Add `\usepackage{handin}` to your preamble (that is any place before `\begin{document}`

### MikTeX (Windows):
It's already a part of MikTeX, so just do `\usepackage{handin}`

### And then
use the [docs](http://mirrors.ctan.org/macros/latex/contrib/handin/handin-doc.pdf).

Since this package is in early stages, the CTAN-version is probably not the latest version though. There will be multiple builds pushed here first. Current CTAN-version is `0.0.2 build 30`.

## Quickstart
Install with TeXLive or MikTeX or download the latest version herer: [handin.zip](https://raw.githubusercontent.com/Strauman/Handin-LaTeX-template/master/handin.zip), and in your document use:
`\usepackage{handin}`. There is an example included in the [handin.zip](https://raw.githubusercontent.com/Strauman/Handin-LaTeX-template/master/handin.zip)


## Quick docs:

### Commands
`\problem{1}` would create a *Problem 1* headline and `\pproblem{a}` would then print *1a)* subheadline (with some margin magic and other snacks). More functionality will be made, also feel free to request functionality.

### Front page (`\maketitle`)
[layout.pdf](https://raw.githubusercontent.com/Strauman/Handin-LaTeX-template/master/layout.pdf?raw=true) is an overview of what commands writes out what where. They are all used as commands to be set:
- `\title{Assignment title}`
- `\author{Author(s)}`
- `\coursename{TST-101}`
- `\coursetitle{Test course}`
- `\institute{Institute of Physics and Technology}`
- `\logo{path/to/logo/or/image}`
- `\pagetext{Page \thepage~of \pageref{LastPage}}`
- `\containspages{Contains \pageref{LastPage} pages, front page included}`

`pagetext` and `containspages` are set to the values you see above.

## Internationalisation (Supported langugages)
Currently using `iflang` to decide between German, Norwegian and English.

# Contributing

## Getting the repo
Run `https://github.com/Strauman/Handin-LaTeX-template.git /path/to/where/you/want the files`
Then build the `src/main.tex` file with your favorite latex interpreter.

## File structure
If you have ideas and the like, you should first add them to the issue tracker before you start writing the code. This is that you can be sure we want the code in the package before you write it.

Check out [`documentation-doc.tex`](https://github.com/Strauman/Handin-LaTeX-template/blob/master/documentation-doc.tex) for instructions on how to document the code. All the documentation is automatically generated from the comments in the code using a custom `perl`-script. This file shows examples on how to document the code so that it shows up in the documentation properly.
All of the code are distributed within the `src`-folder. Here is an overview. Filenames in parenthesis are not a part of the actual package, but used for "compiling" it down to `handin.sty` and documenting.
### `src/`:
- (`aftercompile.sh`) is just instructions to perform after the `.sty` and the documentation is created.
- `languages/` see next header (below) for translation instructions
- [`example.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/example.tex) is the file that will be posted as an example of use on CTAN
- [`exercisecmds.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/exercisecmds.tex) contains all commands related to creating problems and part problems
- [`fp.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/fp.tex) is executed when `\maketitle` is run. "fp" is short for "front page"
- (`layout.tex`) is just used for creating the front page layout preview file on CTAN.
- [`main.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/main.tex) this is the main file you should be working in when you are working on the package
- (`packagehead.tex`): All the files are compiled into one `.sty`-file before sent to [CTAN](http://ctan.org). This file contains the top of that `.sty`-file.
- [`preamble.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/preamble.tex) contains the preamble logic. Mostly including other files.
- [`README.template.md`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/README.template.md) is the template for what is used for the GitHub README file. It contains "variables" as @@VERSION and @@BUILD which are replaced by an automatic script.
- (`README.txt`) README file for CTAN.
- [`settable.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/settable.tex) contains a macro for generating user-settables. See top of file for usage.
- (`texpack.tex`) is built when generating the `.sty` file
- (`texpackvars.ini`) contains information about the version and the like for automatic package generation
- [`titlemaker.tex`](https://github.com/Strauman/Handin-LaTeX-template/tree/master/src/titlemaker.tex) redefines `\maketitle` and sets headers and footers

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
