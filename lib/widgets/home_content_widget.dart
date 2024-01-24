import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:noise_meter/noise_meter.dart';

// ignore: must_be_immutable
class HomePageContent extends StatefulWidget {
  String? elapsedTime;
  String? currentAddress;
  Position? currentPosition;
  final bool isRecording;
  NoiseReading? latestReading;
  HomePageContent(String? elapsedTime, String? currentAddress,
      Position? currentPosition, NoiseReading? latestReading,
      {super.key, required this.isRecording});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lat: ${widget.currentPosition?.latitude.toStringAsFixed(2) ?? "0.0"} ',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Lon: ${widget.currentPosition?.longitude.toStringAsFixed(2) ?? "0.0"}",
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          Text("Location: ${widget.currentAddress ?? " "}"),
          Text(
            ' ${widget.latestReading?.meanDecibel.toStringAsFixed(3)} dB',
            style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Max: ${widget.latestReading?.maxDecibel.toStringAsFixed(3)} dB',
            style: const TextStyle(fontSize: 17),
          ),
          Text(
            "Time: ${widget.elapsedTime} seconds",
            style: const TextStyle(fontSize: 18),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(widget.isRecording ? "Mic: ON" : "Mic: OFF",
                style: const TextStyle(fontSize: 25, color: Color(0XFF1E319D))),
          ),
        ],
      ),
    );
  }
}
