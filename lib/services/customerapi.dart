import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_miller/models/customer.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import 'notifier.dart';

getRice(RiceNotifier riceNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('users')
      .document('1')
      .collection('customers')
      .document('J67nn9DVKyzSZ5soPQA3')
      .collection('rice')
      .getDocuments();

  List<Rice> _riceList = [];

  snapshot.documents.forEach((document) {
    Rice rice = Rice.fromMap(document.data);
    _riceList.add(rice);
  });
  riceNotifier.riceList = _riceList;
}

getCustomer(CustomerNotifier customerNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('users')
      .document('1')
      .collection('customers')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Customer> _customerList = [];

  snapshot.documents.forEach((document) {
    Customer customer = Customer.fromMap(document.data);
    _customerList.add(customer);
  });
  customerNotifier.customerList = _customerList;
}

uploadCustomerAndImage(Customer customer, bool isUpdating, File localFile,
    Function customerUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('customer/images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadCustomer(customer, isUpdating, customerUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadCustomer(customer, isUpdating, customerUploaded);
  }
}

_uploadCustomer(Customer customer, bool isUpdating, Function customerUploaded,
    {String imageUrl}) async {
  CollectionReference customerRef = Firestore.instance
      .collection('users')
      .document('1')
      .collection('customers');

  if (imageUrl != null) {
    customer.image = imageUrl;
  }

  if (isUpdating) {
    customer.updatedAt = Timestamp.now();

    await customerRef.document(customer.id).updateData(customer.toMap());

    customerUploaded(customer);
    print('updated customer with id: ${customer.id}');
  } else {
    customer.createdAt = Timestamp.now();

    DocumentReference documentRef = await customerRef.add(customer.toMap());

    customer.id = documentRef.documentID;

    print('uploaded customer successfully: ${customer.toString()}');

    await documentRef.setData(customer.toMap(), merge: true);

    customerUploaded(customer);
  }
}

deleteCustomer(Customer customer, Function customerDeleted) async {
  if (customer.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(customer.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance
      .collection('users')
      .document('1')
      .collection('customers')
      .document(customer.id)
      .delete();
  customerDeleted(customer);
}

//rice


