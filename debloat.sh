#!/bin/zsh

export BLD="\e[01m" RED="\e[01;31m" BLU="\e[01;34m" CYA="\e[01;36m" NRM="\e[00m"
export ADB_BIN='/home/obi/Development/sharedlib/sdk/platform-tools_r31.0.2-linux/platform-tools/adb'
export PM_DCMD='pm disable-user --user 0'
export PM_ECMD='pm enable'
export PM_UCMD='pm uninstall --user 0'

command -v ${ADB_BIN} >/dev/null 2>&1 || {
  echo -e "${BLD}${RED}I require adb but it's not installed. Aborting.${NRM}" >&2
  exit 1
}

init_shell() {
  ${ADB_BIN} kill-server
  ${ADB_BIN} start-server
  ${ADB_BIN} wait-for-device

  id=$(${ADB_BIN} shell getprop ro.build.id)

  echo -e "${BLD}${BLU}Device information${NRM}"
  echo -e "${BLD} ${id}${NRM}"
}

kill_shell() {
  ${ADB_BIN} kill-server
}

# Disable apps to allow restore.
disable_apks() {
  DISABLE=(
	  # none
  )

  echo -e "${BLD}${CYA}Disabling apps${NRM}"
  for APP in "${DISABLE[@]}"; do
    prepare_apk ${APP}

    result=$(${ADB_BIN} shell ${PM_DCMD} ${APP})
    echo -e "${BLD} ${APP}: ${BLU}${result}${NRM}"
  done
}

# Re-enable apks.
enable_apks() {
  ENABLE=(
	  # none
  )

  echo -e "${BLD}${CYA}Enabling apps${NRM}"
  for APP in "${ENABLE[@]}"; do
    prepare_apk ${APP}

    result=$(${ADB_BIN} shell ${PM_ECMD} ${APP})
    echo -e "${BLD} ${APP}: ${BLU}${result}${NRM}"
  done
}

# Uninstall apps that are safe* to remove.
uninstall_apks() {
  UNINSTALL=(
	  com.samsung.android.app.social
	  com.samsung.android.smartswitchassistant
	  com.samsung.android.smartface
	  com.samsung.android.contacts
	  com.samsung.android.app.contacts
	  com.samsung.android.app.aodservice
	  com.linkedin.android
		com.amazon.fv
		com.sec.android.inputmethod
		com.sec.android.inputmethod.beta
		com.amazon.kindle
		com.amazon.mp3
		com.amazon.mShop.android
		com.amazon.venezia
		
		com.android.backupconfirm
		com.android.bips
		com.android.chrome
		com.android.dreams.basic
		com.android.dreams.phototable
		com.android.dreams.phototable
		com.android.email
		com.android.exchange
		com.android.hotwordenrollment.okgoogle
		com.android.printspooler
		com.android.providers.partnerbookmarks
		com.android.providers.userdictionary
		com.android.sharedstoragebackup
		com.android.stk
		com.android.wallpaper.livepicker
		com.android.wallpapercropper
		
		com.audible.application
		
		com.blurb.checkout
		
		com.cequint.ecid
		
		com.cnn.mobile.android.phone.edgepanel
		
		com.diotek.sec.lookup.dictionary
		
		com.dsi.ant.plugins.antplus
		com.dsi.ant.sample.acquirechannels
		com.dsi.ant.server
		com.dsi.ant.service.socket
		
		com.enhance.gameservice
		
		com.facebook.appmanager
		com.facebook.katana
		com.facebook.services
		com.facebook.system
		
		com.google.android.apps.books
		com.google.android.apps.docs
		com.google.android.apps.magazines
		com.google.android.apps.maps
		com.google.android.apps.plus
		com.google.android.apps.tachyon
		com.google.android.gm
		com.google.android.googlequicksearchbox
		com.google.android.printservice.recommendation
		com.google.android.talk
		com.google.android.tts
		com.google.android.videos
		com.google.android.youtube
		com.google.ar.core
		com.google.vr.vrcore
		
		com.gotv.nflgamecenter.us.lite
		
		com.hancom.office.editor.hidden
		com.hancom.office.editor.hidden
		
		com.imdb.mobile
		
		com.infraware.polarisoffice5
		
		com.microsoft.appmanager
		com.microsoft.office.excel
		com.microsoft.office.powerpoint
		com.microsoft.office.word
		com.microsoft.skydrive
		
		com.mobeam.barcodeService
		
		com.monotype.android.font.chococooky
		com.monotype.android.font.cooljazz
		com.monotype.android.font.foundation
		com.monotype.android.font.rosemary
		
		com.nuance.swype.input
		
		com.osp.app.signin
		
		com.policydm
		
		com.samsung.aasaservice
		com.samsung.advp.imssettings
		com.samsung.android.aircommandmanager
		com.samsung.android.allshare.service.fileshare
		com.samsung.android.allshare.service.mediashare
		com.samsung.android.app.advsounddetector
		com.samsung.android.app.appsedge
		com.samsung.android.app.assistantmenu
		com.samsung.android.app.camera.sticker.facear.preload
		com.samsung.android.app.camera.sticker.facear3d.preload
		com.samsung.android.app.camera.sticker.facearavatar.preload
		com.samsung.android.app.camera.sticker.facearframe.preload
		com.samsung.android.app.camera.sticker.stamp.preload
		com.samsung.android.app.clipboardedge
		com.samsung.android.app.cocktailbarservice
		com.samsung.android.app.episodes
		com.samsung.android.app.filterinstaller
		com.samsung.android.app.galaxyfinder
		com.samsung.android.app.ledbackcover
		com.samsung.android.app.ledcoverdream
		com.samsung.android.app.memo
		com.samsung.android.app.mirrorlink
		com.samsung.android.app.notes
		com.samsung.android.app.reminder
		com.samsung.android.app.routines
		com.samsung.android.app.sbrowseredge
		com.samsung.android.app.settings.bixby
		com.samsung.android.app.sharelive
		com.samsung.android.app.simplesharing
		com.samsung.android.app.smartcapture
		com.samsung.android.app.soundpicker
		com.samsung.android.app.spage
		com.samsung.android.app.storyalbumwidget
		com.samsung.android.app.talkback
		com.samsung.android.app.taskedge
		com.samsung.android.app.tips
		com.samsung.android.app.vrsetupwizardstub
		com.samsung.android.app.watchmanager
		com.samsung.android.app.watchmanagerstub
		com.samsung.android.app.withtv
		com.samsung.android.ardrawing
		com.samsung.android.aremoji
		com.samsung.android.arzone
		com.samsung.android.authfw
		com.samsung.android.aware.service
		com.samsung.android.bbc.bbcagent
		com.samsung.android.beaconmanager
		com.samsung.android.bixby.agent
		com.samsung.android.bixby.agent.dummy
		com.samsung.android.bixby.es.globalaction
		com.samsung.android.bixby.plmsync
		com.samsung.android.bixby.service
		com.samsung.android.bixby.voiceinput
		com.samsung.android.bixby.wakeup
		com.samsung.android.bixbyvision.framework
		com.samsung.android.calendar
		com.samsung.android.da.daagent
		com.samsung.android.dlp.service
		com.samsung.android.drivelink.stub
		com.samsung.android.easysetup
		com.samsung.android.email.provider
		com.samsung.android.fmm
		com.samsung.android.game.gamehome
		com.samsung.android.game.gametools
		com.samsung.android.game.gos
		com.samsung.android.gametuner.thin
		com.samsung.android.hmt.vrshell
		com.samsung.android.hmt.vrsvc
		com.samsung.android.keyguardwallpaperupdator
		com.samsung.android.kidsinstaller
		com.samsung.android.knox.analytics.uploader
		com.samsung.android.lool
		com.samsung.android.mateagent
		com.samsung.android.mdm
		com.samsung.android.mdx
		com.samsung.android.mdx.kit
		com.samsung.android.mdx.quickboard
		com.samsung.android.messaging
		com.samsung.android.mobileservice
		com.samsung.android.oneconnect
		com.samsung.android.samsungpass
		com.samsung.android.samsungpassautofill
		com.samsung.android.scloud
		com.samsung.android.sdk.professionalaudio.utility.jammonitor
		com.samsung.android.server.iris
		com.samsung.android.service.livedrawing
		com.samsung.android.service.peoplestripe
		com.samsung.android.service.travel
		com.samsung.android.setting.multisound
		com.samsung.android.spay
		com.samsung.android.spayfw
		com.samsung.android.spdfnote
		com.samsung.android.stickercenter
		com.samsung.android.stickerplugin
		com.samsung.android.svoice
		com.samsung.android.svoiceime
		com.samsung.android.themecenter
		com.samsung.android.themestore
		com.samsung.android.tripwidget
		com.samsung.android.visionarapps
		com.samsung.android.visioncloudagent
		com.samsung.android.visionintelligence
		com.samsung.android.voicewakeup
		com.samsung.android.wellbeing
		com.samsung.android.widgetapp.yahooedge.finance
		com.samsung.android.widgetapp.yahooedge.sport
		com.samsung.app.highlightplayer
		com.samsung.daydream.customization
		com.samsung.dcmservice
		com.samsung.desktopsystemui
		com.samsung.enhanceservice
		com.samsung.faceservice
		com.samsung.fresco.logging
		com.samsung.groupcast
		com.samsung.hs20provider
		com.samsung.ipservice
		com.samsung.knox.appsupdateagent
		com.samsung.knox.rcp.components
		com.samsung.knox.securefolder
		com.samsung.knox.securefolder.setuppage
		com.samsung.safetyinformation
		com.samsung.sec.android.application.csc
		com.samsung.SMT
		com.samsung.storyservice
		com.samsung.svoice.sync
		com.samsung.systemui.bixby
		com.samsung.systemui.bixby2
		com.samsung.ucs.agent.ese
		com.samsung.voiceserviceplatform
		
		com.sec.android.app.apex
		com.sec.android.app.applinker
		com.sec.android.app.billing
		com.sec.android.app.bluetoothtest
		com.sec.android.app.chromecustomizations
		com.sec.android.app.clockpackage
		com.sec.android.app.DataCreate
		com.sec.android.app.desktoplauncher
		com.sec.android.app.dexonpc
		com.sec.android.app.factorykeystring
		com.sec.android.app.gamehub
		com.sec.android.app.hwmoduletest
		com.sec.android.app.magnifier
		com.sec.android.app.myfiles
		com.sec.android.app.ocr
		com.sec.android.app.parser
		com.sec.android.app.personalization
		com.sec.android.app.popupcalculator
		com.sec.android.app.quicktool
		com.sec.android.app.ringtoneBR
		com.sec.android.app.safetyassurance
		com.sec.android.app.samsungapps
		com.sec.android.app.sbrowser
		com.sec.android.app.SecSetupWizard
		com.sec.android.app.servicemodeapp
		com.sec.android.app.shealth
		com.sec.android.app.SmartClipEdgeService
		com.sec.android.app.soundalive
		com.sec.android.app.sysscope
		com.sec.android.app.tfunlock
		com.sec.android.app.tourviewer
		com.sec.android.app.translator
		com.sec.android.app.ve.vebgm
		com.sec.android.app.wfdbroker
		com.sec.android.app.withtv
		com.sec.android.app.wlantest
		com.sec.android.AutoPreconfig
		com.sec.android.cover.ledcover
		com.sec.android.daemonapp
		com.sec.android.desktopmode.uiservice
		com.sec.android.diagmonagent
		com.sec.android.easyMover
		com.sec.android.easyMover.Agent
		com.sec.android.easyonehand
		com.sec.android.emergencylauncher
		com.sec.android.mimage.avatarstickers
		com.sec.android.mimage.gear360editor
		com.sec.android.mimage.photoretouching
		com.sec.android.ofviewer
		com.sec.android.omc
		com.sec.android.Preconfig
		com.sec.android.preloadinstaller
		com.sec.android.provider.snote
		com.sec.android.providers.security
		com.sec.android.providers.tasks
		com.sec.android.RilServiceModeApp
		com.sec.android.sdhms
		com.sec.android.service.health
		com.sec.android.sidesync30
		com.sec.android.splitsound
		com.sec.android.uibcvirtualsoftkey
		com.sec.android.widgetapp.diotek.smemo
		com.sec.android.widgetapp.easymodecontactswidget
		com.sec.android.widgetapp.samsungapps
		com.sec.app.TransmitPowerService
		com.sec.automation
		com.sec.bcservice
		com.sec.downloadablekeystore
		com.sec.enterprise.knox.attestation
		com.sec.enterprise.knox.cloudmdm.smdms
		com.sec.enterprise.mdm.services.simpin
		com.sec.enterprise.mdm.vpn
		com.sec.epdgtestapp
		com.sec.everglades
		com.sec.everglades.update
		com.sec.factory
		com.sec.factory.camera
		com.sec.factory.iris.usercamera
		com.sec.hearingadjust
		com.sec.ims
		com.sec.imslogger
		com.sec.imsservice
		com.sec.kidsplat.installer
		com.sec.knox.foldercontainer
		com.sec.knox.knoxsetupwizardclient
		com.sec.knox.switcher
		com.sec.location.nsflp2
		com.sec.mldapchecker
		com.sec.modem.settings
		com.sec.providers.assisteddialing
		com.sec.readershub
		com.sec.smartcard.manager
		com.sec.spen.flashannotate
		com.sec.spp.push
		com.sec.sve
		com.sec.usbsettings
		com.sec.vowifispg
		com.sec.yosemite.phone
		com.sem.factoryapp
		
		com.singtel.mysingtel
		
		com.skms.android.agent
		
		com.skype.raider
		
		com.test.LTEfunctionality
		
		com.tripadvisor.tripadvisor
		
		com.trustonic.tuiservice
		
		com.vlingo.midas
		
		com.wsomacp
		
		com.wssnps
		
		com.yelp.android.samsungedge
		
		comflipboard.app
		comflipboard.boxer.app
		
		comtv.peel.samsung.app
		com.samsung.android.bixby.agent                        
		com.samsung.android.bixby.es.globalaction
		com.samsung.android.bixbyvision.framework
		com.samsung.android.bixby.wakeup
		com.samsung.android.bixby.plmsync
		com.samsung.android.bixby.plmsync
		com.samsung.android.bixby.plmsync
		com.samsung.android.bixby.voiceinput
		com.samsung.systemui.bixby
		com.samsung.android.bixby.agent.dummy
		com.samsung.android.app.settings.bixby
		com.samsung.systemui.bixby2
		com.samsung.android.bixby.service
		com.samsung.android.app.routines
		com.samsung.android.visionintelligence
		com.samsung.android.app.spage
		com.samsung.android.arzone                             
		com.sec.android.app.samsungapps                          
		com.microsoft
		com.microsoft.appmanager                               
		com.microsoft.office.excel                               
		com.microsoft.office.powerpoint                          
		com.facebook.system                                      
		com.facebook.appmanager                                  
		com.samsung.android.messaging                            
		com.google.android.youtube                               
		com.dsi.ant.plugins.antplus                              
		com.google.android.apps.turbo                            
		com.samsung.android.app.appsedge                         
		com.samsung.android.kidsinstaller                         
		com.samsung.android.samsungpassautofill
		com.samsung.android.samsungpass

  )

  echo -e "${BLD}${BLU}Uninstalling apps${NRM}"
  for APP in "${UNINSTALL[@]}"; do
    prepare_apk ${APP}

    result=$(${ADB_BIN} shell ${PM_UCMD} ${APP})
    echo -e "${BLD} ${APP}: ${CYA}${result}${NRM}"
  done
}

prepare_apk() {
  # Force stop everything associated with package
  kill=$(${ADB_BIN} shell am force-stop ${1})

  # Deletes all data associated with a package
  clean=$(${ADB_BIN} shell pm clear ${1})
}

init_shell
disable_apks
enable_apks
uninstall_apks
kill_shell
