import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String id;
  String image;
  String name;
  String nic;
  String address;
  String mobile;
  Timestamp createdAt;
  Timestamp updatedAt;

  Customer();

  Customer.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    image = data['fimage'];
    name = data['fname'];
    nic = data['fnic'];
    address = data['faddress'];
    mobile = data['fmobile'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fimage': image,
      'fname': name,
      'faddress': address,
      'fnic': nic,
      'fmobile': mobile,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}

//rice

class Rice {
  String id;
  String date;
  String kg;
  String paid;
  String topay;

  Rice();

  Rice.fromMap(Map<String, dynamic> data) {
    id = data['rid'];
    date = data['rdate'];
    kg = data['rkg'];
    paid = data['rpaid'];
    topay = data['rtopay'];
  }

  Map<String, dynamic> toMap() {
    return {
      'rid': id,
      'rdate': date,
      'rkg': kg,
      'rpaid': paid,
      'rtopay': topay,
    };
  }
}
