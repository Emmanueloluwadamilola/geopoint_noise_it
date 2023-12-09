import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/list_page.dart';
import 'package:futa_noise_app/search_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:futa_noise_app/settings_page.dart';

enum BottomIcon { home, search, list, setting }

class HomePage extends StatefulWidget {
  static const String id = 'home_screen';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentAddress;
  Position? currentPosition;
  BottomIcon selectedIcon = BottomIcon.home;

  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? noiseMeter;

  DateTime? startTime;
  DateTime? stopTime;
  String elapsedTime = "0 seconds";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void startTimeReading() {
    setState(() {
      startTime = DateTime.now();
      stopTime = null;
      elapsedTime = "0 seconds";
    });
    updateElapsedTime();
  }

  void stopTimeReading() {
    setState(() {
      stopTime = DateTime.now();
    });
  }

  void updateElapsedTime() {
    if (startTime != null && stopTime == null) {
      // ignore: unused_local_variable
      final currentTime = DateTime.now();
      final difference = currentTime.difference(startTime!);
      setState(() {
        elapsedTime = '${difference.inSeconds} seconds';
      });
      Future.delayed(const Duration(seconds: 1), updateElapsedTime);
    }
  }

  void onData(NoiseReading noiseReading) =>
      setState(() => _latestReading = noiseReading);

  void onError(Object error) {
    //print(error);
    stop();
  }

  /// Check if microphone permission is granted.
  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  /// Request the microphone permission.
  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  /// Start noise sampling.
  Future<void> start() async {
    // Create a noise meter, if not already done.
    noiseMeter ??= NoiseMeter();
    getCurrentPosition();
    startTimeReading();

    // Check permission to use the microphone.
    //
    // Remember to update the AndroidManifest file (Android) and the
    // Info.plist and pod files (iOS).
    if (!(await checkPermission())) await requestPermission();

    // Listen to the noise stream.
    _noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    setState(() => _isRecording = true);
  }

  /// Stop sampling.
  void stop() {
    _noiseSubscription?.cancel();
    stopTimeReading();
    setState(() => _isRecording = false);
    DateTime currentDate = DateTime.now();

    CollectionReference collRef =
        FirebaseFirestore.instance.collection('client');
    collRef.add({
      'sound-level': _latestReading?.meanDecibel.toStringAsFixed(3),
      'time': elapsedTime,
      'location_name': currentAddress,
      'date': '${currentDate.year}-${currentDate.month}-${currentDate.day}'
    });
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => currentPosition = position);
      getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0XFF1E319D),
          centerTitle: true,
          title: const Text(
            "Noise App",
            style: TextStyle(color: Colors.white),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lat: ${currentPosition?.latitude.toStringAsFixed(2) ?? "0.0"} ',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Lon: ${currentPosition?.longitude.toStringAsFixed(2) ?? "0.0"}",
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
            Text("Location: ${currentAddress ?? " "}"),
            Text(
              ' ${_latestReading?.meanDecibel.toStringAsFixed(3)} dB',
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Max: ${_latestReading?.maxDecibel.toStringAsFixed(3)} dB',
              style: const TextStyle(fontSize: 17),
            ),
            Text(
              "Time: $elapsedTime",
              style: const TextStyle(fontSize: 18),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(_isRecording ? "Mic: ON" : "Mic: OFF",
                  style:
                      const TextStyle(fontSize: 25, color: Color(0XFF1E319D))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0XFF1E319D),
        height: 70,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HomePage.id);
                    setState(() {
                      selectedIcon = BottomIcon.home;
                    });
                  },
                  icon: const Icon(Icons.home),
                  iconSize: 40,
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SearchPage.id);
                    setState(() {
                      selectedIcon = BottomIcon.search;
                    });
                  },
                  icon: const Icon(Icons.search),
                  iconSize: 40,
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ListPage.id);
                    setState(() {
                      selectedIcon = BottomIcon.list;
                    });
                  },
                  icon: const Icon(Icons.list),
                  iconSize: 40,
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SettingPage.id);
                    setState(() {
                      selectedIcon = BottomIcon.setting;
                    });
                  },
                  icon: const Icon(Icons.settings),
                  iconSize: 40,
                  color: Colors.white,
                ),
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        shape: const CircleBorder(),
        backgroundColor: _isRecording ? Colors.red : const Color(0XFF1E319D),
        onPressed: _isRecording ? stop : start,
        child: _isRecording
            ? const Icon(
                Icons.stop,
                color: Colors.black,
              )
            : const Icon(
                Icons.mic,
                color: Colors.white,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
