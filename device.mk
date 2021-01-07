#
# Copyright (C) 2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/samsung/m51

#$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Call the proprietary setup
#$(call inherit-product, vendor/samsung/m51/m51-vendor.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

PRODUCT_TARGET_VNDK_VERSION := 29
PRODUCT_SHIPPING_API_LEVEL := 29
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Overlays
PRODUCT_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlay \
    $(DEVICE_PATH)/overlay-lineage

PRODUCT_ENFORCE_RRO_TARGETS += *

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    $(DEVICE_PATH)/overlay-lineage/lineage-sdk \
    $(DEVICE_PATH)/overlay-lineage/packages/apps/Snap

# No A/B
AB_OTA_UPDATER := false

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.bluetooth.default \
    audio.usb.default \
    audio.r_submix.default \
    android.hardware.audio@5.0-impl:32 \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@5.0-impl:32 \
    android.hardware.audio.effect@2.0-service \
    android.hardware.bluetooth.audio@2.0-impl:32 \
    libtinycompress

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/audio/mixer_paths_tavil.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/mixer_paths_tavil.xml \
    $(DEVICE_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/audio_effects.xml \
    $(DEVICE_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/a2dp_in_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/usb_audio_policy_configuration.xml

# Camera
PRODUCT_PACKAGES += \
    Snap

# Fingerprint feature
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.fingerprint.xml

# Face unlock feature
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
# Init
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.qcom.rc

# LiveDisplay
PRODUCT_PACKAGES += \
    lineage.livedisplay@2.0-service.samsung-qcom

# Keylayout
PRODUCT_COPY_FILES += \
    device/samsung/m51/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/gpio-keys.kl

# NFC
PRODUCT_PACKAGES += \
    libnfc-nci \
    libnfc_nci_jni \
    NfcNci \
    Tag \
    com.android.nfc_extras

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/libnfc-nci.conf:system/etc/libnfc-nci.conf

# Power
# Disable building power HAL for now as it causing the device to stuck on bootanimation
# due to linker can't link libperWfmgr.so
#PRODUCT_PACKAGES += \
#    android.hardware.power@1.3-service.m51

#PRODUCT_COPY_FILES += \
#    $(DEVICE_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PLATFORM_VNDK_VERSION)/etc/powerhint.json \
#    $(DEVICE_PATH)/configs/powerhint.xml:$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PLATFORM_VNDK_VERSION)/etc/powerhint.xml

# Recovery
PRODUCT_PACKAGES += \
    fastbootd \
    init.recovery.qcom.rc

# SamsungDoze
PRODUCT_PACKAGES += \
    SamsungDoze

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl.samsung-m51

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# Trust HAL
PRODUCT_PACKAGES += \
    lineage.trust@1.0-service

# GSI AVB Public Keys
PRODUCT_PACKAGES += \
    q-gsi.avbpubkey \
    r-gsi.avbpubkey \
    s-gsi.avbpubkey

# Skip Mount
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/skip_mount.cfg:system/etc/init/config/skip_mount.cfg

# FM
PRODUCT_PACKAGES += \
    FMRadio \
    libfmjni

# Offline Charger
PRODUCT_PACKAGES += \
    charger \
    charger_res_images \
    lineage_charger_res_images
