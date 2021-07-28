import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_miller/screens/wrapper.dart';
import 'package:the_miller/services/auth.dart';
import 'package:the_miller/services/notifier.dart';
import 'models/user.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CustomerNotifier(),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
