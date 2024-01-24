import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/constants.dart';
import 'package:futa_noise_app/widgets/bottom_app_bar.dart';
import 'package:futa_noise_app/widgets/home_content_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:futa_noise_app/screens/settings_page.dart';

enum BottomIcon { home, search, list, setting, map }

class Home extends StatefulWidget {
  static const String id = 'home_screen';
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  String? currentAddress;
  Position? currentPosition;
  BottomIcon selectedIcon = BottomIcon.home;

  bool isRecording = false;
  NoiseReading? latestReading;
  StreamSubscription<NoiseReading>? noiseSubscription;
  NoiseMeter? noiseMeter;

  DateTime? startTime;
  DateTime? stopTime;
  String elapsedTime = "0 seconds";

  @override
  void initState() {
    super.initState();
    handleLocationPermission();
    getCurrentPosition();
  }

  @override
  void dispose() {
    noiseSubscription?.cancel();
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
      setState(() => latestReading = noiseReading);

  void onError(Object error) {
    //print(error);
    stop();
  }

  /// Check if microphone permission is granted.
  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  /// Request the microphone permission.
  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  // Future<void> checkAndRequestPermission() async => if (!(await checkPermission())) await requestPermissio);

  /// Start noise sampling.
  Future<void> start() async {
    if (!(await checkPermission())) await requestPermission();
    // Create a noise meter, if not already done.
    noiseMeter ??= NoiseMeter();
    getCurrentPosition();
    startTimeReading();

    // Listen to the noise stream.
    noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    setState(() => isRecording = true);
  }

  /// Stop sampling.
  void stop() {
    noiseSubscription?.cancel();
    stopTimeReading();
    setState(() => isRecording = false);
    DateTime currentDate = DateTime.now();

    CollectionReference collRef =
        FirebaseFirestore.instance.collection('client');
    collRef.add({
      'sound_level': latestReading?.meanDecibel.toStringAsFixed(3),
      'duration': elapsedTime,
      'location_name': currentAddress,
      'date': '${currentDate.year}-${currentDate.month}-${currentDate.day}',
      'time': '${currentDate.hour}:${currentDate.minute}:${currentDate.second}',
      'longitude': currentPosition?.longitude.toStringAsFixed(10),
      'latitude': currentPosition?.latitude.toStringAsFixed(10),
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SettingPage.id);
                  setState(() {
                    selectedIcon = BottomIcon.setting;
                  });
                },
                icon: const Icon(Icons.settings),
                iconSize: 30,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: kPrimaryColour,
          centerTitle: true,
          title: const Text(
            "Noise App",
            style: TextStyle(color: Colors.white),
          )),
      body: HomePageContent(elapsedTime, currentAddress, currentPosition, latestReading, isRecording: isRecording, ),
      bottomNavigationBar: const BottomAppBarWidget(),
      floatingActionButton: FloatingActionButton.large(
        shape: const CircleBorder(),
        backgroundColor: isRecording ? Colors.red : kPrimaryColour,
        onPressed: isRecording ? stop : start,
        child: isRecording
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
