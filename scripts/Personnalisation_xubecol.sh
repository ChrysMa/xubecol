#!/bin/bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
set +e

VERSION_INSTALLATEUR="1.1"


#Saisie du mot de passe
sudo echo "OK pour le mot de passe !"
if [ ${?} = 1 ]
then
 zenity --error --text "Vous devez disposer du mot de passe pour effectuer la personnalisation !"
 exit 1
fi

# CM : A partir de ce moment si on veut garder les droits root (sudo) plusieurs stratégies sont possibles
# 1- faire une boucle sans fin en tache de fond (background &) qui lance sudo toutes 30 secondes, récupérer son process id (PID) et faire un kill à la fin du shell : risqué sauf pour un script d'installation
# 2- faire un sub-shell (donc tout ce qui suit devrait être dans un second script shell et faire un exec sudo /tmp/subshell.sh par exemple : la meilleure stratégie à mon avis
# 3- faire un $ sudo su - et à partir de cet instant et jusqu'à la fin du shell script on a les droits root
#
# Note : à partir du moment où le shell suivant est sensible à la version de xubuntu, j'opterai pour l'option 2 qui au passage irait chercher/télécharger la version du subshell en fonction de la version XUBUNTU détectée. Ce qui permet d'etre tolérant aux sous-versions (si nécessaire). 

# En attendant :
sudo su -

#Vérification session eleve, prof ou directeur
SESSION=${HOME:6}
ERREUR="- session non reconnue : <b>${SESSION}</b> (attendu : eleve, prof ou directeur)\n"
PLUR="la raison suivante"
case ${SESSION} in
 "eleve" | "prof" | "directeur") ERREUR="" ;;
esac


#Vérification de la version de Xubuntu (14.04.2)
VERSION_ATTENDUE="Ubuntu 14.04.2 LTS"
VERSION_XUBUNTU=`cat /etc/issue`
VERSION_XUBUNTU=${VERSION_XUBUNTU% \\n \\l}
if [ "$VERSION_XUBUNTU" = "$VERSION_ATTENDUE" ]
then
 echo ""
else
 if [ "$ERREUR" = "" ] 
 then  
  echo ""
 else 
  PLUR="les raisons suivantes" 
 fi
 ERREUR="$ERREUR- version du système non compatible : <b>${VERSION_XUBUNTU}</b> (attendu : $VERSION_ATTENDUE)\n"
fi


#Erreur ou confirmation de la procédure
if [ "$ERREUR" = "" ]
then
 if  ! zenity --question --no-wrap --text "Confirmez l'installation de XubEcol pour une session\n\n <span font='20' color='red'>$SESSION</span>...\n\nEn cas d'erreur, une nouvelle personnalisation écrasera l'ancienne.\n\nFermez le navigateur pour éviter les conflits de paramétrages..." --title XubEcol 
 then
  zenity --info --text "Dommage ! \n\nÀ une prochaine fois, peut-être..."
  exit 0;  
 fi
else
 zenity --error --title "Erreur de configuration" --no-wrap --text "Ce script permet de personnaliser une session <b>eleve</b>, <b>prof</b> ou <b>directeur</b> de Xubuntu pour la transformer en XubEcol.\n\n Attention à n'utiliser ce script que sur une session fraîchement installée, car certains paramètres de configuration seront irrémédiablement perdus.\n\n <span color='red' font='14'>L'opération est impossible pour $PLUR : \n$ERREUR</span>\nPour tout renseignement : <a href='http://www.xubecol.ovh/index.php?page=telechargements'>http://www.xubecol.ovh</a>"
 #sortie en erreur
 exit 1

fi

# =================================
# Suppression des logiciels inutiles
# =================================
#CM : on pourrait tout mettre dans 1 seule ligne de commande mais du coup plus d'indicateur de progression
(
echo "10" ; sleep 1
echo "# Suppression d'Abiword" ; sleep 1
apt-get --purge -y remove abiword           
echo "20" ; sleep 1
echo "# Suppression de Gnumeric" ; sleep 1
apt-get --purge -y remove gnumeric          
echo "30" ; sleep 1
echo "# Suppression de Pidgin" ; sleep 1
apt-get --purge -y remove pidgin            
echo "40" ; sleep 1
echo "# Suppression de Gmusicbrowser" ; sleep 1
apt-get --purge -y remove gmusicbrowser     
echo "50" ; sleep 1
echo "# Suppression de Transmission" ; sleep 1
apt-get --purge -y remove transmission-gtk  
echo "60" ; sleep 1
echo "# Suppression de Xchat" ; sleep 1
apt-get --purge -y remove xchat             
echo "70" ; sleep 1
echo "# Suppression de Parole" ; sleep 1
apt-get --purge -y remove parole
echo "80" ; sleep 1
echo "# Suppression d'Orage" ; sleep 1
apt-get --purge -y remove orage
echo "90" ; sleep 1
echo "# Suppression de Light Locker" ; sleep 1
apt-get --purge -y remove light-locker-settings
echo "100" ; sleep 1
) |
zenity --progress \
 --title="# Suppression des logiciels inutiles" \
 --text="Analyse des logiciels inutiles..." \
 --percentage=0

if [ "$?" = -1 ] ; then
  zenity --error \
    --text="Suppression annulée."
# Pas d'exit 0 car ce n'est pas critique
fi

# =================================
# Installation des logiciels indispensables
# =================================
(
echo "10" ; sleep 1
echo "# Installation de VLC (ça peut être long)..." ; sleep 1
apt-get -y install vlc              
echo "20" ; sleep 1
echo "# Installation de Pinta (ça peut être long)..." ; sleep 1
apt-get -y install pinta        
echo "30" ; sleep 1
echo "# Installation de Chromium (ça peut être long)..." ; sleep 1
apt-get -y install chromium-browser
echo "40" ; sleep 1
echo "# Installation de LibreOffice (ça peut être très long)..." ; sleep 1
apt-get -y install libreoffice libreoffice-l10n-fr libreoffice-help-fr hyphen-fr
echo "50" ; sleep 1
echo "# Installation de Gcompris (ça peut être très long)..." ; sleep 1
apt-get -y install gcompris
echo "60" ; sleep 1
echo "# Installation de TuxPaint (ça peut être long)..." ; sleep 1
apt-get -y install tuxpaint
echo "70" ; sleep 1
echo "# Installation de TuxType (ça peut être long)..." ; sleep 1
apt-get -y install tuxtype
echo "80" ; sleep 1
echo "# Installation d'Audacity (ça peut être long)..." ; sleep 1
apt-get -y install audacity
echo "90" ; sleep 1
echo "# Installation des librairies Lame (ça peut être long)..." ; sleep 1
apt-get -y install libmp3lame0
echo "95" ; sleep 1
echo "# Installation de Wine (ça peut être très très long)..." ; sleep 1
apt-get -y install wine
echo "100" ; sleep 1
) |
zenity --progress \
 --title="# Installation des logiciels indispensables" \
 --text="Patience l'installation peut durer longtemps..." \
 --percentage=0

if [ "$?" = -1 ] ; then
  zenity --error \
    --text="Installation annulée."
  exit 1
fi

# =================================
# Nettoyage...
# =================================
echo "# Nettoyage..."
apt-get --purge -y autoremove

# CM : J'opterai pour tout mettre dans un zip, qu'on peut stocker localement , ce qui permet de faire une install meme offline si besoin
# cela dit avec les paquets requis ci dessus... ca se discute

# Téléchargements des utilitaires
echo "# Téléchargements des utilitaires"
echo "# Logo du splash screen"
wget -N -O /lib/plymouth/themes/xubuntu-logo/logo.png http://www.xubecol.ovh/media/logo_splashscreen.png
echo "# Fond d'écran"
wget -N -O /usr/share/xfce4/backdrops/xubuntu-trusty.png http://www.xubecol.ovh/media/fond_$SESSION.jpg
echo "# Raccourci vers le serveur"
wget -N -P $HOME/Bureau http://www.xubecol.ovh/media/Stockage.desktop
chmod ugo+x $HOME/Bureau/Stockage.desktop
echo "# Raccourci vers la documentation"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/Kit de survie XubEcol.desktop"
chmod ugo+x "$HOME/Bureau/Kit de survie XubEcol.desktop"
echo "# Raccourci LibreOffice"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/LibreOffice.desktop"
chmod ugo+x $HOME/Bureau/LibreOffice.desktop
echo "# Raccourci Firefox"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/Navigateur Web Firefox.desktop"
chmod ugo+x "$HOME/Bureau/Navigateur Web Firefox.desktop"
echo "# Raccourci Gcompris"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/gcompris.desktop"
chmod ugo+x "$HOME/Bureau/gcompris.desktop"
echo "# Raccourci TuxPaint"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/tuxpaint.desktop"
chmod ugo+x "$HOME/Bureau/tuxpaint.desktop"
echo "# Raccourci TuxType"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/tuxtype.desktop"
chmod ugo+x "$HOME/Bureau/tuxtype.desktop"
echo "# Script Post-Installation adresse IP"
wget -N -P $HOME/XubEcol/PostInstallation http://www.xubecol.ovh/media/Modifier_adresse_IP.sh
chmod ugo+x $HOME/XubEcol/PostInstallation/Modifier_adresse_IP.sh
echo "# Script Post-Installation nom ordi et domaine"
wget -N -P $HOME/XubEcol/PostInstallation http://www.xubecol.ovh/media/Modifier_nom_ordi_et_domaine.sh
chmod ugo+x $HOME/XubEcol/PostInstallation/Modifier_nom_ordi_et_domaine.sh
echo "# Script Post-Installation 1000mots"
wget -N -P $HOME/XubEcol/PostInstallation http://www.xubecol.ovh/media/Installation_1000_Mots/inst-mm.sh
chmod ugo+x $HOME/XubEcol/PostInstallation/inst-mm.sh
echo "# Pilote générique laser couleur"
wget -N -P $HOME/XubEcol/Pilotes http://www.xubecol.ovh/media/Generic-PCL_6_PCL_XL_Printer-pxlcolor.ppd
echo "# Pilote générique laser monochrome"
wget -N -P $HOME/XubEcol/Pilotes http://www.xubecol.ovh/media/Generic-PCL_6_PCL_XL_Printer-pxlmono.ppd

# Paramétrages interface
echo "# Rangement des icônes sur le bureau (~/.config/xfce4/desktop/ [ icons.screen0-nnxnn.rc ])"
rm $HOME/.config/xfce4/desktop/icons.screen0-nnxnn.rc
FICHIER=`ls $HOME/.config/xfce4/desktop/`
wget -N -P $HOME/.config/xfce4/desktop/ http://www.xubecol.ovh/media/config/icons.screen0-nnxnn.rc
cp $HOME/.config/xfce4/desktop/icons.screen0-nnxnn.rc $HOME/.config/xfce4/desktop/$FICHIER
echo "# Elimination de l'icône Système de fichiers (~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml)"
wget -N -P $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/ http://www.xubecol.ovh/media/config/xfce4-desktop.xml
echo "# paramétrage du menu ~/.config/xfce4/panel/whiskermenu-1.rc)"
wget -N -P $HOME/.config/xfce4/panel/ http://www.xubecol.ovh/media/config/whiskermenu-1.rc
wget -N -P $HOME/.config/menus/ http://www.xubecol.ovh/media/config/xfce-applications.menu
echo "# Affichage état batterie (ne fonctionne pas actuellement !)"
wget -N -P $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/ http://www.xubecol.ovh/media/config/xfce4-power-manager.xml
echo "# Oblitération de la mise en veille"
wget -N -P $HOME/ http://www.xubecol.ovh/media/config/.xscreensaver
xset -display :0 s 0 0 s off -dpms
echo "# Oblitération des mises à jour"
wget -N -P /etc/apt/apt.conf.d/ http://www.xubecol.ovh/media/config/10periodic
echo "# Suppression du compte invité"
chmod 777 /usr/share/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
echo -e "\nallow-guest=false" >> /usr/share/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
chmod 755 /usr/share/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
echo "# Vidage de la corbeille"
rm -rv $HOME/.local/share/Trash/

# Firefox
echo "# Paramétrages de Firefox"
DOSSIER=`ls -d $HOME/.mozilla/firefox/*.default`
if [[ ${SESSION} = "eleve" ]]
 then
  echo "# Page de démarrage et proxecoles"
  wget -N -P $DOSSIER http://www.xubecol.ovh/media/config/prefs.js_eleve
  cp $DOSSIER/prefs.js_eleve $DOSSIER/prefs.js  
 fi
if [[ ${SESSION} = "prof" ]]
 then
  echo "# Page de démarrage et favoris"
  wget -N -P $DOSSIER http://www.xubecol.ovh/media/config/prefs.js_prof
  cp $DOSSIER/prefs.js_prof $DOSSIER/prefs.js  
 fi
if [[ ! -d $DOSSIER/adblockplus ]]
 then
  echo "# Extension AdblockPlus"
  wget -N -P $HOME/XubEcol/temp https://update.adblockplus.org/latest/adblockplusfirefox.xpi
  firefox $HOME/XubEcol/temp/adblockplusfirefox.xpi
 else
  echo "# Extension AdblockPlus pour Firefox déjà installée !"
 fi
 
# Paramétrage IP fixe ?
echo "# Paramétrage IP fixe ?"
if zenity --question --no-wrap --text "Souhaitez-vous paramétrer une adresse IP fixe ?\n\nCette opération peut être effectuée plus tard à l'aide du script téléchargé dans le dossier ~/XubEcol/PostInstallation..." --title XubEcol 
 then
  ~/XubEcol/PostInstallation/Modifier_adresse_IP.sh
 fi
 
# Paramétrage Nom ordi et nom domaine 
echo "# Nom de l'ordinateur et nom du réseau"
~/XubEcol/PostInstallation/Modifier_nom_ordi_et_domaine.sh

# Installation de 1000mots
echo "# Installation de 1000mots"
if zenity --question --no-wrap --text "Souhaitez-vous installer 1000mots ?\n\nCette opération peut être effectuée plus tard à l'aide du script téléchargé dans le dossier ~/XubEcol/PostInstallation..." --title XubEcol 
 then
  ~/XubEcol/PostInstallation/inst-mm.sh
  echo "# Raccourci 1000mots"
 fi
 
# Installation serveur de documents 
if [[ ${SESSION} = "prof" ]]
 then
  echo "# Serveur de documents"
  if zenity --question --no-wrap --text "Souhaitez-vous installer le serveur de documents ?\n\nCette opération peut être effectuée plus tard à l'aide du script téléchargé dans le dossier ~/XubEcol/PostInstallation..." --title XubEcol 
  then
   wget -N -P $HOME/XubEcol/PostInstallation http://www.xubecol.ovh/media/Installation_Serveur_documents.sh
   chmod ugo+x $HOME/XubEcol/PostInstallation/Installation_Serveur_documents.sh
   ~/XubEcol/PostInstallation/Installation_Serveur_documents.sh
  fi 
 fi

# CM : Ajout du safesearch (généralisé pour le poste) sur Google :
# SafeSearch ne sera actif qu'après redémarrage du démon named (ou redémarrage de la machine)

zenity --info --no-wrap --text "Activation de Google Safe Search"

cat >>/etc/bind/db.local <<EOF

;
; Forcer Google Safe Search
;
google.com IN CNAME forcesafesearch.google.com.
www.google.com IN CNAME forcesafesearch.google.com.
google.fr IN CNAME forcesafesearch.google.com.
www.google.fr IN CNAME forcesafesearch.google.com.

EOF
 
# Mises à jour... 
echo "# Mises à jour..."
if zenity --question --no-wrap --text "Souhaitez-vous vérifier les mises à jour ?" --title XubEcol 
 then
   update-manager
 fi
 
# Informations de version 
echo "# Création du fichier de version"
JOUR=$(date +%d/%m/%Y)
V32_OU_64=`uname -m`
if [ $V32_OU_64 = "x86_64" ]
then
 VERSION_PROC="x86_64 (64bits)"
else
 VERSION_PROC="i686 (32bit)"
fi
echo "Xubecol version 4.0 du 7/05/2015

Distribution pour les écoles installée le $JOUR
à partir de $VERSION_XUBUNTU $VERSION_PROC.
(Script de personnalisation version $VERSION_INSTALLATEUR)

http://www.xubecol.ovh">$HOME/version.txt
echo "# Fin de la personnalisation de XubEcol"
zenity --info --no-wrap --text "Personnalisation terminée avec succès !\n(enfin, on espère...)"


# Nettoyage
echo "# Suppression du script"
rm ./Personnalisation_xubecol.sh

# Re-Rangement des icônes sur le bureau !!!
echo "# Re-Rangement des icônes sur le bureau !!!"
cp $HOME/.config/xfce4/desktop/icons.screen0-nnxnn.rc $HOME/.config/xfce4/desktop/$FICHIER


# Redémarrage du PC
echo "# Redémarrage du PC"
if zenity --question --no-wrap --text "Souhaitez-vous redémarrer l'ordinateur maintenant ?\n\nCette opération est indispensable pour que les modifications soient prises en compte..." --title XubEcol 
 then
  reboot
 fi


# Améliorations prévues
echo .
echo .
echo -------------------------------------------------------------
echo "Installateur version $VERSION_INSTALLATEUR"
echo -------------------------------------------------------------
echo "La personnalisation de Xubuntu vers XubEcol est terminée !"
echo .
echo "Les améliorations suivantes sont en cours de préparation :"
echo "- Affichage jauge batterie"
echo .
echo .

exit 0;  

# Fin !

