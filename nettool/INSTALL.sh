#!/bin/sh
#########################################################################
#            .::[ NETOOL TOOLKIT V4.5 -> Installer ]::.                 #
#                By r00t-3xp10it and rawstring enox                     #
#-----------------------------------------------------------------------#
#                                                                       #
#                            * WARNING *                                #
#   this 'installer' as build to work on linux Ubuntu or Kali distros   #
#   if you wish to install the toolkit in another (linux) distro,       #
#   download 'opensouce[kali].tar.gz' and follow the instructions       #
#   on my 'WIKI' webpage hosted on sourceforge here:                    #
#  http://sourceforge.net/p/netoolsh/wiki/netool.sh%20script%20project/ #
#-----------------------------------------------------------------------#
#   Special Thanks to rawstring_enox for the support provided in the    #
#   develop of this 'installer' and for the debug that cames later :/   #
#########################################################################






# ----------------------------------------
# Variable declarations
####################################################################################
ver=V4.5                               # netool.sh version                         #
IdU=`id -u`                            # check user ID (0=root 1000=gest)          #
H0m3=`echo ~`                          # local user Home path                      #           
OS=`awk '{print $1}' /etc/issue`       # grab Operative System distro              #
spath=`pwd`                            # toolkit current installed directory       #
rpath="$H0m3/opensource"               # toolkit correct directory (default)       #
CuRl=`which curl`                      # curl install path                         #
Z3n=`which zenity`                     # zenity install path                       #
usera=`who | cut -d' ' -f1 | sort | uniq` # grab account username                  #
# ---------------------------------------------------------------------------------#
D1sTr0=`cat netool.sh | egrep -m 1 "D1str0" | cut -d ':' -f2`                      #
PhP=`cat toolkit_config | egrep -m 1 "PHP5_INSTALL_PATH" | cut -d ':' -f2`         #
find=`cat toolkit_config | egrep -m 1 "ZENMAP_INSTALL_PATH" | cut -d ':' -f2`      #
find2=`cat toolkit_config | egrep -m 1 "ETTERCAP_INSTALL_PATH" | cut -d ':' -f2`   #
find3=`cat toolkit_config | egrep -m 1 "MACCHANGER_INSTALL_PATH" | cut -d ':' -f2` #
find4=`cat toolkit_config | egrep -m 1 "METASPLOIT_INSTALL_PATH" | cut -d ':' -f2` #
apache=`cat toolkit_config | egrep -m 1 "APACHE_INSTALL_PATH" | cut -d ':' -f2`    #
confW=`cat toolkit_config | egrep -m 1 "DRIFTNET_INSTALL_PATH" | cut -d ':' -f2`   #
####################################################################################






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






# ----------------------------------------
# start script functions
# ----------------------------------------
Colors;

       dtr=`date`
       # build logfile to store install bugs (dtr.log)
       echo "" > /tmp/dtr.log && echo "_::NETOOL::T00LKIT::=>::$ver::INSTALLER::BUG::REPORT::" >> /tmp/dtr.log
       echo "_::OS::=>::$OS::HOME::=>::$H0m3::PWD::=>::$spath::" >> /tmp/dtr.log
       echo "_::T00LKIT::DISTRO=>::$D1sTr0::USERNAME::=>::$usera::ID::=>::$IdU::" >> /tmp/dtr.log
       echo "_::" >> /tmp/dtr.log






# ----------------------------
# installer banner display
# ----------------------------
cat << !

         ┌┐┌┌─┐┌┬┐  ┌┬┐┌─┐┌─┐┬  ┌─┐
         │││├┤  │    │ │ ││ ││  └─┐
         ┘└┘└─┘ ┴    ┴ └─┘└─┘┴─┘└─┘$ver
 +---------------------------------------------+
 | Installer by: r00t-3xp10it & rawstring_enox |
 +---------------------------------------------+
 |   Script to quickly 'install' the toolkit   |
 |   in is right path, set permitions to all   |
 |   files, install dependencies, and start    |
 |   toolkit as root user (ubuntu distros)     |
 +---------------------------------------------+

!
Colors;
echo ${RedF}_${Reset};
echo ${BlueF}['>'][ PRESS${GreenF} ENTER ${BlueF}TO INSTALL TOOLKIT ]${Reset};
read op






 # ----------------------------
 # check if compatible OS distro (node name)
 # ----------------------------
 if [ "$OS" "=" "Kali" ] || [ "$OS" "=" "Ubuntu" ]; then
   echo ${BlueF}[*][Verify OS Compatibility][${GreenF} OK ${BlueF}]${Reset};

 else

   # fail comparing toolkit version to current installed Operative System
   echo ${RedF}[x]${BlueF}[Verify OS Compatibility][${RedF} FAIL ${BlueF}]${Reset};
   sleep 2
cat << !

  OPERATIVE SYSTEM  : $OS
  INSTALLER SET TO  : UBUNTU OR KALI
 +-----------------------------------------------------+
 | This installer only works in Ubuntu or Kali distros |
 +-----------------------------------------------------+
 |    IF YOU WISH TO INSTALL THE T00LKIT IN ANOTHER    |
 |    DISTRO, DOWNLOAD 'opensource[kali].tar.gz' AND   |
 |    FOLLOW THE INSTRUCTIONS ON MY 'WIKI' WEBPAGE     |
 +-----------------------------------------------------+

!
     dtr=`date`
     echo ${BlueF}[*][WIKI]${white}http://sourceforge.net/p/netoolsh/wiki/netool.sh%20script%20project/ ${Reset};
     echo ${RedF}[x]${BlueF}[Exit Installer][${YellowF} PLEASE CHECK YOUR LOGFILE '->' $spath/logs/dtr.log ${BlueF}]${Reset};
     echo "_::$dtr::=>::COMPARING::OPERATIVE-SYSTEM::$OS::NOT-SUPPORTED::" >> /tmp/dtr.log
     echo "_::" >> /tmp/dtr.log && echo "_::EOF" >> /tmp/dtr.log
     mv /tmp/dtr.log $spath/logs/dtr.log > /dev/null 2>&1
   exit
 fi
sleep 2





   # ----------------------------
   # check if toolkit release matches OS node name
   # ----------------------------
   if [ "$OS" "=" "$D1sTr0" ]; then
     echo ${BlueF}[*][Check Toolkit Release][${GreenF} OK ${BlueF}]${Reset};

   else

     # fail comparing toolkit release with current installed Operative System
     echo ${RedF}[x]${BlueF}[Check Toolkit Release][${RedF} FAIL ${BlueF}]${Reset};
    sleep 2
cat << !

  T00LKIT RELEASE  : $D1sTr0
  OPERATIVE SYSTEM : $OS
 +-------------------------------------------------+
 | Our operative system does not match the toolkit |
 | release, Please download the correct version.   |
 +-------------------------------------------------+
 |  opensource.tar.gz       => linux - Ubuntu      |
 |  opensource[kali].tar.gz => most linux distros  |
 +-------------------------------------------------+

!
     dtr=`date`
     # exit installer and write logfile in opensource/logs
     echo "_::$dtr::=>::T00LKIT-RELEASE::=>::$D1sTr0::OS::=>::$OS::NOT-SUPPORTED::" >> /tmp/dtr.log
     echo ${RedF}[x]${BlueF}[Exit Installer][${YellowF} PLEASE CHECK YOUR LOGFILE '->' $spath/logs/dtr.log ${BlueF}]${Reset};
     echo "_::" >> /tmp/dtr.log && echo "_::EOF" >> /tmp/dtr.log
     mv /tmp/dtr.log $spath/logs/dtr.log > /dev/null 2>&1
     exit
   fi
sleep 2





   # ----------------------------
   # check if script its in correct directory (path)
   # ----------------------------
   if [ "$rpath" "=" "$spath" ]; then
     echo ${BlueF}[*][Toolkit Install Path][${GreenF} OK ${BlueF}]${Reset};
     default=yes

   else

     dtr=`date`
     M1ss=yes
     # move toolkit to the rigth path depending of user input
     echo ${RedF}[x]${BlueF}[Toolkit Install Path][${RedF} FAIL ${BlueF}]${Reset};
     sleep 2
cat << !

  T00LKIT INSTALL PATH : $spath
  T00LKIT DEFAULT PATH : $H0m3/opensource
 +-------------------------------------------------+
 |      THIS MAY CAUSE A SCRIPT MALFUNCTION        |
 +-------------------------------------------------+
 |   Move toolkit directory to the right path?     |
 +-------------------------------------------------+

!


     echo "_::$dtr::=>::INSTALL-PATH::WRONG::DIRECTORY::=>::$spath::" >> /tmp/dtr.log
     read -p "[?]::[Move toolkit directory to the right path (y|n)]::" pass
     if test "$pass" = "y"
        then

          # FINALLY WE ARE IN THE RIGTH DIRECTION :D CONGRATZ FOR HAVING INSTALLED THIS SHIT IN THE RIGTH PATH :P
          echo ${BlueF}[*][Toolkit 'install' path][${GreenF} MOVING TO ${YellowF}'->'${GreenF} "$rpath" ${BlueF}] ${Reset};
          dtr=`date` # log file just for me to know whats happening during the install
          sleep 2 && echo "_::$dtr::=>::T00LKIT::MOVED::TO::=>::$rpath::" >> /tmp/dtr.log
          cp -r "$spath" "$rpath" > /dev/null 2>&1 # copy toolkit to default path
          rm -r "$spath" > /dev/null 2>&1 # remove old path
          default=yes # set a variable for me to know that we are in the rigth track
          cd $rpath # change to default directory

     else

          dtr=`date`
          M1ss=yes
          echo ""
          # abort moving toolkit path to rigth location (path)
          echo ${RedF}[x]${BlueF}[Toolkit 'install' path][${RedF} ABORTED ${BlueF}] ${Reset};
          echo ${RedF}[x][warning]${YellowF}TOOLKIT:MAY:DISPLAY:BUGS:WORKING:IN:ANOTHER:PATH ${Reset};
          echo "_::$dtr::=>::INSTALL-PATH::MOVE::ABORTED::DEFINED::BY::USER::SETTINGS" >> /tmp/dtr.log
          echo ""

       fi
   fi
sleep 2






   # ----------------------------
   # execute privs on all files
   # ----------------------------
   chmod +x *.sh && cd INURLBR && chmod +x *.php && cd ..
   cd modules && chmod +x *.sh *.py *.rb && cd ..
   cd sslstrip-0.9 && chmod +x *.py && cd ..
   echo ${BlueF}[*][Setting 'File' Permitions][${GreenF} OK ${BlueF}]${Reset};
   sleep 2






   # ----------------------------
   # config frameworks install path's (toolkit_config)
   # ----------------------------
   read -p "[?][Config Dependencies Path's (y|n)]:" pass
     if test "$pass" = "y"
       then
         xterm -T "toolkit_config" -geometry 75x38 -e "nano toolkit_config"
         # -----------------------------------------------------------------------
         # variable declarations (again to capture nano changes made)
         # ------------------------------------------------------------------------
         PhP=`cat toolkit_config | egrep -m 1 "PHP5_INSTALL_PATH" | cut -d ':' -f2`
         find=`cat toolkit_config | egrep -m 1 "ZENMAP_INSTALL_PATH" | cut -d ':' -f2`
         find2=`cat toolkit_config | egrep -m 1 "ETTERCAP_INSTALL_PATH" | cut -d ':' -f2`
         find3=`cat toolkit_config | egrep -m 1 "MACCHANGER_INSTALL_PATH" | cut -d ':' -f2`
         find4=`cat toolkit_config | egrep -m 1 "METASPLOIT_INSTALL_PATH" | cut -d ':' -f2`
         apache=`cat toolkit_config | egrep -m 1 "APACHE_INSTALL_PATH" | cut -d ':' -f2`
         confW=`cat toolkit_config | egrep -m 1 "DRIFTNET_INSTALL_PATH" | cut -d ':' -f2`
         echo ${BlueF}[*][Config dependencies path][${GreenF} OK ${BlueF}]${Reset};

     else

         dtr=`date`
         # aborted toolkit_config
         echo ${RedF}[x]${BlueF}[Config Dependencies Path][${RedF} ABORTED ${BlueF}]${Reset};
         echo "_::$dtr::=>::T00LKIT_CONFIG-PATHS::ABORTED::DEFINED::BY::USER::SETTINGS" >> /tmp/dtr.log

 fi
sleep 2






# ----------------------------------------
# INSTALL ALL DEPENDENCIES
# ----------------------------------------
echo ${BlueF}[*]['Install' Dependencies][${GreenF} RUNING ${BlueF}]${Reset};
sleep 2




   # check if macchanger installation exists
   if [ -e $find3 ]; then
   echo ${BlueF}[*][Macchanger][${GreenF} Installation found ${BlueF}]${Reset};

else

   echo ""
   dtr=`date`
   M1ss=yes
   # missing dependencie OR wrong path config
   echo ${RedF}[x][warning]${BlueF}[Macchanger][${RedF} Not Found In ${YellowF}'->'${RedF} $find3 ${BlueF}]${Reset};
   echo ${RedF}[x][warning]${white}THIS:TOOLKIT:REQUIRE:${RedF}[ Macchanger ]${white}:INSTALLED:TO:WORK.${Reset};
   echo ${RedF}[x][warning]${white}REMMENBER:TO:CHECK:${RedF}[ toolkit_config ]${white}:TO:SET:FRAMEWORK:PATHS ${Reset};
   echo "_::$dtr::=>::Macchanger::bug::not::found::in::=>::$find3::" >> /tmp/dtr.log

     sleep 2
     # missing dependencie - install
     echo ${BlueF}[*][Please wait][${GreenF} DOWNLOADING FROM NETWORK ${BlueF}]${Reset};
     echo ""
     sudo apt-get install macchanger macchanger-gtk
     echo ""
fi
sleep 2


   #check if metasploit exists
   if [ -d $find4 ]; then
   echo ${BlueF}[*][Metasploit][${GreenF} Installation found ${BlueF}]${Reset};

else

   echo ""
   dtr=`date`
   M1ss=yes 
   # missing dependencie - redirect to darkoperator webpage
   echo ${RedF}[x][warning]${BlueF}[Metasploit][${RedF} Not Found In ${YellowF}'->'${RedF} $find4 ${BlueF}]${Reset};
   echo ${RedF}[x][warning]${white}THIS:TOOLKIT:REQUIRE:${RedF}[ Metasploit ]${white}:INSTALLED:TO:WORK...${Reset};
   echo ${RedF}[x][warning]${white}REMMENBER:TO:CHECK:${RedF}[ toolkit_config ]${white}:TO:SET:FRAMEWORK:PATHS ${Reset};
   echo ${RedF}[x]${YellowF}'more info' here: http://www.darkoperator.com/installing-metasploit-in-ubunt/ ${Reset};
   echo "_::$dtr::=>::Metasploit::bug::not::found::in::=>::$find4::" >> /tmp/dtr.log
   echo ""

fi
sleep 2


   # check if driftnet installation existes
   if [ -d $confW ]; then
   echo ${BlueF}[*][Driftnet][${GreenF} Installation found ${BlueF}]${Reset};

else

   echo ""
   dtr=`date`
   M1ss=yes
   # missing dependencie OR wrong path config
   echo ${RedF}[x][warning]${BlueF}[Driftnet][${RedF} Not Found In ${YellowF}'->'${RedF} $confW ${BlueF}]${Reset};
   echo ${RedF}[x][warning]${white}THIS:TOOLKIT:REQUIRE:${RedF}[ Driftnet ]${white}:INSTALLED:TO:WORK... ${Reset};
   echo ${RedF}[x][warning]${white}REMMENBER:TO:CHECK:${RedF}[ toolkit_config ]${white}:TO:SET:FRAMEWORK:PATHS ${Reset};
   echo "_::$dtr::=>::Driftnet::bug::not::found::in::=>::$confW::" >> /tmp/dtr.log

     sleep 2
     # missing dependencie - install
     echo ${BlueF}[*][Please wait][${GreenF} DOWNLOADING FROM NETWORK ${BlueF}]${Reset};
     echo ""
     sudo apt-get install driftnet
     echo ""
fi
sleep 2


   # check if ettercap installation exists
   if [ -d $find2 ]; then
   echo ${BlueF}[*][Ettercap][${GreenF} Installation found ${BlueF}]${Reset};

else
 
   echo ""
   dtr=`date`
   M1ss=yes
   # missing dependencie OR wrong path config
   echo ${RedF}[x][warning]${BlueF}[Ettercap][${RedF} Not Found In ${YellowF}'->'${RedF} $find2 ${BlueF}]${Reset};
   echo ${RedF}[x][warning]${white}THIS:TOOLKIT:REQUIRE:${RedF}[ Ettercap ]${white}:INSTALLED:TO:WORK... ${Reset};
   echo ${RedF}[x][warning]${white}REMMENBER:TO:CHECK:${RedF}[ toolkit_config ]${white}:TO:SET:FRAMEWORK:PATHS ${Reset};
   echo "_::$dtr::=>::Ettercap::bug::not::found::in::=>::$find2::" >> /tmp/dtr.log
 
     sleep 2
     # missing dependencie - install
     echo ${BlueF}[*][Please wait][${GreenF} DOWNLOADING FROM NETWORK ${BlueF}]${Reset};
     echo ""
     sudo apt-get install ettercap
     echo ""
fi
sleep 2
 
 
   #check if apache exists
   if [ -d $apache ]; then
   echo ${BlueF}[*][Apache][${GreenF} Installation found ${BlueF}]${Reset};
 
else
 
   echo ""
   dtr=`date`
   M1ss=yes
   # missing dependencie OR wrong path config
   echo ${RedF}[x][warning]${BlueF}[Apache2][${RedF} Not Found In ${YellowF}'->'${RedF} $apache ${BlueF}]${Reset};
   echo ${RedF}[x][warning]${white}THIS:TOOLKIT:REQUIRE:${RedF}[ Apache2 ]${white}:INSTALLED:TO:WORK... ${Reset};
   echo ${RedF}[x][warning]${white}REMMENBER:TO:CHECK:${RedF}[ toolkit_config ]${white}:TO:SET:FRAMEWORK:PATHS ${Reset};
   echo "_::$dtr::=>::Apache2::bug::not::found::in::=>::$apache::" >> /tmp/dtr.log
 
     sleep 2
     # missing dependencie - install
     echo ${BlueF}[*][Please wait][${GreenF} DOWNLOADING FROM NETWORK ${BlueF}]${Reset};
     echo ""
     sudo apt-get install apache2
     echo ""
fi
sleep 2
 
 
   #check if zenity exists
   if [ -e $Z3n ]; then
   echo ${BlueF}[*][Zenity][${GreenF} Installation found ${BlueF}]${Reset};
 
else
 
   echo ""
   dtr=`date`
   M1ss=yes
   # missing dependencie - install
   echo ${RedF}[x][warning]${BlueF}[Zenity][${RedF} Not Found In ${YellowF}'->'${RedF} $Z3n ${BlueF}]${Reset};
   echo ${RedF}[x][warning]${white}THIS:TOOLKIT:REQUIRE:${RedF}[ Zenity ]${white}:INSTALLED:TO:WORK... ${Reset};
   echo ${RedF}[x][warning]${white}REMMENBER:TO:CHECK:${RedF}[ toolkit_config ]${white}:TO:SEE:IF:PROPER:INSTALLED ${Reset};
   echo "_::$dtr::=>::zenity::bug::dependencie::not::found::in::=>$Z3n::" >> /tmp/dtr.log

     sleep 2
     # missing dependencie - install
     echo ${BlueF}[*][Please wait][${GreenF} DOWNLOADING FROM NETWORK ${BlueF}]${Reset};
     echo ""
     sudo apt-get install zenity libnotify
     echo ""
fi
sleep 2
 
 
   # check if nmap installation exists
   if [ -d $find ]; then
   echo ${BlueF}[*][Nmap][${GreenF} Installation found ${BlueF}]${Reset};
 
else
 
   echo ""
   dtr=`date`
   M1ss=yes
   # missing dependencie OR wrong path config
   echo ${RedF}[x][warning]${BlueF}[Nmap][${RedF} Not Found In ${YellowF}'->'${RedF} $find ${BlueF}]${Reset};
   echo ${RedF}[x][warning]${white}THIS:TOOLKIT:REQUIRE:${RedF}[ Nmap ]${white}:INSTALLED:TO:WORK... ${Reset};
   echo ${RedF}[x][warning]${white}REMMENBER:TO:CHECK:${RedF}[ toolkit_config ]${white}:TO:SET:FRAMEWORK:PATHS ${Reset};
   echo "_::$dtr::=>::Nmap::bug::not::found::in::=>::$find::" >> /tmp/dtr.log
 
     sleep 2
     # missing dependencie - install
     echo ${BlueF}[*][Please wait][${GreenF} DOWNLOADING FROM NETWORK ${BlueF}]${Reset};
     echo ""
     sudo apt-get install nmap
     echo ""
fi
sleep 2
 
 
   # check for INURLBR dependencies (php5 and curl)
   if [ -e $CuRl ]; then
   echo ${BlueF}[*][Curl][${GreenF} Installation found ${BlueF}]${Reset};
   sleep 2
   if [ -e $PhP ]; then
   echo ${BlueF}[*][php5][${GreenF} Installation found ${BlueF}]${Reset};
 
else
 
   echo ""
   dtr=`date`
   M1ss=yes
   # not found dependencies = install
   echo ${RedF}[x]${BlueF}[INURLBR dependencies][${RedF} FAIL ${BlueF}]${Reset};
   echo "_::$dtr::=>::inurlbr::bug::dependencies::not::found::" >> /tmp/dtr.log

     sleep 2
     # missing dependencie - install
     echo ${BlueF}[*][Please wait][${GreenF} DOWNLOADING FROM NETWORK ${BlueF}]${Reset};
     echo ${BlueF}[*][Installing]:${YellowF}curl'::'libcurl3'::'libcurl3-dev'::'php5'::'php5-curl'::'php5-cli'::' ${Reset};
     echo ""
     sudo apt-get install curl libcurl3 libcurl3-dev php5 php5-cli php5-curl
     /etc/init.d/apache2 restart > /dev/null 2>&1
     echo ""
  fi
fi
sleep 2






# ----------------------------------------------------
# display dependencies current state and build logfile
# ----------------------------------------------------
   echo "_::" >> /tmp/dtr.log
   echo "_::EOF" >> /tmp/dtr.log
   if [ "$M1ss" "=" "yes" ]; then
     # warn user that dependencies are partially installed
     echo ${BlueF}[*][Clean Everything Up][${GreenF} OK ${BlueF}]${Reset};
     sleep 1
     echo ${BlueF}[*][FINISHING INSTALLER][${RedF} WITH SOME ERRORS ${BlueF}]${Reset};
     echo ${BlueF}[*]${YellowF}[ PLEASE CHECK YOUR LOGFILE '->' $H0m3/dtr.log ${BlueF}]${Reset};
     mv /tmp/dtr.log $H0m3/dtr.log > /dev/null 2>&1
     sleep 2
 
else
 
  # everything ok :D
  echo ${BlueF}[*][Clean Everything Up][${GreenF} OK ${BlueF}]${Reset};
  sleep 1
  echo ${BlueF}[*][FINISHING INSTALLER][${GreenF} OK ${BlueF}]${Reset};
  rm /tmp/dtr.log > /dev/null 2>&1
fi
sleep 2





# ----------------------------------------
# END INSTALL DEPENDENCIES
# ----------------------------------------
 
   # display toolkit current install path clean old files and run the tool
   if [ "$default" "=" "yes" ]; then
     echo ${BlueF}[*]['Install' Path][${GreenF} $rpath/netool.sh ${BlueF}]${Reset};
     sleep 2
     cp $H0m3/dtr.log $rpath/logs/dtr.log > /dev/null 2>&1
     echo ${RedF}_${Reset};
     echo ${BlueF}['>'][ PRESS${GreenF} ENTER ${BlueF}TO START T00LKIT ]${Reset};
     read op && clear
     sudo $rpath/netool.sh
 
   else
 
     # display toolkit current install path clean old files and run the tool
     echo ${BlueF}[*]['Install' Path][${GreenF} $spath/netool.sh ${BlueF}]${Reset};
     sleep 2
     cp $H0m3/dtr.log $spath/logs/dtr.log > /dev/null 2>&1
     echo ${RedF}_${Reset};
     echo ${BlueF}['>'][ PRESS${GreenF} ENTER ${BlueF}TO START T00LKIT ]${Reset};
     read op && clear
     sudo $spath/netool.sh
 
fi
