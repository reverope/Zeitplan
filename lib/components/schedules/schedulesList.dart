import 'package:Zeitplan/screens/screen-mainScaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget buildSchedulesBody(
    void Function() refresh,
    BuildContext context,
    Future<String> Function() retriveScheduleURL,
    Future<List<String>> Function() retriveProfileDetails,
    String formatted,
    String crStatus) {
  return FutureBuilder<String>(
      future: retriveScheduleURL(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return _streamBuild(
              refresh, snapshot, retriveProfileDetails, formatted, crStatus);
        } else {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        }
      });
}

Widget _streamBuild(
    void Function() refresh,
    AsyncSnapshot<String> snapshot,
    Future<List<String>> Function() retriveProfileDetails,
    String formatted,
    String crStatus) {
  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(snapshot.data)
          .document(formatted)
          .collection("meetings")
          .orderBy(
            "mStatus",
            descending: false,
          )
          .snapshots(),
      builder: (context, snapshots) {
        try {
          return buildListofSchedules(refresh, snapshots.data.documents,
              retriveProfileDetails, crStatus);
        } catch (e) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Loading",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 30,
              ),
              CircularProgressIndicator()
            ],
          ));
        }
      });
}
