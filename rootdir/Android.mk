LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE       := fstab.qcom
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/$(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_RAMDISK_OUT)

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE       := init.recovery.qcom.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/$(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_ROOT_OUT)

include $(BUILD_PREBUILT)

include $(CLEAR_VARS)

LOCAL_MODULE       := init.qcom.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/$(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_ROOT_OUT)

include $(BUILD_PREBUILT)
