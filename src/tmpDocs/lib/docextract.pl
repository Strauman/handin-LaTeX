#!/usr/bin/perl
# Examples:
#%:§VariableForASection=My section name
#%:=\macroname[oarg]{marg}{marg}
#%:Description goes
#%:here and then you do
#%:-
#%:§VariableForASection
#%:=\begin{env}[oarg1]{marg}
#%: This environment also does something
#%: that is amazing!
# For more examples see docs/documentingExample.tex

use strict;
use warnings;
use Getopt::Long;
use Cwd;
use File::Spec;
# Config
my $templatedir = "templates";
my $output = "docextract.tex";
my $input = "";

my $skeletonTemplateFile = "docskeleton.tex";

my $mainSection="Reference";

# $echo is introduced to keep the -w argument
# for backward compability.
# The $toFile is the one that ultilmately
# decides whether to write to file.
my $toFile = -1;
my $echo = 1;

my $contentsline = "\\!addcontentsline{toc}{subsubsection}{§CONTENT}\n";
my $macroContentLine = $contentsline =~ s/§CONTENT/\\!refCom{§VAR}/r;
my $macroContentInLine = "\\!addcontentsline{mac}{macro}{\\!refCom{§VAR}}{}\n";
my $envContentLine="\\!addcontentsline{toc}{subsubsection}{\\!refEnv{§VAR}}\n";
my $sectionHeader = "\\clearpage\\subsection{§section}\n";

# Default section if nothing set
my $currentSection="References";
my @sectionOrder = ();
my @sectionNoTOC = ();
my @sectionTOCOnly = ();
my %sectionVars;
my $noSkeleton=0;
my $verbose=0;

GetOptions (
  'template-directory|T=s' => \$templatedir,
  'input|i=s' => \$input,
  'output|o=s' => \$output,
  'main-section=s'=> \$mainSection,
  'template-dir|T=s' => \$templatedir,
  'skeleton=s' => \$skeletonTemplateFile,
  'noskel' => \$noSkeleton,
  'echo|e' => \$echo,
  'write|w' => \$toFile,
  'section-header=s' => \$sectionHeader,
  'verbose|v' => \$verbose
);

if($toFile==-1){
  $toFile=($echo==1) ? 0 : 1;
}
# Unecessary, but to be thorough
# in case somewhone suddenly use it
$echo = ($toFile==1) ? 0 : 1;

$skeletonTemplateFile = "$templatedir/$skeletonTemplateFile";
# File loading
sub talk
{
  my ($words) = @_;
  if($verbose){
      print STDERR "$words\n";
  }
}
# Main in/out
if ($toFile==1){
  open (my $OUTPUT, '>', "$output") or die "Can't write to file $output: '$!'";
  STDOUT->fdopen(\*$OUTPUT, 'w') or die $!;
}

open(my $FILE, "<", $input) or die "could not open input file '$input'\n";

# Template files
sub loadTemplate
{
  my ($templateFile)=@_;
  local $/ = undef;
  open FILE, $templateFile or die "Couldn't open template $templateFile: $!";
  binmode FILE;
  my $outTemplate = <FILE>;
  close FILE;
  return $outTemplate
}
my $skeleton=loadTemplate("$skeletonTemplateFile");

my $triggers="";
my $docOutString="";
# my $skeleton=loadTemplate($skeletonTemplateFile);
## Pattern prefixes
my $pPrefix = qr/^\s*[%]+\s*:/;
my $sectionVarPrefix=qr/${pPrefix}§/;
my $examplePrefix=qr/${pPrefix}!/;
my $defPrefix=qr/${pPrefix}=/;
my $variablePrefix=qr/${pPrefix}\$/;
my $solidVariablePrefix=qr/${pPrefix}\$\$/;
my $descPrefix=qr/${pPrefix}[^!=§\$]/;

## Patterns
my $flushoutPattern=qr/${pPrefix}-/;
my $pOarg=qr/(?:\[(?<oarg>.*?)\])?/;
my $pMargs=qr/(?=(?<margs>(?:{[^}]*})*))?/;
my $pStyleArgs=qr/(?:\[(?<styleArgs>.*?)\])?/;
my $descCapture=qr/${pPrefix}([^!=§\$].*)/;
my $pSkipTOC=qr/${pPrefix}?TOC/;
my $pInlineTOC=qr/${pPrefix}\!TOC/;

# Macros
my $pMacro=qr/\\(?!EDOC|begin)(?<macroname>[a-zA-Z@]+(?:\*)?)/;
my $macroDefPattern=qr/^${defPrefix}${pMacro}${pOarg}${pMargs}${pStyleArgs}/;

# Environment
my $pEnv=qr/\\\\begin\{(?<envname>[^\}]+)\}/;
my $envDefPattern=qr/^${defPrefix}${$pEnv}${pOarg}${pMargs}${pStyleArgs}/;
# Replacing macros with \dac
my $dacSearch=qr/\\((?!(?:dac|oarg|marg|meta|refCom|brackets|refEnv|\\|keyDef|refKey))[a-zA-Z@]+)/;
my $bracketSearch=qr/\\(?!(?:dac|oarg|marg|meta|refCom|brackets|refEnv|keyDef|refKey))[a-zA-Z@]+\K\{([^\}]+)\}/;
# Store all defined macros
my @macroDefinitions;
my @envDefinitions;
## Templates
my %macroDef = (
  head => "\\begin{docCommand}{§mname}{§oargs§margs}",
  tail => "\\end{docCommand}",
  pattern => $macroDefPattern,
  );
my %envDef = (
  head => "\\begin{docEnvironment}{§envname}{§oargs§margs}",
  tail => "\\end{docEnvironment}",
  pattern => $envDefPattern,
);
my %exampleBlock = (
  head => "\\begin{dispListing}",
  tail => "\\end{dispListing}"
);
# Globals/flags
my $line;
my @endStack;
my %states = (
  DEF => 0,
  EXAMPLE => 0,
);
my $skipNextTOC=0;
my $inlineNextTOC=1;
my %sections = ();
my %variables= ();
# subs:

sub sectionHandler
{
  if (@endStack){
    die "Cannot change section when inside other block: @endStack";
  }
  # Variable definition §§asdf=asdf
  if(/^${sectionVarPrefix}(?<varname>[^\s=]+)+(?:=(?<assigned>.*))?/){
    if(!$+{assigned}){
      if(exists $sectionVars{$+{varname}}){
        $currentSection=$sectionVars{$+{varname}};
        return 1;
      }
      else{
        $currentSection="§$1";
        return 1;
      }
    }
    else{
      talk("Setting sess $+{varname}=$+{assigned}\n");
      push @sectionOrder, "§$+{varname}";
      $sectionVars{$+{varname}}=$+{assigned};
      $currentSection=$+{assigned};
      return 1;
    }
  }
  else{
    return 0;
  }
}
sub escapeMacros
{
  s/$bracketSearch/\\\{$1\\\}/g;
  s/$dacSearch/\\dac{$1}/g;
  # (Double backslash will be just transfered as macro)
  s/\\!([a-zA-Z@]+)/\\$1/g;
}
## Print to section
sub prsec
{
  my ($content) = @_;
  if(!exists $sections{$currentSection}){
    $sections{$currentSection}="";
  }
  if ($content){
      $sections{$currentSection}.="$content\n";
  }
}
sub flushout
{
  if (/\s*[%]+\s*:-/){
    if ($endStack[0]){
      $states{DEF}=0;
      prsec (join("\n",reverse @endStack));
      @endStack=();
    }
  }
}
sub example
{
  if (/^${examplePrefix}(.*)/){
    unless($states{EXAMPLE}){
      prsec $exampleBlock{head};
      $states{EXAMPLE}=1;
      push @endStack, $exampleBlock{tail};
    }
      prsec $1;
  }
}
sub endState
{
  my ($toEnd) = @_;
  if($states{$toEnd}){
    $states{$toEnd}=0;
    prsec (pop @endStack);
  }
}
sub definitions
{
  if(/$macroDef{pattern}/){
    if($states{DEF}){
      prsec (pop @endStack);
    }
    my $margs = $+{margs};
    my $oargs = $+{oarg};
    my $macroname = $+{macroname};
    my $styleArgs = $+{styleArgs};
    $margs =~ s/(\{[^\}]*\})/\\marg$1/g;
    if($oargs){
      $oargs = "\\oarg{$oargs}";
    }
    else{
      $oargs="";
    }
    $output =  $macroDef{head} =~ s/§margs/$margs/r;
    $output =~ s/§oargs/$oargs/;
    $output =~ s/§mname/$macroname/;
    if($skipNextTOC==0){
      if ($inlineNextTOC){
          my $TOCLine = $macroContentLine =~ s/§VAR/$macroname/r;
          $TOCLine =~ s/\\!/\\/g;
          $output .= $TOCLine
      }
      push @macroDefinitions, $macroname;
      $inlineNextTOC=1;
    }else{
      talk "Skipping TOC entry for $macroname\n";
      $skipNextTOC=0;
    }
    prsec $output;
    push @endStack, $macroDef{tail};
    $states{DEF}=1;
  }
  elsif(/$envDef{pattern}/){
      if($states{DEF}){
        prsec (pop @endStack);
      }
      my $margs = $+{margs};
      my $oargs = $+{oarg};
      my $envname = $+{envname};
      my $styleArgs = $+{styleArgs};
      $margs =~ s/(\{[^\}]*\})/\\marg$1/g;
      if($oargs){
        $oargs = "\\oarg{$oargs}";
      }
      else{
        $oargs="";
      }
      $output =  $envDef{head} =~ s/§margs/$margs/r;
      $output =~ s/§oargs/$oargs/;
      $output =~ s/§envname/$envname/;
      prsec $output;
      push @endStack, $envDef{tail};
      if($skipNextTOC==0){
          push @envDefinitions, $envname;
      }else{
        talk "Skipping TOC entry for $envname\n";
        $skipNextTOC=0;
      }
      $states{DEF}=1;
  }else{
    die "Expected definition, but got $_ instead...";
  }
}
sub descriptions
{
  if(/^$descCapture/){
    prsec ($1);
  }
}
sub variableHandler
{
  $_=$line;
  if (/^${variablePrefix}(?<varname>[a-zA-Z]+)(?:(?<append>\.)?=(?<assignValue>.*))?/){
    if($+{assignValue}){
      # We are assigning a variable
      if (!$variables{$+{varname}}){
        # The variable does not exist exists
        $variables{$+{varname}}="$+{assignValue}\n";
        talk "Setting $+{varname}=$+{assignValue}\n";
      }
      else{
        # Assigning to variable that already exists
        if($+{append}){
          # Appending to variable that already exists
          $variables{$+{varname}}.="$+{assignValue}\n";
        }else{
          # Reassigning variable that already exists
          $variables{$+{varname}}="$+{assignValue}\n";
        }
      }
      # Delete line
      s/.*//;
    }
    else{
      # We are not assigning a variable
      if (!$variables{$+{varname}}){
        # Using a variable that does not exist.
        talk "FATAL: Trying to access $+{varname} that is not defined\n";
      }else{
        # Using a variable that does exist.
        my $varname=$+{varname};
        my $replacement=$variables{$varname};
        talk "Switching $varname with $replacement\n";
        s/.*/%:$replacement/;
      }
    }
  }else{
    # Found a solid variable
    prsec $_;
  }
}

while ($line=<$FILE>){
  $_=$line;
  # If not starting with %, then skip
  unless(/^${pPrefix}/){
    next;
  }
  # Do variables first
  if (/^${variablePrefix}/){
    variableHandler();
  }
  if(/$pInlineTOC/){
    # Should not write next TOC inline
    $inlineNextTOC=0;
    next;
  }
  elsif(/$pSkipTOC/){
    $skipNextTOC=1;
    next;
  }
  # Check for definitions
  elsif (/^${defPrefix}/){
    endState('EXAMPLE');
    definitions();
  }
  elsif (/^${flushoutPattern}/){
    flushout();
  }
  elsif (/^${sectionVarPrefix}/){
    endState('EXAMPLE');
    sectionHandler();
  }
  elsif (/^${examplePrefix}/){
    example();
  }
  # Check for descriptions
  elsif(/^${descPrefix}/){
    endState('EXAMPLE');
    escapeMacros();
    descriptions();
  }
  # elsif(/^[ \s\t]*[%]+\s*\\Trigger\\([a-zA-Z]+):(.*)/){
    # $triggers.="\\dac{At}\\dac{$1}\\\\ $2\\\\\n";
  # }
}
my $macroTOC=" ";
my $envTOC=" ";
## Setup order for sections and create section headers
foreach (@sectionOrder)
{
      my $sec=$_;
      my $secvarName="";
      my $secVar="";
      if(/^§(.*)/){
        $secvarName="$1";
        $secVar="§$secvarName";
        if (exists $sectionVars{$secvarName}){
            $sec=$sectionVars{$secvarName};
        }else{
          talk "Section order uses undefined variable $secVar\n";
        }
      }
      talk "Generating section $sec\n";
      if(exists $sections{$sec}){
        $docOutString.= $sectionHeader=~ s/§section/$sec/r;
        $docOutString.=$sections{$sec};
        delete $sections{$sec};
      }
}

while(my($sec, $cont) = each %sections) {
  talk "Generating section $sec\n";
  $docOutString.= $sectionHeader=~ s/§section/$sec/r;
  $docOutString.=$cont;
}

## Macro and environment definitions for TOC
foreach (sort @macroDefinitions)
{
  my $mname=$_;
  $macroTOC.= $macroContentInLine=~s/§VAR/$mname/r;
}
foreach (sort @envDefinitions)
{
  $envTOC.= $envContentLine =~ s/§VAR/$_/r;
}

$variables{macrodefs}="\n$macroTOC\n \\!macrotable";
$variables{envdefs}=$envTOC;

unless($noSkeleton){
    $docOutString = $skeleton =~ s/§content/$docOutString/r;
}
my @docOutLines=split("\n",$docOutString);
$docOutString="";
foreach (@docOutLines){
  if(/$solidVariablePrefix(.*)/){
    my $varname=$1;
    if($variables{$varname}){
      s/.*/$variables{$varname}/;
      s/$bracketSearch/\\\{$1\\\}/g;
      s/$dacSearch/\\dac{$1}/g;
      s/\\!([a-zA-Z@]+)/\\$1/g;
      talk "Replaced solid variable $varname with $_";
    }
    else{
      die "FATAL: Trying to output undefined solid variable $1";
    }
  }
  $docOutString.="$_\n";
}


# $docOutString =~ s/^\s*[%]+\s*:\$\$(.*)/$variables{$1}/mg;
# while ($line=<$docOutString>){
#   s/.*//;
# }
talk "\nDOCS: Writing output\n";
print $docOutString;
