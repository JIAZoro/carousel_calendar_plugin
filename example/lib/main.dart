import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:carousel_calendar_plugin/carousel_calendar_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  List _dataArray = [];

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.15);
    _dataArray = [
      {"date": "2020-09-26", "value": 0.8},
      {"date": "2020-09-27", "value": 0.9},
      {"date": "2020-09-28", "value": 0.7},
      {"date": "2020-09-29", "value": 0.6},
      {"date": "2020-09-30", "value": 1.0},
    ];
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await CarouselCalendarPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          height: 200,
          color: Colors.grey,
          child: CalendarCarouselWidget(
            pageController: _pageController,
            dataSource: _dataArray,
            itemBuilder: (context, index, highlight) {
              if (highlight) {
                return _buildPageViewItem(_dataArray[index], highlight: true);
              }
              return _buildPageViewItem(_dataArray[index]);
            },
            currentIndex: (value) {
              print("当前index：$value");
            },
          ),
        ),
      ),
    );
  }

  _buildPageViewItem(Map dataMap, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            dataMap['date'].toString().replaceAll("2020-", ""),
            style: TextStyle(color: highlight ? Colors.white : Colors.white12),
          ),
          Container(
            width: 20,
            height: 150 * dataMap['value'],
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(241, 174, 75, 1),
                      Color.fromRGBO(241, 174, 75, 0.3)
                    ]),
                color: Colors.orange,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          )
        ],
      ),
    );
  }
}
