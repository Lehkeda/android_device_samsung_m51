/*
 * Copyright (C) 2019 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "FingerprintInscreenService"

#include "FingerprintInscreen.h"
#include <android-base/logging.h>
#include <hidl/HidlTransportSupport.h>
#include <fstream>
#include <cmath>
#include <thread>

#define FINGERPRINT_ACQUIRED_VENDOR 6

#define BRIGHTNESS_PATH "/sys/class/backlight/panel0-backlight/brightness"
#define TSP_CMD_PATH "/sys/class/sec/tsp/cmd"
#define FP_GREEN_CIRCLE "/sys/class/lcd/panel/fp_green_circle"
#define MASK_BRIGHTNESS_PATH "/sys/class/lcd/panel/mask_brightness"
#define FOD_DIMMING_PATH "/sys/class/lcd/panel/fod_dimming"

#define SEM_FINGER_STATE 22
#define SEM_PARAM_PRESSED 2
#define SEM_PARAM_RELEASED 1
#define SEM_AOSP_FQNAME "android.hardware.biometrics.fingerprint@2.1::IBiometricsFingerprint"

namespace vendor {
namespace lineage {
namespace biometrics {
namespace fingerprint {
namespace inscreen {
namespace V1_0 {
namespace implementation {

/*
 * Write value to path and close file.
 */
template <typename T>
static void set(const std::string& path, const T& value) {
    std::ofstream file(path);
    file << value;
}

template <typename T>
static T get(const std::string& path, const T& def) {
    std::ifstream file(path);
    T result;

    file >> result;
    return file.fail() ? def : result;
}

static hidl_vec<int8_t> stringToVec(const std::string& str) {
    auto vec = hidl_vec<int8_t>();
    vec.resize(str.size() + 1);
    for (size_t i = 0; i < str.size(); ++i) {
        vec[i] = (int8_t) str[i];
    }
    vec[str.size()] = '\0';
    return vec;
}

FingerprintInscreen::FingerprintInscreen() {
    mSehBiometricsFingerprintService = ISehBiometricsFingerprint::getService();
    set(TSP_CMD_PATH, "set_fod_rect,426,1989,654,2217");
    set(MASK_BRIGHTNESS_PATH, "319");
}

void FingerprintInscreen::requestResult(int, const hidl_vec<int8_t>&) {
    // Ignore all results
}

Return<void> FingerprintInscreen::onStartEnroll() {
    return Void();
}

Return<void> FingerprintInscreen::onFinishEnroll() {
    return Void();
}

Return<void> FingerprintInscreen::onPress() {
    set(FP_GREEN_CIRCLE, "1");
    std::thread([this]() {
        std::this_thread::sleep_for(std::chrono::milliseconds(38));
        mSehBiometricsFingerprintService->sehRequest(SEM_FINGER_STATE, 
            SEM_PARAM_PRESSED, stringToVec(SEM_AOSP_FQNAME), FingerprintInscreen::requestResult);
    }).detach();
    return Void();
}

Return<void> FingerprintInscreen::onRelease() {
    mSehBiometricsFingerprintService->sehRequest(SEM_FINGER_STATE, 
        SEM_PARAM_RELEASED, stringToVec(SEM_AOSP_FQNAME), FingerprintInscreen::requestResult);
    set(FP_GREEN_CIRCLE, "0");
    return Void();
}

Return<void> FingerprintInscreen::onShowFODView() {
    std::thread([]() {
        std::this_thread::sleep_for(std::chrono::milliseconds(15));
        set(FOD_DIMMING_PATH, "1");
    }).detach();
    set(TSP_CMD_PATH, "fod_enable,1,1,0");
    return Void();
}

Return<void> FingerprintInscreen::onHideFODView() {
    set(TSP_CMD_PATH, "fod_enable,0");
    set(FP_GREEN_CIRCLE, "0");
    set(FOD_DIMMING_PATH, "0");
    return Void();
}

Return<bool> FingerprintInscreen::handleAcquired(int32_t acquiredInfo, int32_t vendorCode) {
    std::lock_guard<std::mutex> _lock(mCallbackLock);
    if (mCallback == nullptr) {
        return false;
    }

    if (acquiredInfo == FINGERPRINT_ACQUIRED_VENDOR) {
        if (vendorCode == 10002) {
            Return<void> ret = mCallback->onFingerDown();
            if (!ret.isOk()) {
                LOG(ERROR) << "FingerDown() error: " << ret.description();
            }
            return true;
        } else if (vendorCode == 10001) {
            Return<void> ret = mCallback->onFingerUp();
            if (!ret.isOk()) {
                LOG(ERROR) << "FingerUp() error: " << ret.description();
            }
            return true;
        }
    }
    LOG(ERROR) << "acquiredInfo: " << acquiredInfo << ", vendorCode: " << vendorCode << "\n";
    return false;
}

Return<bool> FingerprintInscreen::handleError(int32_t, int32_t) {
    return false;
}

Return<void> FingerprintInscreen::setLongPressEnabled(bool) {
    return Void();
}

Return<int32_t> FingerprintInscreen::getDimAmount(int32_t /* cur_brightness */) {
    return 0;
}

Return<bool> FingerprintInscreen::shouldBoostBrightness() {
    return false;
}

Return<void> FingerprintInscreen::setCallback(const sp<IFingerprintInscreenCallback>& callback) {
    {
        std::lock_guard<std::mutex> _lock(mCallbackLock);
        mCallback = callback;
    }
    return Void();
}

Return<int32_t> FingerprintInscreen::getPositionX() {
    return 447;
}

Return<int32_t> FingerprintInscreen::getPositionY() {
    return 2009;
}

Return<int32_t> FingerprintInscreen::getSize() {
    return 185;
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace inscreen
}  // namespace fingerprint
}  // namespace biometrics
}  // namespace lineage
}  // namespace vendor
