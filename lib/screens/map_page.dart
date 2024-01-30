import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Weight {
  double intensity;
  double latitude;
  double longitude;

  Weight(
      {required this.intensity,
      required this.latitude,
      required this.longitude});
}

class NoiseMapScreen extends StatefulWidget {
  static const String id = 'noise_noise_screen';

  const NoiseMapScreen({super.key});

  @override
  State<NoiseMapScreen> createState() => _NoiseMapScreenState();
}

class _NoiseMapScreenState extends State<NoiseMapScreen> {
   List<WeightedLatLng>? heatmapPoints;
  List<LatLng> bounds = const [
    LatLng(5.015812, 8.350419),
    LatLng(4.992782, 8.347677)
  ];

  @override
  void initState() {
    super.initState();
    fetchMapData();
  }

  Future<List<WeightedLatLng>> fetchMapData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('client').get();

    // Future<List<WeightedLatLng>> heatmapPoints =
    List<WeightedLatLng> heatmapPoints = [];
    querySnapshot.docs.take(3).forEach((doc) {
      double noiseLevel = doc['sound_level'];
      double latitude = doc['latitude'];
      double longitude = doc['longitude'];

      Weight weight = Weight(
          intensity: noiseLevel, latitude: latitude, longitude: longitude);
      heatmapPoints.add(weight as WeightedLatLng);
      // heatmapPoints
      //     .add(WeightedLatLng(LatLng(latitude, longitude), noiseLevel));
      //print(heatmapPoints);
    });
    return heatmapPoints;
    //List<WeightedLatLng> heatmapPoints = [];

    // double noiseLevel = doc['sound_level'];
    // double latitude = doc['latitude'];
    // double longitude = doc['longitude'];

    //LatLng corr = LatLng(latitude, longitude);

    // heatmapPoints
    //     .add(WeightedLatLng(LatLng(latitude, longitude), noiseLevel));

    // print(heatmapPoints);
    // print('');
    // return heatmapPoints;
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
                return MapWidget(bounds: bounds, heatmapPoints: heatmapPoints!);
              }
            }));
  }
}

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required this.bounds,
    required this.heatmapPoints,
  });

  final List<LatLng> bounds;
  final List<WeightedLatLng> heatmapPoints;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
            initialCenter: const LatLng(5.0111382000, 8.3485931000),
            initialZoom: 15,
            initialCameraFit:
                CameraFit.coordinates(coordinates: bounds)),
        children: [
          TileLayer(
            urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
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
}
