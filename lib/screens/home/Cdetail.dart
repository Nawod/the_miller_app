import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_miller/models/customer.dart';
import 'package:the_miller/screens/home/rice.dart';
import 'package:the_miller/services/customerapi.dart';
import 'package:the_miller/services/notifier.dart';

import 'Cform.dart';

class CustomerDetail extends StatefulWidget {
  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  @override
  void initState() {
    CustomerNotifier customerNotifier =
        Provider.of<CustomerNotifier>(context, listen: false);
    getCustomer(customerNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomerNotifier customerNotifier = Provider.of<CustomerNotifier>(context);

    _onCustomerDeleted(Customer customer) {
      Navigator.pop(context);
      customerNotifier.deleteCustomer(customer);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(customerNotifier.currentCustomer.name),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: Container(
            child: Column(
          children: <Widget>[
            SizedBox(height: 34),
            Image.network(
              customerNotifier.currentCustomer.image != null
                  ? customerNotifier.currentCustomer.image
                  : 'https://via.placeholder.com/150',
              width: 150,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 24),
            Text(
              customerNotifier.currentCustomer.name,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10),
            Text(
              customerNotifier.currentCustomer.nic,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(
              customerNotifier.currentCustomer.mobile,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(
              customerNotifier.currentCustomer.address,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        )),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return RiceView();
              }));
            },
            child: Icon(Icons.edit),
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => deleteCustomer(
                customerNotifier.currentCustomer, _onCustomerDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
