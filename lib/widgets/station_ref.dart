import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StationPageTest extends StatefulWidget {
  const StationPageTest({Key? key}) : super(key: key);

  @override
  State<StationPageTest> createState() => _StationPageTestState();
}

class _StationPageTestState extends State<StationPageTest> {
  final StreamController _streamController = StreamController();
  var _dataPresent = true;
  // var _newDataPresent = false;
  // var _lockStream = false;

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  // todo, Check internet presence
  // todo setstate manual mode              NOTIFY LISTENERS WITH PROVIDERS!!!


  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _getServerData();
    });
  }

  Future<void> _getServerData() async {
    try {
      final response = await http.get(url);
      _streamController.sink.add(response);

      _dataPresent = true;
      // print('got');
    } on SocketException {
      _dataPresent = true;
      // print('no net');
    } catch (err) {
      _dataPresent = true;
      // print(err.toString());
      // print('bad');
    } finally {
      // todo CHECK NO INTERNET STATUS
      // if (_newDataPresent != _dataPresent) {
      //   print('finally');
      //   setState(() {});
      //   // if (_dataPresent == false) {
      //   //   _lockStream = true;
      //   // }
      //   // _streamController.sink.done;
      // }
      // _newDataPresent = _dataPresent;
    }
  }

  var _startPressed = false;
  var _stopPressed = false;
  var _resetPressed = false;
  var _manualModePressed = false;
  var _manualMode = true;
  late bool _buttonPressed;
/*
  Widget _elevatedBn(
      {required Uri url,
      required String btnText,
      required bool theButtonPressed,
      required Map<String, dynamic> jsonData}) {
    return ElevatedButton(
      onPressed: _buttonPressed
          ? null
          : () async {
              setState(() {
                theButtonPressed = true;
                // _extend = true;
              });

              await http.patch(url, body: json.encode(jsonData));
              setState(() {
                theButtonPressed = false;
              });
            },
      style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
      child: Text(btnText),
    );
  }*/

  final url = Uri.parse(
      'https://cylinder-88625-default-rtdb.firebaseio.com/station1Control.json');

  @override
  Widget build(BuildContext context) {
    _buttonPressed =
        _startPressed || _stopPressed || _resetPressed || _manualModePressed
            ? true
            : false;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: deviceWidth * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(30),
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 4),
                    ),
                    child: !_dataPresent
                        ? const Center(
                            child: Text('No Internet Connection...'),
                          )
                        : StreamBuilder(
                            stream: _streamController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Please wait...'),
                                );
                              }

                              final response = snapshot.data! as http.Response;
                              final data = json.decode(response.body);
                              // _manualMode = data["manual_mode_phone"] == "false"
                              //     ? false
                              //     : true;
                              // setState(() {
                              //   _manualMode = data["manual_mode_machine"] == "true"?false:true;
                              // },);
                              return FittedBox(
                                child: Text(
                                  'Start:\t${data["start"]}\nStop:\t${data["stop"]}\nReset:\t${data["reset"]}\nManual/Auto:\t${data["manual_mode_phone"]} ${data["manual_mode_phone"] == "false" ? "AUTO" : "MANUAL"}\nManual/Auto MACHINE:\t${data["manual_mode_machine"]} ${data["manual_mode_machine"] == "false" ? "AUTO" : "MANUAL"}\nManual Number:\t${data["manual_step_number"]}\nCode Flow:\t${data["code_step_number"]}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 25),
                                ),
                              );
                            }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _buttonPressed
                            ? null
                            : () async {
                                setState(() {
                                  _startPressed = true;
                                  // _extend = true;
                                });

                                await http.patch(url,
                                    body: json.encode({'start': 'true'}));
                                Future.delayed(
                                        const Duration(milliseconds: 500))
                                    .then((value) {
                                  setState(() {
                                    _startPressed = false;
                                  });
                                });
                              },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child:  const Text("START"),
                      ),
                      ElevatedButton(
                        onPressed: _buttonPressed
                            ? null
                            : () async {
                                setState(() {
                                  _stopPressed = true;
                                  // _extend = true;
                                });

                                await http.patch(url,
                                    body: json.encode({'stop': 'true'}));
                                Future.delayed(
                                        const Duration(milliseconds: 500))
                                    .then((value) {
                                  setState(() {
                                    _stopPressed = false;
                                  });
                                });
                              },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child: const Text("STOP"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _buttonPressed
                            ? null
                            : () async {
                                setState(() {
                                  _resetPressed = true;
                                  // _extend = true;
                                });

                                await http.patch(url,
                                    body: json.encode({'reset': 'true'}));
                                Future.delayed(
                                        const Duration(milliseconds: 500))
                                    .then((value) {
                                  setState(() {
                                    _resetPressed = false;
                                  });
                                });
                              },
                        child: const Text("RESET"),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                      ),
                      ElevatedButton(
                        onPressed: _buttonPressed
                            ? null
                            : () async {
                                setState(() {
                                  // todo REMOVE
                                  _manualMode = !_manualMode;
                                  _manualModePressed = true;
                                });

                                await http.patch(url,
                                    body: json.encode({
                                      "manual_mode_phone":
                                          _manualMode ? "true" : "false"
                                    }));
                                // print(json.decode(res.body)["manual_mode_phone"]);
                                // _manualMode = res.body == "true" ? true : false;
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                ).then((value) {
                                  setState(() {
                                    _manualModePressed = false;
                                  });
                                });
                              },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child: Text(_manualMode ? "MANUAL" : "AUTOMATIC"),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: deviceWidth * 0.02,
              height: deviceHeight * 0.7,
              margin: const EdgeInsets.all(2),
              // padding: const EdgeInsets.all(10),
              color: Colors.black,
            )
          ],
        ),
      ),
    ));
  }
}
