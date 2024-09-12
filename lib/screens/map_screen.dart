import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futa_noise_app/constants.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:latlong2/latlong.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  static const String id = 'noise_noise_screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker>? markerData;
  double? realLatitude;
  double? realLongitude;
  bool isLoading = false;
  List<Map<String, dynamic>> results = [];

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
      setState(() {
        realLatitude = position.latitude;
        realLongitude = position.longitude;
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e);
    });
  }

  List<Map<String, dynamic>> calculateAverageSoundLevel(
      List<Map<String, dynamic>> soundData) {
    Map<String, List<double>> soundLevelByLocation = {};
    Map<String, LatLng> locationCoordinates = {};

    // Group the sound levels by location_name
    for (var item in soundData) {
      String locationName = item['location_name'];
      double soundLevel = double.parse(item['sound_level']);
      double latitude = double.parse(item['latitude']);
      double longitude = double.parse(item['longitude']);

      if (soundLevelByLocation.containsKey(locationName)) {
        soundLevelByLocation[locationName]!.add(soundLevel);
      } else {
        soundLevelByLocation[locationName] = [soundLevel];
        locationCoordinates[locationName] = LatLng(latitude, longitude);
      }
    }

    // Calculate the average sound level for each location
    List<Map<String, dynamic>> results = [];
    soundLevelByLocation.forEach((locationName, soundLevels) {
      double averageSoundLevel =
          soundLevels.reduce((a, b) => a + b) / soundLevels.length;
      LatLng location = locationCoordinates[locationName]!;
      results.add({
        'location_name': locationName,
        'average_sound_level': averageSoundLevel,
        'latitude': location.latitude,
        'longitude': location.longitude,
      });
    });
    for (int i = 0; i < results.length; i++) {
      log('${results[i]}');
    }

    setState(() {
      markerData = results.map((result) {
        LatLng location = LatLng(result['latitude'], result['longitude']);
        return Marker(
          markerId: MarkerId('${result['latitude']},${result['longitude']}'),
          position: location,
          infoWindow: InfoWindow(
            title: result['location_name'],
            snippet:
                'Average Noise Level: ${result['average_sound_level'].toStringAsFixed(2)} dB',
          ),
        );
      }).toSet();
    });
    return results;
  }
  // void calculateAverageSoundLevel(List<Map<String, dynamic>> soundData) {
  //   Map<String, List<double>> soundLevelByLocation = {};

  //   // Group the sound levels by location_name
  //   for (var item in soundData) {
  //     String locationName = item['location_name'];
  //     double soundLevel = double.parse(item['sound_level']);

  //     if (soundLevelByLocation.containsKey(locationName)) {
  //       soundLevelByLocation[locationName]!.add(soundLevel);
  //     } else {
  //       soundLevelByLocation[locationName] = [soundLevel];
  //     }
  //   }

  //   // Calculate the average sound level for each location
  //   Map<String, double> averageSoundLevels = {};
  //   soundLevelByLocation.forEach((locationName, soundLevels) {
  //     double averageSoundLevel =
  //         soundLevels.reduce((a, b) => a + b) / soundLevels.length;
  //     averageSoundLevels[locationName] = averageSoundLevel;
  //   });

  //   // Print the results
  //   averageSoundLevels.forEach((locationName, averageSoundLevel) {
  //     log('Average sound level for $locationName: $averageSoundLevel dB');
  //   });
  // }

  Future<List<Map<String, dynamic>>> getData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('client').get();

    List<Map<String, dynamic>> dataList = querySnapshot.docs.map((doc) {
      return {
        'sound_level': doc['sound_level'] ?? '60',
        'location_name': doc['location_name'] ?? 'No Address',
        'latitude': doc['latitude'] ?? '5.5',
        'longitude': doc['longitude'] ?? '8.0',
      };
    }).toList();

    calculateAverageSoundLevel(dataList);
    // for (int i = 0; i < data.length; i++) {
    //   log('${data[i]}');
    // }
    return dataList;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getCurrentPosition();
      await getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: isLoading && markerData == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColour,
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    zoom: 18,
                    target: LatLng(
                      realLatitude ?? 5.5,
                      realLongitude ?? 8.0,
                    ),
                  ),
                  markers: markerData ??
                      {
                        Marker(
                          markerId: const MarkerId('iconMarker'),
                          anchor: const Offset(0.5, 0.5),
                          position:
                              LatLng(realLatitude ?? 5.5, realLongitude ?? 8.0),
                          infoWindow: const InfoWindow(
                            title: 'Your current location',
                          ),
                          icon: BitmapDescriptor.defaultMarker,
                        ),
                      },
                )
          // FutureBuilder(
          //   future: getdata(),
          //   builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(child: CircularProgressIndicator());
          //     } else if (snapshot.hasError) {
          //       return Text('Error: ${snapshot.error}');
          //     } else {
          //       return FlutterMap(
          //           options: MapOptions(
          //             initialCenter: LatLng(
          //               realLatitude,
          //               realLongitude,
          //             ),
          //             initialZoom: 12,
          //           ),
          //           children: [
          //             TileLayer(
          //               urlTemplate:
          //                   "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          //               subdomains: const ['a', 'b', 'c'],
          //             ),
          //             MarkerLayer(markers: []),
          //           ]);
          //     }
          //   },
          // ),
          ),
    );
  }
}
