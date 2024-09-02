import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/constants.dart';
import 'package:futa_noise_app/widgets/home_content_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

enum BottomIcon { home, search, list, setting, map }

class Home extends StatefulWidget {
  static const String id = 'home_screen';
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isLoading = false;
  String? currentAddress;
  String? currentCity;
  String? currentState;
  Position? currentPosition;
  BottomIcon selectedIcon = BottomIcon.home;

  bool isRecording = false;
  NoiseReading? latestReading;
  StreamSubscription<NoiseReading>? noiseSubscription;
  NoiseMeter? noiseMeter;

  DateTime? startTime;
  DateTime? stopTime;
  String elapsedTime = "0 second";

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
      elapsedTime = "0 second";
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
    setState(() {
      isLoading = true;
    });
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => currentPosition = position);
      getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
    setState(() {
      isLoading = false;
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
        currentState = '${place.administrativeArea}';
        currentCity = '${place.locality}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: HomePageContent(
            isLoading: isLoading,
            currentCity: currentCity,
            currentState: currentState,
            isRecording: isRecording,
            elapsedTime: elapsedTime,
            latestReading: latestReading,
            currentPosition: currentPosition,
            currentAddress: currentAddress),
        // bottomNavigationBar: const BottomAppBarWidget(),
        floatingActionButton: GestureDetector(
          onTap: isRecording ? stop : start,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRecording ? Colors.red : kPrimaryColour,
            ),
            child: isRecording
                ? const Icon(
                    Icons.stop,
                    size: 40,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.mic,
                    size: 40,
                    color: Colors.white,
                  ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
