// import 'package:latlong2/latlong.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';

// import 'package:latlong2/latlong.dart';

// /// wraps a LatLng with an intensity
// class WeightedLatLng {
//   WeightedLatLng(this.latLng, this.intensity);

//   LatLng latLng;
//   double intensity;

//   @override
//   String toString() {
//     return 'WeightedLatLng{latLng: $latLng, intensity: $intensity}';
//   }

//   /// merge weighted lat long value the current WeightedLatLng,
//   void merge(double x, double y, double intensity) {
//     var newX = (x * intensity + latLng.longitude * this.intensity) /
//         (intensity + this.intensity);
//     var newY = (y * intensity + latLng.latitude * this.intensity) /
//         (intensity + this.intensity);
//     latLng = LatLng(newY, newX);
//     this.intensity += intensity;
//   }
// }

// class MyWidget extends StatefulWidget {
//   static const String id = 'noise_noise_screen';
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   double inten = 60;
//  //LatLng location = const LatLng(5.0111382000, 8.3485931000);
//  WeightedLatLng weightedLatLng = WeightedLatLng(const LatLng(5.0111382000, 8.3485931000), 60);
//    List<WeightedLatLng>? heatmapPoints;
//   List<LatLng> bounds = const [
//     LatLng(5.015812, 8.350419),
//     LatLng(4.992782, 8.347677)
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchHeatmapData();
//   }

//   Future<List<WeightedLatLng>?> fetchHeatmapData() async {
//     QuerySnapshot querySnapshot =
//         await FirebaseFirestore.instance.collection('client').get();

//     //List<WeightedLatLng>? heatmapPoints;
//     for (var doc in querySnapshot.docs) {
//       double latitude = doc['latitude'];
//       double longitude = doc['longitude'];
//       double intensity = doc['intensity'];

//       LatLng location = LatLng(latitude, longitude);

//       WeightedLatLng weightedLatLng = WeightedLatLng(location, intensity);
//       //weightedLatLng.add(location, intensity);

//       heatmapPoints!.add(weightedLatLng); 
//     }
//     return heatmapPoints;

 
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Map Heatmap'),
//       ),
//       body: heatmapPoints != null
//           ? FlutterMap(
//               options: MapOptions(
//                   initialCenter: const LatLng(5.0111382000, 8.3485931000),
//                   initialZoom: 15,
//                   initialCameraFit: CameraFit.coordinates(coordinates: bounds)),
//               children: [
//                   TileLayer(
//                     urlTemplate:
//                         "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                     subdomains: const ['a', 'b', 'c'],
//                   ),
//                   HeatMapLayer(
//                     heatMapDataSource:
//                         ,
//                     heatMapOptions: HeatMapOptions(
//                         radius: 20,
//                         gradient: HeatMapOptions.defaultGradient,
//                         minOpacity: 0.1),
//                   )
//                 ])
//           : const Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }

//   final double latitude;
//   final double longitude;
//   final T intensity;

//   Point(
//       {required this.intensity,
//       required this.latitude,
//       required this.longitude});
// }
