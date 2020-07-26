import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class HostelModel {
  String hostelName;
  String hostelLocation;
  String hostelAreaName;
  int price;
  double distanceFromSchoolInKm;
  bool isRoomMateNeeded;
  int bedSpace;
  bool isSchoolHostel;
  String description;
  String extraFeatures;
  List<dynamic> imageUrl;
  int dateAdded;
  double ratings;
  String searchKey;
  String dormType;
  String hostelAccommodationType;
  String landMark;
  String id = Uuid().v1().toString();

  List<String> list = [
    'Guide',
    'Ghost',
    'Guardian',
    'Alpha',
    'Central',
    'Pixel',
    'Logic',
    'Science',
    'Nemo',
    'Hope',
  ];

//  hostelName: list[Random().nextInt(5)],

  HostelModel({
    @required this.hostelName,
    @required this.hostelLocation,

//    @required this.hostelAreaName,

    @required this.price,
    @required this.distanceFromSchoolInKm,
    @required this.isRoomMateNeeded,
    @required this.bedSpace,
    @required this.isSchoolHostel,
    @required this.description,
    @required this.extraFeatures,
    @required this.imageUrl,

//    @required this.dormType,
//    @required this.landMark,
//    @required this.hostelAccommodationType,

    @required this.ratings,
  });

  HostelModel.fromMap(Map<String, dynamic> mapData) {
    this.hostelName = mapData['hostelName'];
    this.hostelLocation = mapData['hostelLocation'];
    this.hostelAreaName = mapData['hostelAreaName'];
    this.price = mapData['price'];
    this.distanceFromSchoolInKm = mapData['distanceFromSchoolInKm'];
    this.isRoomMateNeeded = mapData['isRoomMateNeeded'];
    this.bedSpace = mapData['bedSpace'];
    this.isSchoolHostel = mapData['isSchoolHostel'];
    this.description = mapData['description'];
    this.extraFeatures = mapData['extraFeatures'];
    this.imageUrl = mapData['imageUrl'];
    this.dateAdded = mapData['dateAdded'];
    this.ratings = mapData['ratings'];
    this.searchKey = mapData['searchKey'];
    this.dormType = mapData['hostelType'];
    this.landMark = mapData['landMark'];
    this.hostelAccommodationType = mapData['hostelAccommodationType'];
    this.id = mapData['id'];
  }

  Map toMap() {
    Map data = Map<String, dynamic>();
    data['hostelName'] = this.hostelName;
    data['hostelLocation'] = this.hostelLocation;
//    data['hostelAreaName'] = this.hostelAreaName;
    data['hostelLocation'] = list2[Random().nextInt(4)].toLowerCase();
    data['price'] = this.price;
    data['distanceFromSchoolInKm'] = this.distanceFromSchoolInKm;
    data['isRoomMateNeeded'] = this.isRoomMateNeeded;
    data['bedSpace'] = this.bedSpace;
    data['isSchoolHostel'] = this.isSchoolHostel;
    data['description'] = this.description;
    data['extraFeatures'] = this.extraFeatures;
    data['imageUrl'] = this.imageUrl;
    data['dateAdded'] = Timestamp.now().microsecondsSinceEpoch;
    data['ratings'] = this.ratings;

    data['dormType'] =
        ['boys only', 'girls only', 'mixed'][Random().nextInt(3)];
    data['landMark'] = 'this will be a name of any land mark near the hostel';
    data['hostelAccommodationType'] =
        'accoomdation type one room, self contain, 2 bedroom(for off campus) while two, three or 4 to a room(for school hoste)';

    data['searchKey'] = this.hostelName[0].toLowerCase();
    data['id'] = this.id;

    return data;
  }
}

List<String> list1 = [
  'Guide',
  'Ghost',
  'Alpha',
  'Pixel',
  'Science',
];

List<String> list2 = [
  'Oke Odo',
  'Chapel',
  'Tanke',
  'MFM',
];

class DO {
  List<HostelModel> list = [
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 90000,
      distanceFromSchoolInKm: 2.6,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRbxb4jLKWfUfwHuDIRye8qLhLme4nVY_ujZw&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSc8bgzqiMQt5HQWGjVOcPSvxHrFi6OxcbKgQ&usqp=CAU'
      ],
      ratings: 3.6,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 40000,
      distanceFromSchoolInKm: 4.1,
      isRoomMateNeeded: true,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://media.gettyimages.com/photos/economy-class-twin-room-in-art-hotel-in-moscow-picture-id649040126?k=6&m=649040126&s=612x612&w=0&h=-MUGQXfLz_RU8HvcG5dD5oR4WdKez1pC6Rh-xek-x90=',
        'https://media.gettyimages.com/photos/modern-bedroom-interior-with-blank-wall-for-copy-space-picture-id1060148072?k=6&m=1060148072&s=612x612&w=0&h=N5liesjFf0kMw270ZHUV56JYFUNXHojHq8GITNvG2yY=',
      ],
      ratings: 4.0,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 80000,
      distanceFromSchoolInKm: 4.0,
      isRoomMateNeeded: false,
      bedSpace: 1,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://media.gettyimages.com/photos/young-woman-with-backpack-arriving-at-empty-hostel-room-picture-id847741376?k=6&m=847741376&s=612x612&w=0&h=prgNVDKCYSqcBBScI9YSwANIrcu8cV-ZcjULB1FIxiA='
      ],
      ratings: 2.0,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 100000,
      distanceFromSchoolInKm: 0.0,
      isRoomMateNeeded: true,
      bedSpace: 4,
      isSchoolHostel: true,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://media.gettyimages.com/photos/modern-bedroom-picture-id939846936?k=6&m=939846936&s=612x612&w=0&h=plinmhJdUXsOW4-1vlYr2z9bqRCmLuf5ccHOQuHQPuw=',
        'https://media.gettyimages.com/photos/capsule-hotel-room-interior-picture-id1006574500?k=6&m=1006574500&s=612x612&w=0&h=Pmw2T0KRkDRgvh4A7TsdU_Gejr9vwUDlCuapWs1S3aU=',
      ],
      ratings: 4.0,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 75000,
      distanceFromSchoolInKm: 6.1,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://media.gettyimages.com/photos/cozy-bedroom-in-hostel-picture-id941659684?k=6&m=941659684&s=612x612&w=0&h=FS8Y4N-kDefuVMMV9UlTbnscHZ_K2HtMzgjyTdWZTWw=',
        'https://media.gettyimages.com/photos/bedroom-interior-picture-id899419506?k=6&m=899419506&s=612x612&w=0&h=P8mjbvH99sr2Td71r7gmRLwXTvkDsT2R4xx-flWOQk4=',
      ],
      ratings: 3.5,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 80000,
      distanceFromSchoolInKm: 3.6,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://media.gettyimages.com/photos/country-cottage-bedroom-overlooking-rural-scene-in-the-morning-picture-id1016087994?k=6&m=1016087994&s=612x612&w=0&h=-Pml2kr3JvtFmLY4vm1YMrp0ErNcAg0jCBYpQcTvxl4=',
        'https://media.gettyimages.com/photos/pilgrim-in-a-shelter-on-the-camino-de-santiago-spain-picture-id936328030?k=6&m=936328030&s=612x612&w=0&h=9tiTFMo57wHtyw9w16Op3ptHJ_HLZypcytb4ZOOtzWM=',
      ],
      ratings: 2.6,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 100000,
      distanceFromSchoolInKm: 0.0,
      isRoomMateNeeded: true,
      bedSpace: 4,
      isSchoolHostel: true,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR4nhhP0DRKMwMR2sJjWjAeC-bjltp0t2zMDA&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR_lug8a96tNbpfOWuIZN7eFcn8fBUlBIhf6A&usqp=CAU',
      ],
      ratings: 3.0,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 70000,
      distanceFromSchoolInKm: 4.7,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQN26rpwgMGFDRR8pa5VnxwYmsp4zxOzOmUOQ&usqp=CAU'
      ],
      ratings: 2.6,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 100000,
      distanceFromSchoolInKm: 0.0,
      isRoomMateNeeded: true,
      bedSpace: 4,
      isSchoolHostel: true,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQcCQoAsmyTqEwahV9tzQxkcbEZ6H3QktOr7Q&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQuGv_JKqmWD7DKUlGdlxF8MYJXYFpG0asQ-Q&usqp=CAU'
      ],
      ratings: 3.6,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 60000,
      distanceFromSchoolInKm: 2.1,
      isRoomMateNeeded: true,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTezFUhoWhkEzxIoVeVhfyszWZ1nhtrCe3Iow&usqp=CAU',
      ],
      ratings: 2.5,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 80000,
      distanceFromSchoolInKm: 7.8,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTPIm-b0kLWxNAIZf3BgriefQhRVMJWgV1EhQ&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSl5z08PhS6SlOY2SSNXA2NnDogmcgEFUvDyg&usqp=CAU',
      ],
      ratings: 1.6,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 75000,
      distanceFromSchoolInKm: 4.9,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS5IBl61oRapiJ5W0ojnfwwvexcC_JP2G5FUg&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTKfCL6d_9evDlO1Zflc2gknKq0RRwbJGmdBQ&usqp=CAU',
      ],
      ratings: 4.6,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 90000,
      distanceFromSchoolInKm: 1.1,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTr3CisF6_k44_2Dsno4kDoRavsv27iVxAxmA&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSf24bgLsmIQbkXhACma3CCiIiufYb2BrPTMg&usqp=CAU',
      ],
      ratings: 5.0,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 55000,
      distanceFromSchoolInKm: 3.1,
      isRoomMateNeeded: true,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTIenNeWCXUB-0STlX4moPLujnq2xLwM9oNWQ&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS-h_OM7JEf_T-IF-r3af9QN-E43XrEzg__jw&usqp=CAU',
      ],
      ratings: 1.9,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 90000,
      distanceFromSchoolInKm: 5.7,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWA6ii_87E4Ylvz4dpCmRLh5O-jWDTzYr2cA&usqp=CAU',
      ],
      ratings: 3.1,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 45000,
      distanceFromSchoolInKm: 4.3,
      isRoomMateNeeded: true,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTZQboZxJ-qJpqzpolphHXPpmiMJ3TBZHAl7g&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSdffbpAB_7yTLM7UrFFGw6T2Nslgs1MFVqwA&usqp=CAU',
      ],
      ratings: 4.6,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 80000,
      distanceFromSchoolInKm: 7.8,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSz94cfkvY0FoZi8p1NxzgkRNf8ghn8Z0z96Q&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSOY8EKVFKIwgpPI5oM09XcUb5b_FTyTqNdrA&usqp=CAU'
      ],
      ratings: 3.9,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 65000,
      distanceFromSchoolInKm: 3.9,
      isRoomMateNeeded: false,
      bedSpace: 1,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRCkpAlXBYyoc6TB1PqUqrucDWk2KWaqvmSxQ&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTPnt3730CF1ww0wN4Rpx80Srt9x1OURUDbzA&usqp=CAU'
      ],
      ratings: 3.6,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 85000,
      distanceFromSchoolInKm: 5.1,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSw_5cpsre6-KirDyjlDefmBPH_uSVPposqCA&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-x3yLdOOxnrNXrE377ExkutgvwArSZ5_FUw&usqp=CAU',
      ],
      ratings: 2.9,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 80000,
      distanceFromSchoolInKm: 6.1,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQBvmYyh0aKw6adDpc762XSzZdekGhydRLhkw&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-JVwrtRizVOjuzEoTHAr1GD_SL-fnwScEeg&usqp=CAU'
      ],
      ratings: 1.4,
    ),
    HostelModel(
      hostelName: '${list1[Random().nextInt(5)]} hostel',
      hostelLocation: 'This will be the be location details of the hostel',
      price: 80000,
      distanceFromSchoolInKm: 3.6,
      isRoomMateNeeded: false,
      bedSpace: 2,
      isSchoolHostel: false,
      description:
          'this will be a description(short) of the hostel detailing things about it.',
      extraFeatures:
          'this will be a list of extra features the the hostel have, thing like ',
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS1lhIAQkQ-imhqw2Ib71JJBPaLufY7wQu--g&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTnwUkUfUhqLZk0WJOyKx3QN_8eYxXdxpJILQ&usqp=CAU',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTBjDKHgrArikvwJ1qzlw8d3HDxrn98NJbBEQ&usqp=CAU',
      ],
      ratings: 3.3,
    ),
  ];
}
