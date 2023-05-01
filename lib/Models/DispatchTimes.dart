import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DispatchTimes{
  late TimeOfDay finishingTime;
  late TimeOfDay startingTime;
  late String status;
  late String docID;


  DispatchTimes.empty();

  DispatchTimes({
    required this.finishingTime,
    required this.startingTime,
    required this.status,
    this.docID = ""
  });

  Map<String, dynamic> toJson() {
    return {
      'finishingTime': finishingTime.hour*60+finishingTime.minute,
      'startingTime': startingTime.hour*60+startingTime.minute,
      'status': status,
    };
  }

  factory DispatchTimes.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    int finishingHour = data['finishingTime'] ~/ 60;
    int finishingMinute = data['finishingTime'] % 60;
    TimeOfDay finishingTime = TimeOfDay(hour: finishingHour, minute: finishingMinute);

    int startingHour = data['startingTime'] ~/ 60;
    int startingMinute = data['startingTime'] % 60;
    TimeOfDay startingTime = TimeOfDay(hour: startingHour, minute: startingMinute);

    return DispatchTimes(
      finishingTime: finishingTime,
      startingTime: startingTime,
      status: data['status'],
      docID: snapshot.id,
    );
  }


}