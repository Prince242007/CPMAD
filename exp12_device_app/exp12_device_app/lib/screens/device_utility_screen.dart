import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DeviceUtilityScreen extends StatefulWidget {
  const DeviceUtilityScreen({super.key});

  @override
  State<DeviceUtilityScreen> createState() => _DeviceUtilityScreenState();
}

class _DeviceUtilityScreenState extends State<DeviceUtilityScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? profilePhoto;

  StreamSubscription<AccelerometerEvent>? sensorSubscription;
  double x = 0, y = 0, z = 0;
  String shakeText = 'Shake your phone to test.';
  DateTime lastShake = DateTime.fromMillisecondsSinceEpoch(0);

  Position? currentPosition;
  String locationText = 'Location has not been requested.';
  bool loadingLocation = false;

  @override
  void initState() {
    super.initState();
    startSensor();
  }

  void startSensor() {
    sensorSubscription = accelerometerEventStream().listen((event) {
      final force = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      final difference = (force - 9.8).abs();

      if (difference > 3.5 &&
          DateTime.now().difference(lastShake).inMilliseconds > 1000) {
        lastShake = DateTime.now();
        shakeText = 'Shake detected!';
      } else if (DateTime.now().difference(lastShake).inSeconds > 2) {
        shakeText = 'Sensor active. No shake detected.';
      }

      if (!mounted) return;
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    }, onError: (_) {
      if (mounted) setState(() => shakeText = 'Sensor is not available.');
    });
  }

  Future<void> choosePhoto(ImageSource source) async {
    try {
      final image = await picker.pickImage(source: source, imageQuality: 80);
      if (image != null && mounted) setState(() => profilePhoto = image);
    } catch (_) {
      if (mounted) showMessage('Unable to open image source.');
    }
  }

  void showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take photo'),
            onTap: () {
              Navigator.pop(sheetContext);
              choosePhoto(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Choose from gallery'),
            onTap: () {
              Navigator.pop(sheetContext);
              choosePhoto(ImageSource.gallery);
            },
          ),
          if (profilePhoto != null)
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove photo'),
              onTap: () {
                Navigator.pop(sheetContext);
                setState(() => profilePhoto = null);
              },
            ),
        ]),
      ),
    );
  }

  Future<void> getLocation() async {
    setState(() {
      loadingLocation = true;
      locationText = 'Fetching location...';
    });

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() {
          locationText = 'GPS/location services are turned off.';
          loadingLocation = false;
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          locationText = permission == LocationPermission.deniedForever
              ? 'Location permission is permanently denied. Open app settings.'
              : 'Location permission denied.';
          loadingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        currentPosition = position;
        locationText = 'Location received successfully.';
        loadingLocation = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          locationText = 'Could not get location. Please try again.';
          loadingLocation = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget sensorBox(String label, double value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value.toStringAsFixed(2)),
            const Text('m/s²', style: TextStyle(fontSize: 12)),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    sensorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Utility App'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const Text('Profile Photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: profilePhoto == null ? null : FileImage(File(profilePhoto!.path)),
                  child: profilePhoto == null ? const Icon(Icons.person, size: 65) : null,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: showPhotoOptions,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Update Photo'),
                ),
              ]),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const Text('Accelerometer / Shake Detection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(children: [sensorBox('X', x), sensorBox('Y', y), sensorBox('Z', z)]),
                const SizedBox(height: 8),
                Text(shakeText, textAlign: TextAlign.center),
              ]),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('GPS Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(locationText),
                if (currentPosition != null) ...[
                  Text('Latitude: ${currentPosition!.latitude}'),
                  Text('Longitude: ${currentPosition!.longitude}'),
                  Text('Accuracy: ${currentPosition!.accuracy.toStringAsFixed(1)} m'),
                ],
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: loadingLocation ? null : getLocation,
                  icon: loadingLocation
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.location_searching),
                  label: Text(loadingLocation ? 'Getting location...' : 'Get Current Location'),
                ),
                if (locationText.contains('permanently'))
                  TextButton(onPressed: Geolocator.openAppSettings, child: const Text('Open App Settings')),
                if (locationText.contains('turned off'))
                  TextButton(onPressed: Geolocator.openLocationSettings, child: const Text('Open Location Settings')),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
