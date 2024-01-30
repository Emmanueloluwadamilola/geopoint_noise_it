import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:futa_noise_app/screens/home_screen.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart';

// ignore: must_be_immutable
class MapScreen extends StatelessWidget {
  static const String id = 'noise_noise_screen';
   MapScreen({super.key});

  HomeState homeState = HomeState();
  late double latitude = homeState.currentPosition!.latitude;
  late double longitude = homeState.currentPosition!.longitude;

  Future<List<Map<String, dynamic>>> getdata() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('client').get();

    List<Map<String, dynamic>> dataList = querySnapshot.docs.map((doc) {
      return {
        'sound_level': doc['sound_level'],
        'duration': doc['duration'],
        'location_name': doc['location_name'],
        'date': doc['date'],
        'time': doc['time'],
        'latitude': doc[latitude],
        'longitude': doc[longitude],
      };
    }).toList();

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getdata(),
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return FlutterMap(
        options:  MapOptions(
            initialCenter: LatLng(latitude, longitude),
           initialZoom: 15,
),
        children: [
          TileLayer(
            urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          
        ]);
              }
            }));
  }
}
