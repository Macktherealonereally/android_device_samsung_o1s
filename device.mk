#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from universal2100
$(call inherit-product, device/samsung/universal2100-common/common.mk)

# Inherit from the proprietary version
$(call inherit-product, vendor/samsung/o1s/o1s-vendor.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_board_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_board_info.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml

# Camera - ID=52 is telephoto
$(call soong_config_set,samsungCameraVars,extra_ids,52)

# Display
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/display/displayconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_4633128672291735937.xml

# eSIM - the G991B eUICC shares the SIM2 slot with the second nano-SIM
# (SEC_FLOATING_FEATURE_COMMON_CONFIG_EMBEDDED_SIM_SLOTSWITCH=tsds2).
# OpenEUICC is the privileged LPA (EuiccService); stock declares the same
# feature for its com.samsung.euicc LPA. Only enabled when OpenEUICC is
# synced (volte.xml), because the feature without an LPA breaks the
# Settings/SetupWizard eSIM flows.
ifneq ($(wildcard packages/apps/OpenEUICC/Android.bp),)
PRODUCT_PACKAGES += \
    android.hardware.telephony.euicc.prebuilt.xml \
    OpenEUICC
endif

# Fonts - optional One UI-like fonts (Inter, Manrope; OFL-1.1). Not applied
# by default: adds the fonts + android.theme.customization.font overlays, the
# user picks one via theme_customization_overlay_packages. No-op unless
# vendor/o1s-fonts is present.
$(call inherit-product-if-exists, vendor/o1s-fonts/fonts.mk)

# Apps for every variant (NG, MTG, AMTG): Aurora Store as a normal presigned
# app in /product/app, pinned by sha256 and signer. Outside the GApps gates on
# purpose. No-op unless vendor/mack-apps is present; with it, a missing or
# mismatching APK stops the build (vendor/mack-apps/fetch-blobs.sh).
$(call inherit-product-if-exists, vendor/mack-apps/mack-apps.mk)

# Recovery/vendor_boot firmware
PRODUCT_COPY_FILES += \
    vendor/samsung/o1s/proprietary/vendor/firmware/y792_o1.bin:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/firmware/y792_o1.bin \
    vendor/samsung/o1s/proprietary/vendor/firmware/y792_o1.bin:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/vendor/firmware/y792_o1.bin

# Sensors
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
