#
# Copyright (C) 2020 The Evolution X Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/samsung/m51
# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)


# Installs gsi keys into ramdisk, to boot a GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Inherit vendor
#$(call inherit-product, vendor/samsung/m51/m51-vendor.mk)

# Define Dynamic Partition support
PRODUCT_TARGET_VNDK_VERSION := 29
PRODUCT_SHIPPING_API_LEVEL := 29
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false
PRODUCT_EXTRA_VNDK_VERSIONS := 29

# A/B
AB_OTA_UPDATER := false


PRODUCT_AAPT_CONFIG := xxxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Camera
PRODUCT_PACKAGES += \
    Snap

# Fingerprint
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.fingerprint.xml


# fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0_system \
    android.hidl.manager@1.0_system

  
# Init
#PRODUCT_PACKAGES += \
#	fstab.qcom \
#	recovery.fstab \
#	init.recovery.qcom.rc 

#	init.m51.rc \
#	init.m51nsxx.rc \
#	init.msm.usb.configfs.rc \
#	init.qcom.factory.rc \
#	init.qcom.rc \
#	init.qcom.usb.rc \
#	init.samsung.bsp.rc \
#	init.samsung.rc \
#	init.target.rc \

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom

# Keylayouts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/idc/uinput-fpc.idc:$(TARGET_COPY_OUT_SYSTEM)/usr/idc/uinput-fpc.idc \
    $(LOCAL_PATH)/configs/idc/uinput-goodix.idc:$(TARGET_COPY_OUT_SYSTEM)/usr/idc/uinput-goodix.idc \
    $(DEVICE_PATH)/configs/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/gpio-keys.kl 

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlay

# Sensor
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# Trustonic TEE
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/public.libraries-trustonic.txt:$(TARGET_COPY_OUT_SYSTEM)/etc/public.libraries-trustonic.txt

# Properties
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

# Open GAPPs
#GAPPS_VARIANT  := nano
#$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)

# Offline charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images

# Keymaster
#PRODUCT_PACKAGES += \
#    android.hardware.keymaster@4.0 \
#    android.hardware.keymaster@4.0-service \
#    android.hardware.keymaster@4.0-impl \
#    libkeymaster4device
