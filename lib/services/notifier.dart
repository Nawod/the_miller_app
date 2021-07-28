import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:the_miller/models/customer.dart';

class RiceNotifier with ChangeNotifier {
  List<Rice> _riceList = [];
  // Rice _currentRice;

  UnmodifiableListView<Rice> get riceList => UnmodifiableListView(_riceList);

  //Rice get currentRice => _currentRice;

  set riceList(List<Rice> riceList) {
    _riceList = riceList;
    notifyListeners();
  }
}

class CustomerNotifier with ChangeNotifier {
  List<Customer> _customerList = [];
  Customer _currentCustomer;

  UnmodifiableListView<Customer> get customerList =>
      UnmodifiableListView(_customerList);

  Customer get currentCustomer => _currentCustomer;

  set customerList(List<Customer> customerList) {
    _customerList = customerList;
    notifyListeners();
  }

  set currentCustomer(Customer customer) {
    _currentCustomer = customer;
    notifyListeners();
  }

  addCustomer(Customer customer) {
    _customerList.insert(0, customer);
    notifyListeners();
  }

  deleteCustomer(Customer customer) {
    _customerList.removeWhere((_customer) => _customer.id == customer.id);
    notifyListeners();
  }
}

//rice


