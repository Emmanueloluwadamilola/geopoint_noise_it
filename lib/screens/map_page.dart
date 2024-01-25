import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';


class NoiseMapScreen extends StatefulWidget {
  static const String id = 'map_page';

  const NoiseMapScreen({super.key});
  @override
  _NoiseMapScreenState createState() => _NoiseMapScreenState();
}

class _NoiseMapScreenState extends State<NoiseMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  List<FlSpot> noiseLevelData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   //title: Text('Noise Map'),
      // ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: noiseLevelData,
                      isCurved: true,
                      color: Colors.blue,
                      dotData:  FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData:  FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                   
                  ),
                  borderData: FlBorderData(show: true),
                  gridData:  FlGridData(show: true),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                // Call a function to fetch and add noise data markers
                fetchNoiseData();
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(5.0111382000, 8.3485931000), // Initial map location
                zoom: 12.0,
              ),
              markers: markers,
            ),
          ),
        ],
      ),
    );
  }

  void fetchNoiseData() async {
    CollectionReference noiseCollection = FirebaseFirestore.instance.collection('client');

    QuerySnapshot querySnapshot = await noiseCollection.get();

    // Clear existing data
    setState(() {
      markers.clear();
      noiseLevelData.clear();
    });

    // Add markers to the map based on noise data
    for (var doc in querySnapshot.docs) {
      double latitude = doc['latitude'];
      double longitude = doc['longitude'];
      String address = doc['location_name'];
      var noiseLevel = doc['sound_level'];

      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId('$latitude-$longitude'),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: 'Address', snippet: '$address\nNoise Level: $noiseLevel dB'),
          ),
        );

        // Add noise level data for the chart
        noiseLevelData.add(FlSpot(noiseLevelData.length.toDouble(), noiseLevel.toDouble()));
      });
    }

    // Update the map to reflect the added markers
    mapController.animateCamera(CameraUpdate.newLatLngBounds(getBounds(markers), 50));
  }

  LatLngBounds getBounds(Set<Marker> markers) {
    double minLat = markers.first.position.latitude;
    double maxLat = markers.first.position.latitude;
    double minLng = markers.first.position.longitude;
    double maxLng = markers.first.position.longitude;

    for (var marker in markers) {
      double lat = marker.position.latitude;
      double lng = marker.position.longitude;

      minLat = lat < minLat ? lat : minLat;
      maxLat = lat > maxLat ? lat : maxLat;
      minLng = lng < minLng ? lng : minLng;
      maxLng = lng > maxLng ? lng : maxLng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}