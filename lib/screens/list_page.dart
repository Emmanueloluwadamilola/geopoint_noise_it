import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  static const String id = 'list_page';
   const ListPage({super.key});


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
      };
    }).toList();

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "Sound Records",
            style: TextStyle(color: Color(0XFF1E319D)),
          ),
        ),
        body: FutureBuilder(
            future: getdata(),
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        'Noise Level: ${snapshot.data![index]['sound_level']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Duration: ${snapshot.data![index]['duration']} '),
                        Text(
                            'Address: ${snapshot.data![index]['location_name']}'),
                        Text('Date: ${snapshot.data![index]['date']}'),
                        Text('Time: ${snapshot.data![index]['time']}'),
                      ],
                    ),
                  );
                });
              }
            }));
  }
}
