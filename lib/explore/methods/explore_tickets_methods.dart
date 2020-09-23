import 'package:Ohstel_app/explore/models/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

Future<int> savePaidTicketDetails({
  @required String fullName,
  @required String phoneNumber,
  @required String email,
  @required int price,
  @required Ticket ticket,
}) async {
  final String id = Uuid().v4();
  var date = new DateTime.now().toString();
  var dateParse = DateTime.parse(date);
  final int month = dateParse.month;
  final int year = dateParse.year;

  try {
    // PaidHostelModel paidHostelInfo = PaidHostelModel(
    //   fullName: fullName,
    //   phoneNumber: phoneNumber,
    //   email: email,
    //   price: price,
    //   id: id,
    //   hostelDetails: hostelDetails.toMap(),
    // );
    // print(paidHostelInfo.toMap());
    // print(id);

    FirebaseFirestore db = FirebaseFirestore.instance;

    var batch = db.batch();

    // batch.set(
    //   paidHostelRef.doc(id),
    //   paidHostelInfo.toMap(),
    // );

    // batch.set(
    //   paidHostelInfoRef.collection(year.toString()).doc(month.toString()),
    //   {"count": FieldValue.increment(1)},
    //   SetOptions(merge: true),
    // );

    await batch.commit();

    print('save payment details');

    return 0;
  } catch (e) {
    Fluttertoast.showToast(
      msg: '${e.message}',
      gravity: ToastGravity.CENTER,
    );
    return -1;
  }
}
