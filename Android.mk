
LOCAL_PATH:= $(call my-dir)

common_SRC_FILES:=  $(call all-c-files-under, src)

# headers library
# =====================================================

include $(CLEAR_VARS)
LOCAL_MODULE := liblzo-headers
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)
LOCAL_MODULE_CLASS := HEADER_LIBRARIES

intermediates := $(call local-generated-sources-dir)

LZO_CONFIG_OPTS := --disable-asm
LZO_CONFIG_STATUS := $(intermediates)/config.status
$(LZO_CONFIG_STATUS): $(LOCAL_PATH)/configure
	@rm -rf $(@D); mkdir -p $(@D)
	export PATH=/usr/bin:/bin:$$PATH; \
	for f in $(<D)/*; do if [ -d $$f ]; then \
		mkdir -p $(@D)/`basename $$f`; ln -sf `realpath --relative-to=$(@D)/d $$f/*` $(@D)/`basename $$f`; \
	else \
		ln -sf `realpath --relative-to=$(@D) $$f` $(@D); \
	fi; done;
	export PATH=/usr/bin:/bin:$$PATH; \
	cd $(@D); ./$(<F) $(LZO_CONFIG_OPTS) && \
	./$(<F) $(LZO_CONFIG_OPTS) --prefix=/system || \
		(rm -rf $(@F); exit 1)

LOCAL_GENERATED_SOURCES := $(LZO_CONFIG_STATUS)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(intermediates) $(intermediates)/include
include $(BUILD_HEADER_LIBRARY)


# static library
# =====================================================

include $(CLEAR_VARS)
LOCAL_SRC_FILES:= $(common_SRC_FILES)
LOCAL_C_INCLUDES:= $(common_C_INCLUDES)
LOCAL_MODULE := liblzo-static
LOCAL_PRELINK_MODULE:= false
LOCAL_HEADER_LIBRARIES := liblzo-headers
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

# dynamic library
# =====================================================

include $(CLEAR_VARS)
LOCAL_SRC_FILES:= $(common_SRC_FILES)
LOCAL_C_INCLUDES:= $(common_C_INCLUDES)
LOCAL_MODULE := liblzo
LOCAL_PRELINK_MODULE:= false
LOCAL_HEADER_LIBRARIES := liblzo-headers
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
