import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_miller/services/auth.dart';
import 'package:the_miller/services/customerapi.dart';
import 'package:the_miller/services/notifier.dart';

class RiceView extends StatefulWidget {
  @override
  RiceViewState createState() => RiceViewState();
}

class RiceViewState extends State<RiceView> {
  @override
  void initState() {
    RiceNotifier riceNotifier =
     Provider.of<RiceNotifier>(context, listen: false);
     getRice(riceNotifier);
    super.initState();
  }

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    RiceNotifier riceNotifier = Provider.of<RiceNotifier>(context);
   // CustomerNotifier customerNotifier = Provider.of<CustomerNotifier>(context);
    Future<void> _refreshList() async {
       getRice(riceNotifier);
    }

    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('none'),
          backgroundColor: Colors.green[700],
          elevation: 0.0,
        ),
        body: new RefreshIndicator(
          child: Container(
              /*child: new ListView.builder(
                itemCount: riceNotifier.riceList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildRiceCard(context, index)),*/
              ),
          onRefresh: _refreshList,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  /* Widget buildRiceCard(BuildContext context, int index) {
   
    final riceCard = riceNotifier.riceList[index];
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Row(children: <Widget>[
                  Text(
                    riceCard.topay,
                    style: new TextStyle(fontSize: 30.0),
                  ),
                  Spacer(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 60.0),
                child: Row(children: <Widget>[
                  Text(riceCard.kg),
                  Spacer(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      riceCard.paid,
                      style: new TextStyle(fontSize: 35.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }*/
}
