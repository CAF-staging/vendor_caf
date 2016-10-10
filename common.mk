PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

PRODUCT_COPY_FILES += \
    vendor/caf/prebuilt/bin/sysinit:system/bin/sysinit \
    vendor/caf/prebuilt/etc/init.caf.rc:root/init.caf.rc

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/caf/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/caf/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/caf/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/caf/prebuilt/common/bin/whitelist:system/addon.d/whitelist \
    
# init.d support
PRODUCT_COPY_FILES += \
    vendor/caf/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/caf/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/caf/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# SuperSu
PRODUCT_COPY_FILES += \
 vendor/caf/prebuilt/common/etc/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip

# Init file
PRODUCT_COPY_FILES += \
    vendor/caf/prebuilt/common/etc/init.local.rc:root/init.local.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/caf/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/caf/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Misc packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    libemoji \
    libsepol \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    powertop \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    Terminal \
    nano

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Telephony packages
PRODUCT_PACKAGES += \
    messaging \
    CellBroadcastReceiver \
    Stk \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

#RCS //Needed for Contacts and Mms Apps
PRODUCT_PACKAGES += \
    rcs_service_aidl \
    rcs_service_aidl.xml \
    rcs_service_aidl_static \
    rcs_service_api \
    rcs_service_api.xml

# Mms depends on SoundRecorder for recorded audio messages
PRODUCT_PACKAGES += \
    SoundRecorder

# World APN list
PRODUCT_COPY_FILES += \
    vendor/caf/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# Selective SPN list for operator number who has the problem.
PRODUCT_COPY_FILES += \
    vendor/caf/prebuilt/common/etc/selective-spn-conf.xml:system/etc/selective-spn-conf.xml

# Overlays & Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += \
	vendor/caf/overlay/common \
	vendor/caf/overlay/dictionaries

# Proprietary latinime libs needed for Keyboard swyping
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES += \
    vendor/caf/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so
else
PRODUCT_COPY_FILES += \
    vendor/caf/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

$(call inherit-product-if-exists, vendor/extra/product.mk)

# Versioning System
# CAF first version.
PRODUCT_VERSION_MAJOR = N
PRODUCT_VERSION_MINOR = 1.0
ifdef CAF_BUILD_EXTRA
    CAF_POSTFIX := -$(CAF_BUILD_EXTRA)
endif
ifndef CAF_BUILD_TYPE
ifeq ($(CAF_RELEASE),true)
    CAF_BUILD_TYPE := OFFICIAL
    PLATFORM_VERSION_CODENAME := OFFICIAL
    CAF_POSTFIX := -$(shell date +"%Y%m%d")
else
    CAF_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
    CAF_POSTFIX := -$(shell date +"%Y%m%d")
endif
endif

ifeq ($(CAF_BUILD_TYPE),DM)
    CAF_POSTFIX := -$(shell date +"%Y%m%d")
endif

ifndef CAF_POSTFIX
    CAF_POSTFIX := -$(shell date +"%Y%m%d")
endif

PLATFORM_VERSION_CODENAME := $(CAF_BUILD_TYPE)

# Flavour
PRODUCT_VERSION_FLAVOUR := BareBase
PRODUCT_PROPERTY_OVERRIDES += \
    ro.caf.flavour=$(PRODUCT_VERSION_FLAVOUR)

# Set all versions
CAF_VERSION := CAF-$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_FLAVOUR)-$(PRODUCT_VERSION_MAJOR)-$(CAF_BUILD_TYPE)$(CAF_POSTFIX)
CAF_MOD_VERSION := CAF-$(CAF_BUILD)-$(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_FLAVOUR)-$(CAF_BUILD_TYPE)$(CAF_POSTFIX)
PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    caf.ota.version=$(CAF_MOD_VERSION) \
    ro.caf.version=$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_FLAVOUR) \
    ro.modversion=$(CAF_MOD_VERSION) \
    ro.caf.buildtype=$(CAF_BUILD_TYPE)

# Caf Bloats
PRODUCT_PACKAGES += \
MusicFX \
SnapdragonCamera \
SnapdragonGallery \
SnapdragonMusic \
Launcher3 \
LatinIME
