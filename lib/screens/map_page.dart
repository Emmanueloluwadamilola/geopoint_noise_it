import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NoiseMapScreen extends StatefulWidget {
  static const String id = 'noise_noise_screen';

  const NoiseMapScreen({super.key});

  @override
  State<NoiseMapScreen> createState() => _NoiseMapScreenState();
}

class _NoiseMapScreenState extends State<NoiseMapScreen> {
  @override
  void initState() {
    super.initState();
    fetchMapData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Noise Heat Map'),
        ),
        body: FutureBuilder(
            future: fetchMapData(),
            builder: (context, AsyncSnapshot<List<WeightedLatLng>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                List<WeightedLatLng>? heatmapPoints = snapshot.data!;
                return FlutterMap(
                    options: const MapOptions(
                        initialCenter: LatLng(5.01, 8.35), initialZoom: 12),
                    children: [
                      TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: const ['a', 'b', 'c']),
                      HeatMapLayer(
                        heatMapDataSource:
                            InMemoryHeatMapDataSource(data: heatmapPoints),
                        heatMapOptions: HeatMapOptions(
                            radius: 20,
                            gradient: HeatMapOptions.defaultGradient,
                            minOpacity: 0.1),
                      )
                    ]);
              }
            }));
  }

  Future<List<WeightedLatLng>> fetchMapData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('client').get();
    List<WeightedLatLng> heatmapPoints = [];

    for (var doc in querySnapshot.docs) {
      double noiseLevel = doc['sound_level'];
      double latitude = doc['latitude'];
      double longitude = doc['longitude'];

      LatLng corr = LatLng(latitude, longitude);

      heatmapPoints.add(WeightedLatLng(corr, noiseLevel));
    }

    return heatmapPoints;
  }
}

// class WeightedLatLng {
//   final double latitude;
//   final double longitude;
//   final double noiseLevel;

//   WeightedLatLng(this.latitude, this.longitude, this.noiseLevel);
// }
