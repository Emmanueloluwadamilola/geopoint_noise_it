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
  HomePageContent(
      {super.key,
      required this.isRecording,
      required this.latestReading,
      required this.currentAddress,
      required this.currentPosition,
      required this.elapsedTime});

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
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Lon: ${widget.currentPosition?.longitude.toStringAsFixed(2) ?? "0.0"}",
                style: const TextStyle(fontSize: 25),
              )
            ],
          ),
          Text(
            "Location: ${widget.currentAddress ?? " "}",
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                ' ${widget.latestReading?.meanDecibel.toStringAsFixed(1) ?? 0.00} ',
                style: const TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'dB',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Max: ${widget.latestReading?.maxDecibel.toStringAsFixed(1) ?? 0.00} dB',
            style: const TextStyle(fontSize: 17),
          ),
          Text(
            "Time: ${widget.elapsedTime}",
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


