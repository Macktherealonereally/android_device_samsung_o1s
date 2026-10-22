#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from o1s device
$(call inherit-product, device/samsung/o1s/device.mk)

# Inherit from common lineage configuration
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Google apps (MindTheGapps), only when vendor/gapps is synced and not
# opted out with WITHOUT_GAPPS=true. TARGET_IS_GROUPER selects the minimal
# set (GmsCore, GSF, Play Store, sync adapters); it must be set before the
# inherit because arm64-vendor.mk tests it at parse time.
# Do not set WITH_GMS: it would drop the product reserved size.
ifneq ($(WITHOUT_GAPPS),true)
ifneq ($(wildcard vendor/gapps/arm64/arm64-vendor.mk),)
TARGET_IS_GROUPER := true
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)
# Privileged permissions that Play-updated GmsCore needs but MindTheGapps'
# allowlist lacks (see configs/permissions/privapp-permissions-gms-extra.xml).
PRODUCT_PACKAGES += privapp-permissions-gms-extra.xml
# The privileged permissions Pixel's allowlist grants to the other MTG-sourced
# Google apps, so their Play updates get them too
# (configs/permissions/privapp-permissions-google-pixel-extra*.xml).
PRODUCT_PACKAGES += \
    privapp-permissions-google-pixel-extra.xml \
    privapp-permissions-google-pixel-extra-system-ext.xml
# Circle to Search: MindTheGapps already declares the CONTEXTUAL_SEARCH
# feature and points config_defaultContextualSearchPackageName at the
# Google app, but the minimal set leaves the Google app out, so Launcher3
# swallows long-press home / nav handle without falling back. Ship it.
# Set WITHOUT_GOOGLE_APP=true to keep the minimal set.
ifneq ($(WITHOUT_GOOGLE_APP),true)
PRODUCT_PACKAGES += Velvet
endif
# AMTG ("Advanced MindTheGapps"): the set above plus MindTheGapps' extras
# and Pixel apps (Google Phone, Messages, Contacts, Gboard, Calendar, Clock,
# Photos, Android System Intelligence, Device Health Services) from
# vendor/amtg. Only with WITH_AMTG=true, so NG and MTG builds are unchanged.
ifeq ($(WITH_AMTG),true)
ifeq ($(wildcard vendor/amtg/amtg.mk),)
$(error WITH_AMTG=true needs vendor/amtg)
endif
$(call inherit-product, vendor/amtg/amtg.mk)
endif
endif
endif

PRODUCT_NAME := lineage_o1s
PRODUCT_DEVICE := o1s
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G991B
PRODUCT_MANUFACTURER := samsung

PRODUCT_GMS_CLIENTID_BASE := android-samsung

# Use the latest approved GMS identifiers
PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="o1sxxx-user 15 AP3A.240905.015.A2 G991BXXSJHZA6 release-keys" \
    BuildFingerprint=samsung/o1sxxx/o1s:11/RP1A.200720.012/G991BXXSJHZA6:user/release-keys \
    DeviceProduct=o1sxxx \
    SystemName=o1sxxx

# Define PDA property for camera
PRODUCT_SYSTEM_PROPERTIES += \
    ro.build.PDA=G991BXXSJHZA6
