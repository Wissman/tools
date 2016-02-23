#!/bin/sh
### inicio
#
# THIS SCRIPT WAS MADE TO LAUNCH THE UPDATE MODULE
# ON TOOLKIT STARTUP (depending of toolkit_config file settings)
# Develop By: pedr0 Ubuntu [r00t-3xp10it]
# peterubuntu10[at]sourceforge[dot]net
# KALI-DISTRO
#
###



# ----------------------------------------
# variable declarations
# ----------------------------------------
uppath=`echo ~`
tWd=`cat ~/opensource/toolkit_config | egrep -m 1 "TEMP_FOLDER" | cut -d ':' -f2`
loca=`locate -b -n 1 "opensource" | cut -d '.' -f1`
distr=`cat ~/opensource/netool.sh | egrep -m 1 "D1str0" | cut -d ':' -f2`



# ----------------------------------------
# Colorise shell Script output leters
# ----------------------------------------
Colors() {
Escape="\033";
white="${Escape}[0m";
RedF="${Escape}[31m";
GreenF="${Escape}[32m";
YellowF="${Escape}[33m";
BlueF="${Escape}[34m";
CyanF="${Escape}[36m";
Reset="${Escape}[0m";
}




# ----------------------------------
# update netool.sh toolkit using GIT and CAT
# ----------------------------------
Colors;

   mkdir $tWd > /dev/null 2>&1
   cd $tWd
   # download update.txt from GIT
   wget -qq https://dl.dropboxusercontent.com/u/21426454/netool-kali/update.txt
   wget -qq https://dl.dropboxusercontent.com/u/21426454/netool-kali/update2.txt

      # var to compare git version vs local version
      GIT=`cat $tWd/update.txt` > /dev/null 2>&1
      LOCAL=`cat ~/opensource/modules/update.txt` > /dev/null 2>&1
      INF=`cat $tWd/update2.txt | egrep -m 1 "1nf0" | cut -d ':' -f2` > /dev/null 2>&1
      S1ze=`cat $tWd/update2.txt | egrep -m 1 "S1z3" | cut -d ':' -f2` > /dev/null 2>&1

         # check the 2 files for version display using CAT command
         if [ "$GIT" ">" "$LOCAL" ];then
         echo ${BlueF}[*]${RedF}::${BlueF}[Updating]:${GreenF}Updates Available...${Reset};
         sleep 2


# display update info to the user
echo "+----------------------------------------------------+"
cat << !
|                 Update Description                 |
!
echo "+----------------------------------------------------+"
cat << !
|                                                    |
|      version available    : netool $GIT            |
|      update info          : $INF          |
|      update path          : $uppath
|      temp download dir    : $tWd
|      download size        : $S1ze                 |
|                                                    |
|      version installed    : netool $LOCAL            |
|      toolkit distro       : $distr
|      current install path : $loca
|                                                    |
!
echo "+----------------------------------------------------+"
echo ${BlueF}[*]${RedF}::${white}Press [${GreenF}ENTER${white}] to update... ${Reset};
echo ${BlueF}[*]${RedF}::${white}Or [${GreenF}CLOSE${white}] current terminal... ${Reset};
read op




   Colors;
   # update function (downloading from GIT repository)
   echo ${BlueF}[*]${RedF}::${BlueF}[Updating]:${white}Toolkit Version From: ${BlueF}[${GreenF} $LOCAL ${BlueF}]${white} To ${BlueF}[${GreenF} $GIT ${BlueF}] ${Reset};
   sleep 3
   echo ${BlueF}[*]${RedF}::${BlueF}[Updating]:${white}Downloading from GIT repository! ${Reset};
   xterm -T "Downloading $GIT version" -e "git clone git://git.code.sf.net/p/netoolsh/opensource-kali opensource"
   echo ${BlueF}[*]${RedF}::${BlueF}[Updating]:${white}Opensource 'install' path:$loca ${Reset};
   echo ${BlueF}[*]${RedF}::${BlueF}[Updating]:${white}Removing old config files! ${Reset};

     # removing old config files
     cp -u -r -f $tWd/opensource $uppath
     rm -f -r $tWd
     echo ${BlueF}[*]${RedF}::${BlueF}[Updating]:${white}Remmenber to Restart the Toolkit 'for' the chages take effect! ${Reset};
   sleep 5
   exit



else


   # display update info to the user
   echo ${BlueF}[*]${RedF}::${BlueF}[Updating]:${RedF}No Updates Available... ${Reset};
   sleep 2
echo "+----------------------------------------------------+"
cat << !
|   sorry for any inconvenience but there aren't    |
|    any new updates available at the moment...     |
|                                                   |
|        GIT REPOSITORY    : netool $GIT            |
|        version installed : netool $LOCAL            |
!
echo "+----------------------------------------------------+"
   echo ${BlueF}[*]${RedF}::${white}Press [${GreenF}Enter${white}] to return to main menu ${Reset};
   read op
      # remove old config files
      rm -f -r $tWd
   clear
fi
exit
