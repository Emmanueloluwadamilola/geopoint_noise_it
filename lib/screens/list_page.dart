import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/constants.dart';
import 'package:gap/gap.dart';

class ListPage extends StatefulWidget {
  static const String id = 'list_page';
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> dataList = [];

  Future<List<Map<String, dynamic>>> getdata() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('client').get();

    dataList = querySnapshot.docs.map((doc) {
      return {
        'sound_level': doc['sound_level'],
        'duration': doc['duration'],
        'location_name': doc['location_name'],
        'date': doc['date'],
        'time': doc['time'],
      };
    }).toList();
    setState(() {
      isLoading = false;
    });
    log('Fetch done');
    return dataList;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getdata();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sound levels',
              style: TextStyle(
                fontFamily: black,
                fontSize: 30,
                color: Color(0xFF080713),
              ),
            ),
            const Gap(30),
            isLoading
                ? Column(
                    children: [
                      Gap(MediaQuery.of(context).size.height * 0.35),
                      const Center(
                        child: SizedBox(
                          height: 55,
                          width: 55,
                          child: CircularProgressIndicator(
                            color: kPrimaryColour,
                          ),
                        ),
                      ),
                    ],
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: List.generate(dataList.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ListCardWidget(
                                address: dataList[index]['location_name'],
                                duration: dataList[index]['duration'],
                                time: dataList[index]['time'],
                                date: dataList[index]['date'],
                                noiseLevel: dataList[index]['sound_level']),
                          );
                        }),
                      ),
                    ),
                  ),
          ],
        ),
      )),
    );
  }
}

class ListCardWidget extends StatelessWidget {
  const ListCardWidget({
    super.key,
    required this.address,
    required this.duration,
    required this.time,
    required this.date,
    required this.noiseLevel,
  });
  final String? address;
  final String? duration;
  final String? time;
  final String? date;
  final String? noiseLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        image: const DecorationImage(image: AssetImage(backgroundCardImage)),
        borderRadius: BorderRadius.circular(8),
        color: kLightBlue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address ?? '',
            style: const TextStyle(
              fontFamily: bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.visible,
          ),
          const Gap(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${noiseLevel ?? '0.0'} dB',
                style: const TextStyle(fontFamily: bold, fontSize: 14),
              ),
              Text(
                duration ?? '',
                style: const TextStyle(fontFamily: bold, fontSize: 14),
              ),
            ],
          ),
          const Gap(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date ?? '',
                style: const TextStyle(fontFamily: bold, fontSize: 14),
              ),
              Text(
                time ?? '',
                style: const TextStyle(fontFamily: bold, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
