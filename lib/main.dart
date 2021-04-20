import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';
import 'package:nepali_utils/nepali_utils.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) {
    return Future.wait<bool>([
      HomeWidget.saveWidgetData('title', NepaliDateFormat("EE, d MMMM").format(DateTime.now().toNepaliDateTime()).toString()),
      HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample'),
    ]).then((value) {
      return !value.contains(false);
    });
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: BikramSambatScreen(),
    );
  }
}

class BikramSambatScreen extends StatefulWidget {
  @override
  _BikramSambatScreenState createState() => _BikramSambatScreenState();
}

class _BikramSambatScreenState extends State<BikramSambatScreen> {
  TextEditingController toAD = TextEditingController();
  TextEditingController toBS = TextEditingController();
  String toADText = '';
  String toBSText = '';

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    HomeWidget.saveWidgetData('title', NepaliDateFormat("EE, d MMMM").format(DateTime.now().toNepaliDateTime()).toString());
    HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
    _startBackgroundUpdate();
  }

  void _startBackgroundUpdate() {
    final now = DateTime.now();
    DateTime todaysDate = DateTime(now.year, now.month, now.day, 0);
    todaysDate = todaysDate.add(Duration(days: 1));
    final difference = todaysDate.difference(now).inSeconds;
    Workmanager.cancelAll();
    Workmanager.registerPeriodicTask('1', 'widgetBackgroundUpdate', frequency: Duration(days: 1), initialDelay: Duration(seconds: difference));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black54,
            elevation: 0,
            leading: Icon(Icons.calendar_today_outlined, color: Colors.blue),
            titleSpacing: 0,
            title: Text('Bikram Sambat'),
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.0))),
          ),
          body: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    TextField(
                      cursorColor: Colors.blue,
                      style: TextStyle(color: Colors.white),
                      onSubmitted: (value) {
                        print(value);
                        if (value.isEmpty) {
                          toBSText = ' ';
                        } else if (DateTime.tryParse(value) != null) {
                          toBSText = DateTime.parse(value).toNepaliDateTime().toString().split(' ')[0];
                        } else {
                          print('${DateTime.tryParse(value)}');
                          toBSText = 'Invalid Date Format. "yyyy-mm-dd"';
                        }

                        setState(() {});
                      },
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Enter Date in AD',
                        hintText: 'yyyy-mm-dd',
                        border: OutlineInputBorder(borderSide: BorderSide(width: 1.75)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1.75)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      cursorColor: Colors.blue,
                      style: TextStyle(color: Colors.white),
                      onSubmitted: (value) {
                        print(value);
                        if (value.isEmpty) {
                          toADText = ' ';
                        } else if (NepaliDateTime.tryParse(value) != null) {
                          toADText = NepaliDateTime.parse(value).toDateTime().toString().split(' ')[0];
                        } else {
                          print('${DateTime.tryParse(value)}');
                          toADText = 'Invalid Date Format. "yyyy-mm-dd"';
                        }
                        setState(() {});
                      },
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Enter Date in BS',
                        hintText: 'yyyy-mm-dd',
                        border: OutlineInputBorder(borderSide: BorderSide(width: 1.75)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1.75)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(children: [
                      Text('Converted to AD:', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 10),
                      SelectableText('$toADText', style: TextStyle(fontSize: 16)),
                    ]),
                    Row(children: [
                      Text('Converted to BS:', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 10),
                      SelectableText('$toBSText', style: TextStyle(fontSize: 16)),
                    ]),
                  ],
                ),
                Column(
                  children: [
                    Divider(color: Colors.white),
                    Text('Tip: Add widget in homescreen', style: TextStyle(fontSize: 16)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
