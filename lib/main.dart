import 'dart:async';
import 'dart:ui' as prefix0;
import 'package:flutter/material.dart';
import 'Activities/BudgetList.dart';

void main() {
  runApp(new MaterialApp(
    title: 'budgets',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.grey),
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/BudgetList': (BuildContext context) => new BudgetList()
    },
  ));
}

/*class SplashScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Money mangement',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.green),
    home: Scaffold(
      body:
      Splash()

      )
      ///sleep1(),


    );
  }
}*/

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/BudgetList');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor : Colors.blueGrey[500],
        body: new Center(
          child : new Image.asset('images/money.png',width: 100,height: 100
          ),
        ));
  }
}