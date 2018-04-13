# Handin/submission LaTeX template
Light weight template for handing in school submissions using LaTeX. Suitable for math, physics, statistics and the like.
Here is the [handin-doc.pdf](https://raw.githubusercontent.com/Strauman/Handin-LaTeX/master/release/handin-doc.pdf)

## Table of contents
* Resources:
  * [Latest version (v0.1.0-prerelease)(.zip)](https://raw.githubusercontent.com/Strauman/Handin-LaTeX-template/master/handin.zip)
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
* [Contributing](https://github.com/Strauman/Handin-LaTeX-template/blob/master/.github/CONTRIBUTING.md)
    * [Installation](https://github.com/Strauman/Handin-LaTeX-template/blob/master/.github/CONTRIBUTING.md#getting-the-repo)
    * [File structure](https://github.com/Strauman/Handin-LaTeX-template/blob/master/.github/CONTRIBUTING.md#file-structure)
    * [How to document (.tex)](https://github.com/Strauman/Handin-LaTeX-template/blob/master/documentation-doc.tex)
    * [Translations](https://github.com/Strauman/Handin-LaTeX-template/blob/master/.github/CONTRIBUTING.md#translations--languages)

## Versions
The current latest version available on GitHub is v0.1.0-prerelease (2018/04/13) build 47

The current latest version uploaded to [CTAN](https://ctan.org/pkg/handin) is v0.1.0 (2018/04/10) build 47

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

Since this package is in early stages, the CTAN-version is probably not the latest version though. There will be multiple builds pushed here first.

## Quickstart
Install with TeXLive or MikTeX, as per usual. Alternatively download the latest version here: [handin.zip](https://raw.githubusercontent.com/Strauman/Handin-LaTeX-template/master/handin.zip), then, in your document, use: `\usepackage{handin}`. There is an example included in the [handin.zip](https://raw.githubusercontent.com/Strauman/Handin-LaTeX-template/master/handin.zip)

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

# Contribution guidelines are [here](https://github.com/Strauman/Handin-LaTeX-template/blob/master/.github/CONTRIBUTING.md)
