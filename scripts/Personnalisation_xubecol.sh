#!/bin/bash

VERSION_INSTALLATEUR="1.1"


#Saisie du mot de passe
sudo echo "OK pour le mot de passe !"
if [ ${?} = 1 ]
then
 zenity --error --text "Vous devez disposer du mot de passe pour effectuer la personnalisation !"
 exit 0;  
fi

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
exit 0
fi

#Suppression des logiciels inutiles
echo "# Suppression des logiciels inutiles"
echo "# Suppression d'Abiword"
sudo apt-get -y remove abiword           
echo "# Suppression de Gnumeric"
sudo apt-get -y remove gnumeric          
echo "# Suppression de Pidgin"
sudo apt-get -y remove pidgin            
echo "# Suppression de Gmusicbrowser"
sudo apt-get -y remove gmusicbrowser     
echo "# Suppression de Transmission"
sudo apt-get -y remove transmission-gtk  
echo "# Suppression de Xchat"
sudo apt-get -y remove xchat             
echo "# Suppression de Parole"
sudo apt-get -y remove parole
echo "# Suppression d'Orage"
sudo apt-get -y remove orage
echo "# Suppression de Light Locker"
sudo apt-get -y remove light-locker-settings

# Installation des logiciels indispensables
echo "# Installation des logiciels indispensables"
echo "# Installation de VLC (ça peut être long)..."
sudo apt-get -y install vlc              
echo "# Installation de Pinta (ça peut être long)..."
sudo apt-get -y install pinta        
echo "# Installation de Chromium (ça peut être long)..."
sudo apt-get -y install chromium-browser
echo "# Installation de LibreOffice (ça peut être très long)..."
sudo apt-get -y install libreoffice libreoffice-l10n-fr libreoffice-help-fr hyphen-fr
echo "# Installation de Gcompris (ça peut être très long)..."
sudo apt-get -y install gcompris
echo "# Installation de TuxPaint (ça peut être long)..."
sudo apt-get -y install tuxpaint
echo "# Installation de TuxType (ça peut être long)..."
sudo apt-get -y install tuxtype
echo "# Installation d'Audacity (ça peut être long)..."
sudo apt-get -y install audacity
echo "# Installation des librairies Lame (ça peut être long)..."
sudo apt-get -y install libmp3lame0
echo "# Installation de Wine (ça peut être très très long)..."
sudo apt-get -y install wine

# Nettoyage...
echo "# Nettoyage..."
sudo apt-get -y autoremove

# Téléchargements des utilitaires
echo "# Téléchargements des utilitaires"
echo "# Logo du splash screen"
sudo wget -N -O /lib/plymouth/themes/xubuntu-logo/logo.png http://www.xubecol.ovh/media/logo_splashscreen.png
echo "# Fond d'écran"
sudo wget -N -O /usr/share/xfce4/backdrops/xubuntu-trusty.png http://www.xubecol.ovh/media/fond_$SESSION.jpg
echo "# Raccourci vers le serveur"
wget -N -P $HOME/Bureau http://www.xubecol.ovh/media/Stockage.desktop
sudo chmod ugo+x $HOME/Bureau/Stockage.desktop
echo "# Raccourci vers la documentation"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/Kit de survie XubEcol.desktop"
sudo chmod ugo+x "$HOME/Bureau/Kit de survie XubEcol.desktop"
echo "# Raccourci LibreOffice"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/LibreOffice.desktop"
sudo chmod ugo+x $HOME/Bureau/LibreOffice.desktop
echo "# Raccourci Firefox"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/Navigateur Web Firefox.desktop"
sudo chmod ugo+x "$HOME/Bureau/Navigateur Web Firefox.desktop"
echo "# Raccourci Gcompris"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/gcompris.desktop"
sudo chmod ugo+x "$HOME/Bureau/gcompris.desktop"
echo "# Raccourci TuxPaint"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/tuxpaint.desktop"
sudo chmod ugo+x "$HOME/Bureau/tuxpaint.desktop"
echo "# Raccourci TuxType"
wget -N -P $HOME/Bureau "http://www.xubecol.ovh/media/tuxtype.desktop"
sudo chmod ugo+x "$HOME/Bureau/tuxtype.desktop"
echo "# Script Post-Installation adresse IP"
wget -N -P $HOME/XubEcol/PostInstallation http://www.xubecol.ovh/media/Modifier_adresse_IP.sh
sudo chmod ugo+x $HOME/XubEcol/PostInstallation/Modifier_adresse_IP.sh
echo "# Script Post-Installation nom ordi et domaine"
wget -N -P $HOME/XubEcol/PostInstallation http://www.xubecol.ovh/media/Modifier_nom_ordi_et_domaine.sh
sudo chmod ugo+x $HOME/XubEcol/PostInstallation/Modifier_nom_ordi_et_domaine.sh
echo "# Script Post-Installation 1000mots"
wget -N -P $HOME/XubEcol/PostInstallation http://www.xubecol.ovh/media/Installation_1000_Mots/inst-mm.sh
sudo chmod ugo+x $HOME/XubEcol/PostInstallation/inst-mm.sh
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
sudo wget -N -P /etc/apt/apt.conf.d/ http://www.xubecol.ovh/media/config/10periodic
echo "# Suppression du compte invité"
sudo chmod 777 /usr/share/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
sudo echo -e "\nallow-guest=false" >> /usr/share/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
sudo chmod 755 /usr/share/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
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
  sudo ~/XubEcol/PostInstallation/Modifier_adresse_IP.sh
 fi
 
# Paramétrage Nom ordi et nom domaine 
echo "# Nom de l'ordinateur et nom du réseau"
sudo ~/XubEcol/PostInstallation/Modifier_nom_ordi_et_domaine.sh

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
   sudo chmod ugo+x $HOME/XubEcol/PostInstallation/Installation_Serveur_documents.sh
   sudo ~/XubEcol/PostInstallation/Installation_Serveur_documents.sh
  fi 
 fi
 
# Mises à jour... 
echo "# Mises à jour..."
if zenity --question --no-wrap --text "Souhaitez-vous vérifier les mises à jour ?" --title XubEcol 
 then
   sudo update-manager
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
  sudo reboot
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

