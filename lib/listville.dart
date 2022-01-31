import 'package:appflutterweather2/current.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/location.dart';

class NoteList extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  List<Location>? locations;

  NoteList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste de mes préférences"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('ville')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  child: ListTile(
                      title: Text(doc['ville']),
                      subtitle: Text(doc['country']),
                      onTap: () {
                        _navigateToNextScreen(context, doc['ville'],
                            doc['country'], doc['lat'], doc['lon']);
                      }),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  _navigateToNextScreen(
      BuildContext context, String v, String c, String lat, String lon) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CurrentWeatherPage(
            user!,
            locations = [Location(city: v, country: c, lat: lat, lon: lon)],
            context,
            '')));
  }
}
