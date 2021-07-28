import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_miller/screens/home/Cdetail.dart';
import 'package:the_miller/services/auth.dart';
import 'package:the_miller/services/customerapi.dart';
import 'package:the_miller/services/notifier.dart';

import 'Cform.dart';

class Cust extends StatefulWidget {
  @override
  _CustState createState() => _CustState();
}

class _CustState extends State<Cust> {
  @override
  void initState() {
    CustomerNotifier customerNotifier =
        Provider.of<CustomerNotifier>(context, listen: false);
    getCustomer(customerNotifier);
    super.initState();
  }

  bool loading = false;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    CustomerNotifier customerNotifier = Provider.of<CustomerNotifier>(context);
    Future<void> _refreshList() async {
      getCustomer(customerNotifier);
    }

    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('The Miller'),
          backgroundColor: Colors.green[700],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: new RefreshIndicator(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.network(
                  customerNotifier.customerList[index].image != null
                      ? customerNotifier.customerList[index].image
                      : 'https://via.placeholder.com/150',
                  width: 60,
                  fit: BoxFit.fitWidth,
                ),
                title: Text(customerNotifier.customerList[index].name),
                subtitle: Text(customerNotifier.customerList[index].nic),
                onTap: () {
                  customerNotifier.currentCustomer =
                      customerNotifier.customerList[index];

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return CustomerDetail();
                  }));
                },
              );
            },
            itemCount: customerNotifier.customerList.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Colors.black,
              );
            },
          ),
          onRefresh: _refreshList,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            customerNotifier.currentCustomer = null;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return CustomerForm(
                  isUpdating: false,
                );
              }),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
