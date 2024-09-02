import 'package:flutter/material.dart';
import 'package:futa_noise_app/constants.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ignore: must_be_immutable
class HomePageContent extends StatefulWidget {
  String? elapsedTime;
  String? currentAddress;
  String? currentState;
  String? currentCity;
  Position? currentPosition;
  final bool isRecording;
  NoiseReading? latestReading;
  final bool isLoading;
  HomePageContent(
      {super.key,
      required this.currentCity,
      required this.currentState,
      required this.isRecording,
      required this.latestReading,
      required this.currentAddress,
      required this.currentPosition,
      this.isLoading = false,
      required this.elapsedTime});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, right: 16, left: 16, top: 16),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Noise App',
                style: TextStyle(
                  fontFamily: black,
                  fontSize: 30,
                  color: Color(0xFF080713),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F4F8),
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(20),
                ),
                // backgroundColor: Color,
                child: PopupMenuButton(
                    iconColor: kPrimaryColour,
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Reset Reading'),
                            onTap: () {
                              setState(() => widget.latestReading = null);
                            },
                          ),
                        ]),
              ),
            ],
          ),
          const Gap(15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              image:
                  const DecorationImage(image: AssetImage(backgroundCardImage)),
              borderRadius: BorderRadius.circular(12),
              color: kPrimaryColour,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current location ',
                  style: TextStyle(
                      fontFamily: extraBold, fontSize: 24, color: Colors.white),
                ),
                const Gap(5),
                widget.isLoading
                    ? Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: kPrimaryColour,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                        .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true))
                        .shimmer(
                          delay: 400.ms,
                          duration: 1800.ms,
                          color: kLightBlue,
                        )
                    : Text(
                        widget.currentState ?? '........',
                        style: const TextStyle(
                            fontFamily: bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                const Gap(5),
                widget.isLoading
                    ? Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: kPrimaryColour,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                        .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true))
                        .shimmer(
                          delay: 400.ms,
                          duration: 1800.ms,
                          color: kLightBlue,
                        )
                    : Text(
                        widget.currentCity ?? '........',
                        style: const TextStyle(
                          fontFamily: bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                const Gap(5),
                widget.isLoading
                    ? Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: kPrimaryColour,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                        .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true))
                        .shimmer(
                          delay: 400.ms,
                          duration: 1800.ms,
                          color: kLightBlue,
                        )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                          const Gap(7),
                          Flexible(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              widget.currentAddress ?? '........',
                              style: const TextStyle(
                                  fontFamily: regular,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          //const Gap(40),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 130),
            child: Stack(children: [
              SizedBox(
                height: 190,
                width: 190,
                child: CircularProgressIndicator(
                  strokeWidth: 12,
                  backgroundColor: kLightBlue.withOpacity(0.2),
                  semanticsLabel: widget.latestReading == null
                      ? '0.0'
                      : ' ${((widget.latestReading?.meanDecibel)! / 150).toStringAsFixed(1)}',
                  // valueColor: ,
                  value: double.parse(widget.latestReading == null
                      ? '0.0'
                      : ' ${((widget.latestReading?.meanDecibel)! / 150).toStringAsFixed(1)}'),
                  color: kPrimaryColour,
                ),
              ),
              Positioned(
                top: 60,
                // bottom: 10,
                left:
                    widget.latestReading?.meanDecibel.toStringAsFixed(1) == null
                        ? 30
                        : 10,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        ' ${widget.latestReading?.meanDecibel.toStringAsFixed(1) ?? '0.0'} ',
                        style: const TextStyle(fontSize: 60, fontFamily: bold
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Text(
                        'dB',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: regular,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),

          // Text(
          //   'Max: ${widget.latestReading?.maxDecibel.toStringAsFixed(1) ?? 0.00} dB',
          //   style: const TextStyle(fontSize: 17),
          // ),
          // Text(
          //   "Time: ${widget.elapsedTime}",
          //   style: const TextStyle(fontSize: 18),
          // ),
          // Container(
          //   margin: const EdgeInsets.only(top: 20, bottom: 20),
          //   child: Text(widget.isRecording ? "Mic: ON" : "Mic: OFF",
          //       style: const TextStyle(fontSize: 25, color: Color(0XFF1E319D))),
          // ),
        ],
      ),
    );
  }
}
