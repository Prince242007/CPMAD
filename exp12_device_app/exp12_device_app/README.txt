EXPERIMENT 12 — DEVICE INTEGRATION

Included:
- Camera photo capture and gallery selection
- Profile image preview, update and removal
- Live accelerometer X, Y and Z readings
- Shake detection message
- Current GPS location and accuracy
- Runtime location permission request and denied-permission messages

HOW TO USE:
1. Extract this ZIP.
2. Copy the lib folder and pubspec.yaml into a Flutter project (or use them in this project).
3. Run: flutter pub get
4. Run on a real Android phone for camera, sensor and GPS testing.

ANDROID PERMISSIONS:
Open android/app/src/main/AndroidManifest.xml and add these lines
inside the <manifest> element, before <application>:

<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

The app requests location permission at runtime. Camera/gallery permission behavior
is handled by image_picker and the Android image/camera picker flow.

IOS (if running on iPhone):
Add NSCameraUsageDescription and NSPhotoLibraryUsageDescription to
ios/Runner/Info.plist, with user-facing descriptions. For location, add
NSLocationWhenInUseUsageDescription.

NOTES:
- Sensors are tested on a physical phone; emulator sensor readings may not behave
  like a real device.
- Location requires GPS/location services to be enabled.
- The photo is displayed from the picked file path. It is not uploaded.
