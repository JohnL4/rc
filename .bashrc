#!/bin/bash

# $Header: v:/J80Lusk/CVSROOT/Dotfiles/.bashrc,v 1.62 2003/05/02 00:57:30 J80Lusk Exp $

if [[ $- == *i* ]]; then
    isInteractive=true
else
    isInteractive=false
fi

if $isInteractive; then
echo "----------------  .bashrc  ----------------"
fi

# ----------------------------------------------------------------

case `uname -s` in
    CYGWIN*)
        export SHELL_TYPE=CYGWIN
        ;;
    Darwin)
    	export SHELL_TYPE=Darwin
	;;
    *)
        export SHELL_TYPE=OTHER
        ;;
esac

export FIGNORE='.$tx:.$el:.$ja:.$ba:.$sh:.$pl:~'
unset MAILCHECK

export BC_ENV_ARGS=~/.bcrc
export CYGWIN=nodosfilewarning
export CYGWIN_NOTITLE=1
# export HISTCONTROL=ignoredups
# export HISTIGNORE="?:??:???"	# Don't add short cmd lines to history.
# export JAVA_HOME=`echo $JAVA_HOME | sed -e's|\\\\|/|g'`
export JAVA_HOME=`/usr/libexec/java_home`

if [ $SHELL_TYPE = CYGWIN ]; then
    case "$HOSTNAME" in
#     opstest*)
#         eval `dircolors -b ~/.dircolors.rmt`
#         ;;
        *)
            eval `dircolors -b ~/.dircolors`
            ;;
    esac
fi

# Moved to ~/.minttyrc (or maybe an xterm resource file, if on X-Windows?)
# if [ $TERM = xterm ]; then
#     echo -ne "\\e]4;4;#4083FF\\a" # "blue" -- make it lighter so it's more visible on black background.
# fi

export PATH="${PATH}:/usr/local/bin:/usr/local/sbin:~/Work/Tools/Bin:~/Bin"
export PERLLIB="/usr/local/lib/perl"
export PRINTER='\\rprint1\NETprint37 (PS)'
export TIMEFORMAT="real %lR	user %lU	sys %lS	cpu %P%%"
export TMP="/tmp"

#                                # Clean up PATH, now that unix utils
#                                # are visible for the purpose and
#                                # TIMEFORMAT is set
#
# echo "	(fix PATH)"
# time export PATH=/cygnus/CYGWIN~1/H-I586~1/bin:`echo $PATH |\
#    tr ':' '\012' | awk -v ORS=':' \
#       '/\/cygnus\/CYGWIN~1\/H-I586~1\/bin/ { next; }
#       /^\.$/ { ORS=""; print; exit 0; }	# '.' is assumed to be the
#                                         # last component of PATH
#       { print; }'`

if [ "$TERM" != "emacs" ] ; then
   export PS1="\\[[7m\\]\\h\\$\\[[0m\\] "	# Reverse video hostname.
else
   export PS1="\\h\\$ "
fi

set -o noclobber

shopt -s nocaseglob

# ----------------------------------------------------------------
				# User environment var.

# unset CLASSPATH; export CLASSPATH
                                # Restore "init" behavior with "-+X"
                                #   or "--+no-init" 
export LESS="-Mi -j10 -z-3 -r -q --no-init"
export PAGER=less
# export TZ=EST5EDT

				# 'patch' version control; see man
				# page.

export VERSION_CONTROL=numbered

jdk1_1_8_classpath=".;e:/Java/xml4j/xml4j_1_1_16.jar;e:/java/JSDK2.0/lib/jsdk.jar;e:/Java/JUnit2.1;e:/Java/jdk1.1.8/classes;e:/Java/jdk1.1.8/lib/classes.zip"

# ----------------------------------------------------------------
				# Functions

alert()		{ msg $USERNAME "$@"; }

                                # ActiveState perl
apd()		{ labelwin "$@";
		  env PATH="/perl/bin:$PATH" \
                     /perl/bin/perldoc.bat -n "bash nroff" "$@";
                  updtb;
                }
asp()	 	{ env PATH="/perl/bin:$PATH" perl "$@"; }

beep()		{
                  local count=1;
                  if [ $# -ge 1 ]; then
                     count=$1
                  fi
                  local i=0
                  while expr $i \< $count >/dev/null; do
                     echo -n '';
                     i=`expr $i + 1`
                  done
                }
bhg()		{
                  if [ $# -lt 2 ] ; then
                     echo "Usage: bhg <count> <regexp>"
                     return 1
                  fi
		  count=$1
                  shift
		  egrep "$@" ~/.bash_history | tail -$count
                }
bigpush()	{ cmd /c bigPush; }
bsh()		{ java -cp c:/usr/local/lib/bsh-2.0b4.jar bsh.Interpreter; }
CB()		{ export CANOPY_BRANCH="$@"; }
cd()		{ command cd "$@"; pwd; updtb; }

                                # cleanup:  see also 'scrub' and
                                # 'scour', if they exist

cleanup() 	{ find . \( -name '*~' -o -name '.*~' -o -name '*.tmp' -o -name 'junk' -o -name '*.temp' -o -name '#*#' \) -print -exec rm -f {} \; ; }
cvsstat()	{ cvs status 2>&1 |\
                     grep Status: |\
                     grep -v Up-to-date
                  cvs -n update 2>&1 |\
                     egrep -v '^[MA] |^cvs update: Updating'
                }
datefn()	{ date +%Y-%m-%d_%H%M; }
datefns()	{ date +%Y-%m-%d_%H%M%S; }
dateiso()	{ date +%Y-%m-%dT%H:%M:%S%z | \
                  sed -e's/\([0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/';
                }
dir()		{ ls -aFC "$@"; }
dirla()		{ ls -altuF "$@"; }
dirlm()		{ ls -altF "$@"; }
dirn()		{ ls -aFl "$@"; }
dirr()		{ ls -aFRC "$@"; }
diskdu()	{ du -a "$@" | sort -nr; }
ec()		{ /emacs/emacs-24.2/bin/emacsclientw --no-wait -c "$@"; }
eggtimer()	{ local interval=$1 # In minutes
		  shift
		  local msg
                  if [ $# -ge 1 ]; then
                     msg="$@"
                  else
                     msg="DING!"
                  fi
		  sleep `expr $interval \* 60`
                  alert "eggtimer: $msg"
                }
fgallsrc()	{
		  proj;
		  find ./{ui,canopy} \
                     \( \( -name help -o -name Images \) -prune \) -o \
                     \( -name '*.[Jj][Ss][Pp]' -o -name '*.[Jj][Aa][Vv][Aa]' \
			-o -name '*.[Jj][Ss]' -o -name '*.[Hh][Tt][Mm]' \
			-o -name '*.[Hh][Tt][Mm][Ll]' \) -print0 \
                     | xargs --null egrep "$@"
                }
fgel()		{ find . -name '*.el' -exec egrep "$@" {} \; -print; }
fgj()		{ find . -name '*.java' -exec egrep "$@" {} \; -print; }
fgPtGlobals()	{               # Find usage of ED "Patient Globals"
                                # (see
                                # Module1.InitializePatientGlobal())
		  local regex="pintEncounterNo|plngMpiId|pintPTAge|pstrPtSex|pstrCurStatus|pstrPtInfoSecurity|pstrCurNrs|pstrCurPhy|pblnIsEMS|pstrPatientName|pstrBed|pblnAgreedAmend|pstrChiefCmpl|pSignOff|pstrPtStatus"
                  local -a filev
                  local opts=
                  local a
                  local -i i=0
                  # set -x
                  for a in "$@"; do
                      case $a in
                          --)
                              break
                              ;;
                          -*)
                              opts="$opts $a"
                              ;;
                          *)
                              filev[$i]=$a
                              shift
                              i+=1
                              ;;
                      esac
                  done
                  if [ "$opts" ]; then
                      set -- $opts
                  fi
                  if [ $i -gt 0 ]; then
                      find "${filev[@]}" -print0 | xargs --null egrep -w "$@" "$regex"
                  else
                      fgsrc -wil "$@" "$regex"
                  fi
                  # set +x
                }
fgnotes()	{
    		  find . \
                      \( \
                            -iname '*.org' \
                        -o  -iname '*.txt' \
                        -o  -iname '*.htm' \
                        -o  -iname '*.html' \
                      \) -print0 \
                      | xargs --null -P 0 egrep "$@"
                }
fgorg()		{
                  cat ~/org/org-agendas.txt \
                      | while read f; do
                           egrep "$@" "$f" /dev/null  # Extra filename to force multi-file behavior.
                        done
                  find . \
                      \( \
                            -iname '*.txt' \
                         -o -iname '*.org' \
                      \) -print0 \
                      | xargs --null -P 0 egrep "$@"
    		}
fgsrc()		{
                                # "Log" is the WebLoad log directory
                                # that tends to live next to the source.
		  find . \
                     \( \( -name help -o -name Images -o -name Log \) \
                        -prune \) -o \
                     \( \
                           -iname '*.vb' \
                        -o -iname '*.config' \
                        -o -iname '*.vb[pw]' \
                        -o -iname '*.vbproj' \
                        -o -iname '*.vbproj.user' \
                        -o -iname '*.asp' \
                        -o -iname '*.aspx' \
                        -o -iname '*.cls' \
                        -o -iname '*.jsp' \
                        -o -iname '*.jspf' \
                        -o -iname '*.java' \
			-o -iname '*.js' \
                        -o -iname '*.htm' \
			-o -iname '*.html' \
                        -o -iname '*.awk' \
                        -o -iname '*.bat' \
                        -o -iname '*.css' \
                        -o -iname '*.p[lm]' \
                        -o -iname '*.sh' \
                        -o -iname '*.xs[lp]' \
                        -o -iname '*.xml' \
                        -o -iname '*.sql' \
                        -o -iname '*.sql8' \
                     \) -print0 \
                     | xargs --null -P 0 egrep "$@"
		}
gcw()		{ gnuclientw "$@"; }
h()		{ history "$@"; }
hg()		{ history | egrep "$@"; }
ii()		{
    		  # See also the 'open' function.
    		  powershell -NonInteractive ii \""$@"\" < /dev/null
		}
j()		{ java -Djava.compiler=NONE "$@"; }
jc()		{ javac -g -Xdepend "$@" 2>&1 | lesserr; }
jd()		{ local cwd=`pwd`;
                  proj;
                  echo jdall -s javadoc.css \
                     -w \"Javadoc for Canopy, `date +'%e-%b-%Y %H:%M'`\" \
                     ../Javadoc canopy
                  jdall -s javadoc.css \
                     -w "Javadoc for Canopy, `date +'%e-%b-%Y %H:%M'`" \
                     ../Javadoc canopy \
                     2>&1 | tee /tmp/jd.log;
                  cd $cwd
                }
jdi()		{ local cwd=`pwd`;
                  (
                  proj;
                  echo jdall -i -s javadoc.css \
                     -w \"Javadoc for Canopy, `date +'%e-%b-%Y %H:%M'`\" \
                     ../Javadoc "$@"
                  jdall -i -s javadoc.css \
                     -w "Javadoc for Canopy, `date +'%e-%b-%Y %H:%M'`" \
                     ../Javadoc "$@" \
                     2>&1 | tee /tmp/jd.log;
                  )
                }

jtags()		{
		  # etags --members `find "$@" -name '*.java'`;
		  rm -f TAGS
                  find "$@" -name '*.java' |\
                     /Emacs/emacs-23.3/bin/etags --append --members -
                }
labelwin()	{
                        # -o \( $TERM = xterm-256color \) 
        	  if [ \( $TERM = xterm \) ]; then
                      echo -ne "\\e]0;$@\\a" # \e]0 -- window and icon; \e]1 -- icon; \e]2 -- window
                  elif [ \( "$TERM_PROGRAM" = "Apple_Terminal" \) -o \( "$TERM_PROGRAM" = "iTerm.app" \)  ]; then
                      echo -ne "\\033]0;$@\\007"
                  else
        	      cmd /c title "$@";
    		  fi
                }
lesserr()	{ less +/':[0-9]*:'; }
lesst()		{ labelwin "$@"; less "$@"; updtb; }
lgsrc()		{
                                # "Log" is the WebLoad log directory
                                # that tends to live next to the source.
                  declare -a pathv # array
                  declare -i i=0   # integer
                  local pwd=`pwd | sed -e's/ /\\\\ /'g`
                  for suff in "vb" "vbproj" "vbproj"."user" "config" "jsp" "jspf" \
                      "java" "js" "htm" "html" "awk" "bat" "css" "p[lm]" \
                      "sh" "xs[lp]" "xml" "sql" "sql8"; do
                      pathv[$i]=".*${pwd}/.*\\.${suff}\$"
                      i+=1
                  done
                  # echo "Will grep '${paths}'"
                  locate -i --null --regex "${pathv[@]}" \
                      | egrep --null-data --null -vi '/(Images|Log|help|\.svn)/' \
                      | xargs --null -P 0 egrep "$@" 2>&1 \
                      | grep -v ": No such file or directory$"
		}
logmon()	{ v:/j80lusk/canopy/tuning/log-monitor.pl "$@"; }
lscf()		{ 
		  if [ "$SHELL_TYPE" == "Darwin" ]; then
		    ls -GCF "$@";
		  else
		    ls --color -CF "$@"; 
		  fi
		}
mann()		{ labelwin man "$@"; man "$@"; updtb; }
np()		{ notepad /P "$@"; }
npp()		{ /Program\ Files/Notepad++/notepad++.exe "$@"; }
# open()		{
#     		  # See also 'ii' function.
#     		  for f in "$@"; do
#                      chmod +x "$f"
#                      g=`cygpath -aw "$f"`
#                      cmd /c "$g" &
#                   done
#                 }
pd()		{ perldoc "$@"; }
plot-ProcMem()	{ plotPerfData.pl -f $1 -x 'Sample.*Time' \
                  -l --ls 2 -y 'Available Bytes' \
                  -r --ls 1 -y 'Tot.*Proc.*Time' \
                     --ls 3 -y 'Pages/sec'
		}
pr2up()		{ (a2ps -2 -r -o - "$@" >| $TMP/a2ps_$$.ps) \
                     && /Ghostgum/Ghostview-4.2/gsview/gsview32 /P $TMP/a2ps_$$.ps;
                  rm -f $TMP/a2ps_$$.ps; }
proj()		{ local dest=$1;
                  cd /e/Work/Canopy/${CANOPY_BRANCH}/CanopyIA/Source/$dest; }
# prup()		{
#                   local psFile="$TMP/prup_$$.ps"
#                   local psFile_W32=`cygpath -w $psFile`
#                   echo "writing to $psFile"
#                   (a2ps -o - "$@" >| $psFile) \
#                      && /Program\ Files/Ghostgum/gsview/gsprint $psFile_W32 \
#                      || return 1;
#                   rm -f $psFile
#                 }
prup()		{
                  local psFile="$TMP/prup_$$.ps"
                  local psFile_W32=`cygpath -w $psFile`
                  echo "writing to $psFile"
				# -s 2: duplex
                  (a2ps -s 2 -o - "$@" >| $psFile) \
                      && lpr $psFile \
                      || return 1;
                  rm -f $psFile
                }
pod()		{ popd "$@"; updtb; }
pud()		{ pushd "$@"; updtb; }
scrub()		{ cleanup;
                  find . \( -iregex '.*\.v[0-9]+.*' \
                     -o -iregex '.*[-._]\(old\|merged\|new\|edited\|patch\(ed\)?\)\b.*' \) |\
                  xargs rm -fv
                }
sdiff160()	{
		  echo "Use 'prup -1r -l 160' to print." >&2;
		  sdiff -bltd -w 160 "$@" | sed -e's/($//';
                }

updtb()		{
                        # -o \( $TERM = xterm-256color \) 
    		  if [ \( $TERM = xterm \) ]; then
                      echo -ne "\\e]0;"`pwd`"\\a"
    		  elif [ $SHELL_TYPE = CYGWIN ]; then
    		      cmd /c title `pwd` >/dev/null 2>&1;
                  elif [ \( "$TERM_PROGRAM" = "Apple_Terminal" \) -o \( "$TERM_PROGRAM" = "iTerm.app" \) ]; then
                      echo -ne "\\033]0;${PWD##*}\\007"
                  fi
                }

what()		{ strings "$@" | fgrep "@(#)";
		  strings "$@" | egrep '\$(Header|Id|Revision).*\$'; }
xfer()		{
				# Help

		  if [ $# -eq 0 ]; then
		     cat <<'EOF'
Usage:  xfer [-d] [-f] <dest> <find_predicate>

   Copy files w/directory structure to directory <dest>, creating it,
   if necessary.

Options:

   -d		Delete files after copying.
   -f		Force; no confirmation
   
EOF
		     return 0
		  fi

				# Parse args

		  local del=false
		  local force=false
		  OPTIND=1	# Not reset between invocations
				#   (remember, this is one big shell
				#   instance, and xfer() is just a
				#   function).
		  
		  while getopts "df" opt; do
		     case $opt in
			d)
			   del=true
			   ;;
			f)
			   force=true
			   ;;
			*)
			   echo "Unrecognized option: '$opt'"
			   ;;
		     esac
		  done
		  shift `expr $OPTIND - 1`
		  local dir=$1;
		  shift;

				# Confirmation

		  if $force; then
		     :
		  else
		     find "$@"
		     read -p "Proceed? (Y/n) " ans
		     ans=`echo $ans | cut -c1`
		     case $ans in
			N|n)
			   return 0
			   ;;
			*)
			   echo "(Proceeding.)"
			   ;;
		     esac
		  fi

				# Do it!

		  mkdir -p $dir;
		  tar -cf - `find $@` | (cd $dir; tar xvf -);
		  if $del; then
		     echo "(Deleting.)"
		     find "$@" -exec rm -fr {} \;
		  else
		     echo "(Not deleting.)"
		  fi
		  updtb;
		}

xm()		{ alert "$@"; }

# ----------------------------------------------------------------
				# Final setup.

updtb

if $isInteractive; then
echo "--------------  .bashrc ends  -------------"
fi

# Local Variables:
# sh-indentation: 3
# End:
:


# End:

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
