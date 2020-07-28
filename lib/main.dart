import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentmin = 0;
  int _currentsec = 0;
  bool _click = false;
  int _start;
  Timer _timer;

  void startTimer() {
    _start = _currentmin * 60 + _currentsec;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
            _currentsec = _start % 60;
            _currentmin = _start ~/ 60;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screensize =
        MediaQuery.of(context).size; // determine size of users' devices
    return Scaffold(
      backgroundColor: Color(0xff6e5773),
      appBar: AppBar(
          title: Text(
            'Pomodoro',
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: Color(0xffe9e2d0),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.info,
                  color: Colors.black54,
                ),
                onPressed: () {
                  // TODO: show user guide - O
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Information'),
                        content: Text(
                            'Single Tap on circular area = Start/Pause timer\n\n'
                            'Long Tap on circular area = Reset timer\n\n'
                            'Tap on square area = set minutes/seconds'),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Done'))
                        ],
                      );
                    },
                  );
                }),
          ]),
      body: Center(
        child: Container(
          height: screensize.height * 0.705,
          width: screensize.width * 0.755,
          child: FlatButton(
            color: Color(0xffd45d79),
            shape: CircleBorder(),
            onLongPress: () {
              setState(() {
                _timer.cancel();
                _click = false;
                _currentmin = 0;
                _currentsec = 0;
              });
            },
            onPressed: () {
              // TODO: use boolean to decide start/pause timer - O
              _click = !_click;
              if (_click == true) {
                startTimer();
              } else if (_click == false) {
                _timer.cancel();
              }
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //set one for width 450, height 850
                    //set one for width 1080, height 1400
                    //the rest is for desktop size
                    // TODO: set the button size accordingly with above specification - X
                    height: screensize.height * 0.25,
                    width: screensize.width * 0.205,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      color: Color(0xffea9085),
                      onPressed: () {
                        showDialog<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return NumberPickerDialog.integer(
                                minValue: 0,
                                maxValue: 59,
                                initialIntegerValue: _currentmin,
                                title: Text('Select Minutes'),
                              );
                            }).then((int value) {
                          if (value != null) {
                            setState(() => _currentmin = value);
                          }
                        });
                      },
                      child: Text(
                        _currentmin.toString(),
                        style: timerstyle(),
                      ),
                    ),
                  ),
                  SizedBox(width: screensize.width * 0.05),
                  Container(
                    //set one for width 450, height 850
                    //set one for width 1080, height 1400
                    //the rest is for desktop size
                    height: screensize.height * 0.25,
                    width: screensize.width * 0.205,
                    child: FlatButton(
                      color: Color(0xffea9085),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      onPressed: () {
                        showDialog<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return NumberPickerDialog.integer(
                                minValue: 0,
                                maxValue: 59,
                                initialIntegerValue: _currentsec,
                                title: Text('Select Seconds'),
                              );
                            }).then((int value) {
                          if (value != null) {
                            setState(() => _currentsec = value);
                          }
                        });
                      },
                      child: Text(
                        _currentsec.toString(),
                        style: timerstyle(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle timerstyle() {
    return TextStyle(color: Colors.black45, fontSize: 100);
  }
}
