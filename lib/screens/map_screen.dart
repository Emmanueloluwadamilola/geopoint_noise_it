import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  static const String id = 'noise_noise_screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late List<Marker> markerData;
  double realLatitude = 5.0111382000;
  double realLongitude = 8.3485931000;

  Future<List<Map<String, dynamic>>> getdata() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('client').get();
    setState(() {
      markerData = querySnapshot.docs.cast<Marker>();
    });

    List<Map<String, dynamic>> dataList = querySnapshot.docs.map((doc) {
      return {
        'sound_level': doc['sound_level'],
        'duration': doc['duration'],
        'location_name': doc['location_name'],
        'date': doc['date'],
        'time': doc['time'],
        'latitude': doc['latitude'],
        'longitude': doc['longitude'],
      };
    }).toList();
    setState(() {
      markerData = dataList.cast<Marker>();
    });

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
                    options: MapOptions(
                      initialCenter: LatLng(realLatitude, realLongitude),
                      initialZoom: 12,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(markers: []),
                    ]);
              }
            }));
  }
}
