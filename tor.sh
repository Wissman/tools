#!/bin/bash
# Original tor-installer script (C) by www.kali-linux.fr
# Under licence GPLv3 http://www.gnu.org/licenses/gpl.txt
 
red='\e[0;31m'
green='\e[0;32m'
NC='\e[0m'
 
function errortest(){
if [ $? == 0 ]
then
echo -e "[$green*$NC]Pret!!"
else
echo -e "[$red*$NC]Error!!"
fi
}
 
echo "                                                                   r;;
                                                                    ,,
                                                                   ,
    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;                       ., .   ,.
2rriSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSirrs                   ,;,. ..
XsS5522222222222222222222222222222222222Siirs               ....:;: ,,
X5XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX222ii              .,:,;;,,::
X2XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXSi             ,::;;,;:
X2XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXSi            ..;;;,:,
X5XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXSi            ,:;;::S
X5XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXSi        $  .,;:::
X5XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXSi        B  ::r;.
Xi522222222222XXXXXXXXXXXXXXXXXX22222222222si         i  .,                                        ;rrr;r;;@
2S5222222222252XXXXXXXXXXXXXXXX2XXXX2222225Ss            . 9                                  ;rrrsiiiiiiirX
   :XXXXXX2@S55XXXXXXXXXXXXXXX2X2;;3XXXXX;               ..AA                              rrrisssiS52222552
             S5XXXXXXXXXXXXXXX2X                      X  , @iB                           srssi52222XXXXX222X
             i52XXXXXXXXXXXXXX25                     :   : S@r9                         rssS2XXXXXXXXXXXXX2X
             i52XXXXXXXXXXXXXX5S                  A,   ,,,  h#rrXM                     rsS2XXXXXXXXXXXXXXX2X
             i52XXXXXXXXXXXXX2Si                ;      3 ,:  G@srrsh                  rs5XXXXXXXXXXXXXXXXX2X
             i52XXXXXXXXXXXXX2Si             M.       9; .r   H@iisrr2M              ri2XXXXXXXXXXXXXXXXXX2X
             i52XXXXXXXXXXXXX2Si           B       .s9;  , G   @HS5SirrSM            iSXXXXXXXXXXXXXXXXXXX2X
             i52XXXXXXXXXXXXX2Si          ,      ;GG;    : ,A  ,@2225SirrX          sS2XXXXXXXXXXXXXXX2255S2
             i52XXXXXXXXXXXXX2Si        H      iH2.     .;, ;G  @B52222Siri         iSXXXXXXXXXXXXXXX222225X
             i52XXXXXXXXXXXXX2Si       M     r#i       ;,:S  Si S@S222225Sri        iSXXXXXXXXXXXXXX222i
             i52XXXXXXXXXXXXX2Si            AA       .s; ,h;  $  @222XX222Srh       iSXXXXXXXXXXXXX22#
             i52XXXXXXXXXXXXX2Si      A    B2      :rr,  , $, ;X @hS2XXX222is       iSXXXXXXXXXXXXX52
             i52XXXXXXXXXXXXX2Si      r   5G     rhr     ,  A  H @HS2XXXX225rB      iSXXXXXXXXXXXXX5S
             i52XXXXXXXXXXXXX2Si      ;   @     MX       i  :h S.@Mi2XXXXX22sA      iSXXXXXXXXXXXXXSi
             i52XXXXXXXXXXXXX2Si      r  ,#    @r      ,rri  $ ;r@Bi2XXXXXX2sH      iSXXXXXXXXXXXXXSi
             i52XXXXXXXXXXXXX2Si          @   iX      rA  3, 5;;i@Ai2XXXXXX2i       iSXXXXXXXXXXXXXSi
             i52XXXXXXXXXXXXX2Si          2h  A.     ,#  .;A i2i2@9S2XXXXXX52       iSXXXXXXXXXXXXXSi
             i52XXXXXXXXXXXXX2Si           @:  s     X:  ,.@ ih5h@252XXXXX2i        iSXXXXXXXXXXXXXSi
             i52XXXXXXXXXXXXX2Si        $   @ .@     A   , @ 2Ar@@i22XXXX2S#        iSXXXXXXXXXXXXXSi
             i52XXXXXXXXXXXXX2Si             $  @    Mr  ..@ HS:@ i2XX22S2          iSXXXXXXXXXXXXXSi
             i52XXXXXXXXXXXXX2Si           i  3:M@   .@   s  $;p@i5222S5A           iSXXXXXXXXXXXXXSi
             i52XXXXXXXXXXXXX2Si             r ::i@;  s@  @;X#@@5iSiSXB             iSXXXXXXXXXXXXXSi
             iS2X22222222222X2ii               GXs;2S, s5sBG@@@srS3H                ii2222222222222iS
             X2222222222222222XX                   hM##AB@#@@#AB#                   2222222222222222X"
 
echo "Appuyez sur une touche pour continuer"
read
 
echo "deb http://deb.torproject.org/torproject.org wheezy main" >> /etc/apt/sources.list
clear
echo "[*] On installe les clefs...."
gpg --keyserver keys.gnupg.net --recv 886DDD89
<code>gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
</code>errortest
echo "Appuyez sur une touche pour continuer"
read
clear
echo "[*] Mise a jour des depots...."
apt-get update
clear
echo "[*] Installation de TOR"
apt-get install -y deb.torproject.org-keyring
apt-get install tor
errortest
echo "Appuyez sur une touche pour continuer"
read
echo "[*] Installation de Vidalia"
apt-get install vidalia
errortest
echo "Appuyez sur une touche pour continuer"
read
echo "[*] Installation de iceweasel-torbutton"
echo "Torbutton is no longer supported.\nUsers should be using Tor Browser Bundle, not installing Torbutton themselves."
errortest
echo "Appuyez sur une touche pour continuer"
read
clear
echo "[*] Installation de Privoxy"
apt-get install privoxy
echo "[*] Configuration de privoxy"
echo "forward-socks5 / 127.0.0.1:9050 ." >> /etc/privoxy/config
errortest
echo "Appuyez sur une touche pour continuer"
read
service tor restart
service privoxy restart
errortest
echo "Appuyez sur une touche pour continuer"
read
echo "Tor est desormais disponible sur votre kali. Ajouter 127.0.0.1:9050 comme proxie a votre navigateur"
