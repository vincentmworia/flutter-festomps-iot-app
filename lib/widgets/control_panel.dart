import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/enum_data.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({
    Key? key,
    required this.width,
    required this.height,
    required this.stationName,
  }) : super(key: key);
  final double width;
  final double height;
  final Station stationName;

  static const _offColor = Color.fromRGBO(12, 4, 4, 0.2);

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  //todo server operations plus provider
  var _hasInitialized = false;
  var _activeBn = true;
  late MachineMode machineModeDistribution;
  late MachineMode machineModeSorting;
  late bool powerDistribution;
  late bool powerSorting;
  late bool powerAll;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      // todo Initialize these values from the server
      machineModeDistribution = MachineMode.auto;
      machineModeSorting = MachineMode.manual;
      powerDistribution = true;
      powerSorting = false;
      powerAll = false;

      _hasInitialized = true;
    }
  }

  Uri url(String station) => Uri.parse(
      'https://cylinder-88625-default-rtdb.firebaseio.com/$station.json');

  Widget _controlBn(
          {required Map<String, double> dimension,
          required String text,
          required Function() onTap}) =>
      SizedBox(
        height: dimension['height'],
        width: dimension['width'],
        child: ElevatedButton(
          onPressed: _activeBn ? onTap : null,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _autoManualDisplay(
          {required double width,
          required double height,
          required String text,
          required Color dividerColor,
          required bool isActive}) =>
      SizedBox(
        width: width * 0.25,
        height: height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            SizedBox(
              width: width * 0.2,
              child: Divider(
                color: dividerColor,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: width * 0.2,
                  height: height * 0.3,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.deepOrange[400]
                        : ControlPanel._offColor,
                  ),
                ),
                if (text == 'Manual' && isActive)
                  StreamBuilder(
                      stream: widget.stationName == Station.distribution
                          ? _streamControllerDistributionTxtManAuto.stream
                          : _streamControllerDistributionTxtManAuto.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center();
                        }
                        final step = snapshot.data as String;
                        return  Text(
                          step,
                          style: const TextStyle(color: Colors.black, fontSize: 25.0),
                          textAlign: TextAlign.center,
                        );
                      })
              ],
            ),
          ],
        ),
      );

  // todo  Wait for python to finish
  Future<void> _bnTrue() => Future.delayed(const Duration(milliseconds: 1000))
      .then((_) => setState(() => _activeBn = true));

  Future<void> _startStopResetPressed(String button) async {
    setState(() => _activeBn = false);
    switch (widget.stationName) {
      case Station.distribution:
        await http.patch(url('station1Control'),
            body: json.encode({button: 'true'}));
        break;
      case Station.sorting:
        await http.patch(url('station2Control'),
            body: json.encode({button: 'true'}));
        break;
      case Station.all:
        await http.patch(url('stationAllControl'),
            body: json.encode({button: 'true'}));
        break;
    }
    _bnTrue();
  }

  Future<void> _manualAutoPressed() async {
    setState(() => _activeBn = false);
    Future<void> httpReq(String stationName) async {
      await http.patch(url(stationName),
          body: json.encode({
            'manual_mode_phone': stationName == 'station1Control'
                ? (machineModeDistribution == MachineMode.auto
                    ? 'true'
                    : 'false')
                : stationName == 'station2Control'
                    ? (machineModeSorting == MachineMode.auto
                        ? 'true'
                        : 'false')
                    : ('error')
          }));
    }

    switch (widget.stationName) {
      case Station.distribution:
        httpReq('station1Control');
        break;
      case Station.sorting:
        httpReq('station2Control');
        break;
      case Station.all:
        httpReq('stationAllControl');
        break;
    }
    _bnTrue();
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      _getServerData();
    });
  }

  final StreamController _streamControllerDistribution = StreamController();
  final StreamController _streamControllerSorting = StreamController();
  final StreamController _streamControllerAll = StreamController();

  final StreamController _streamControllerDistributionPower =
      StreamController();
  final StreamController _streamControllerSortingPower = StreamController();
  final StreamController _streamControllerAllPower = StreamController();

  final StreamController _streamControllerDistributionManAuto =
      StreamController();
  final StreamController _streamControllerDistributionBnManAuto =
      StreamController();

  final StreamController _streamControllerSortingManAuto = StreamController();
  final StreamController _streamControllerSortingBnManAuto = StreamController();

  final StreamController _streamControllerDistributionTxtManAuto =
      StreamController();
  final StreamController _streamControllerSortingTxtManAuto =
      StreamController();

  @override
  void dispose() {
    super.dispose();
    switch (widget.stationName) {
      case Station.distribution:
        _streamControllerSorting.close();
        _streamControllerAll.close();
        _streamControllerSortingPower.close();
        _streamControllerAllPower.close();
        _streamControllerSortingManAuto.close();
        _streamControllerSortingBnManAuto.close();
        _streamControllerSortingTxtManAuto.close();
        break;
      case Station.sorting:
        _streamControllerDistribution.close();
        _streamControllerAll.close();
        _streamControllerDistributionPower.close();
        _streamControllerAllPower.close();
        _streamControllerDistributionManAuto.close();
        _streamControllerDistributionBnManAuto.close();
        _streamControllerDistributionTxtManAuto.close();
        break;
      case Station.all:
        _streamControllerDistribution.close();
        _streamControllerSorting.close();
        _streamControllerDistributionPower.close();
        _streamControllerSortingPower.close();
        _streamControllerDistributionManAuto.close();
        _streamControllerSortingManAuto.close();
        _streamControllerDistributionBnManAuto.close();
        _streamControllerSortingBnManAuto.close();
        _streamControllerDistributionTxtManAuto.close();
        _streamControllerSortingTxtManAuto.close();
        break;
    }
  }

  Future<void> _getServerData() async {
    switch (widget.stationName) {
      case Station.distribution:
        final response = await http.get(url('station1Control'));
        final stnData = json.decode(response.body);
        final systemPower = stnData["system_on"] == "true" ? true : false;
        final manualStepNo = stnData["manual_step_number"] as String;
        final systemMode = stnData["manual_mode"] == "true"
            ? MachineMode.manual
            : MachineMode.auto;
        machineModeDistribution = systemMode;

        // print('DISTRIBUTION POWER: \t$systemPower');
        // print('DISTRIBUTION MODE: \t$systemMode');
        _streamControllerDistributionPower.sink.add(systemPower);
        _streamControllerDistributionManAuto.sink.add(systemMode);
        _streamControllerDistributionBnManAuto.sink.add(systemMode);
        _streamControllerDistributionTxtManAuto.sink.add(manualStepNo);
        _streamControllerDistribution.sink.add(response);
        break;
      case Station.sorting:
        final response = await http.get(url('station2Control'));
        final stnData = json.decode(response.body);
        final systemPower = stnData["system_on"] == "true" ? true : false;
        final manualStepNo = stnData["manual_step_number"] as String;
        final systemMode = stnData["manual_mode"] == "true"
            ? MachineMode.manual
            : MachineMode.auto;
        machineModeSorting = systemMode;

        _streamControllerSortingPower.sink.add(systemPower);
        _streamControllerSortingManAuto.sink.add(systemMode);
        _streamControllerSortingBnManAuto.sink.add(systemMode);
        _streamControllerSortingTxtManAuto.sink.add(manualStepNo);
        _streamControllerSorting.sink.add(response);
        break;
      case Station.all:
        final response = await http.get(url('stationAllControl'));
        final stnData = json.decode(response.body);
        final systemPower = stnData["system_on"] == "true" ? true : false;
        // print('ALL POWER: \t$systemPower');
        _streamControllerAllPower.sink.add(systemPower);
        _streamControllerAll.sink.add(response);
        break;
    }
  }

  Widget _streamPower({
    required double width,
    required double height,
    required Stream stream,
  }) =>
      StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center();
          }
          bool stationPower = snapshot.data as bool;
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: stationPower ? Colors.green : ControlPanel._offColor,
                border: Border.all(
                  color: ControlPanel._offColor,
                ),
                shape: BoxShape.circle),
          );
        },
      );

  Widget _streamManualAuto({
    required double width,
    required double height,
    required Stream stream,
  }) =>
      StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center();
            }
            MachineMode machineMode = snapshot.data as MachineMode;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _autoManualDisplay(
                  width: width,
                  height: height,
                  text: 'Auto',
                  dividerColor: Theme.of(context).primaryColor,
                  isActive: machineMode == MachineMode.auto ? true : false,
                ),
                _autoManualDisplay(
                  width: width,
                  height: height,
                  text: 'Manual',
                  dividerColor: Theme.of(context).primaryColor,
                  isActive: machineMode == MachineMode.manual ? true : false,
                ),
              ],
            );
          });

  Widget _streamManAutoBn({
    required Map<String, double> bnDimensions,
    required Stream stream,
  }) =>
      StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center();
            }
            MachineMode machineMode = snapshot.data as MachineMode;
            return _controlBn(
              dimension: bnDimensions,
              text:
                  'SWITCH\n${machineMode == MachineMode.auto ? 'MANUAL' : 'AUTO'}',
              onTap: _manualAutoPressed,
            );
          });

  @override
  Widget build(BuildContext context) {
    // todo HOW TO STREAM MONITOR THE SERVER AND CHANGE THE UI ACCORDINGLY

    return LayoutBuilder(
      builder: (context, cons) {
        Map<String, double> bnDimensions = {
          'width': widget.width * 0.35,
          'height': widget.height * 0.075,
        };
        return StreamBuilder(
            stream: widget.stationName == Station.distribution
                ? _streamControllerDistribution.stream
                : widget.stationName == Station.sorting
                    ? _streamControllerSorting.stream
                    : _streamControllerAll.stream,
            builder: (context, _) {
              if (_.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('Loading....'),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _controlBn(
                          dimension: bnDimensions,
                          text:
                              'START${(widget.stationName == Station.all) ? ' ALL' : ''}',
                          onTap: () => _startStopResetPressed('start'),
                        ),
                        _controlBn(
                          dimension: bnDimensions,
                          text:
                              'STOP${(widget.stationName == Station.all) ? ' ALL' : ''}',
                          onTap: () => _startStopResetPressed('stop'),
                        ),
                        // if (widget.stationName != Station.all)
                        _controlBn(
                          dimension: bnDimensions,
                          text:
                              'RESET${(widget.stationName == Station.all) ? ' ALL' : ''}',
                          onTap: () => _startStopResetPressed('reset'),
                        ),

                        if (widget.stationName == Station.distribution)
                          _streamManAutoBn(
                            bnDimensions: bnDimensions,
                            stream:
                                _streamControllerDistributionBnManAuto.stream,
                          ),
                        if (widget.stationName == Station.sorting)
                          _streamManAutoBn(
                            bnDimensions: bnDimensions,
                            stream: _streamControllerSortingBnManAuto.stream,
                          ),
                      ]),
                  Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (widget.stationName != Station.all)
                            SizedBox(height: cons.maxHeight * 0.075 * 0.5),
                          if (widget.stationName == Station.all)
                            SizedBox(height: cons.maxHeight * 0.2),
                          const Text('POWER'),
                          if (widget.stationName == Station.distribution)
                            _streamPower(
                                width: cons.maxWidth * 0.5,
                                height: (widget.stationName == Station.all)
                                    ? cons.maxHeight * 0.45
                                    : cons.maxHeight * 0.35,
                                stream:
                                    _streamControllerDistributionPower.stream),
                          if (widget.stationName == Station.sorting)
                            _streamPower(
                                width: cons.maxWidth * 0.5,
                                height: (widget.stationName == Station.all)
                                    ? cons.maxHeight * 0.45
                                    : cons.maxHeight * 0.35,
                                stream: _streamControllerSortingPower.stream),
                          if (widget.stationName == Station.all)
                            _streamPower(
                                width: cons.maxWidth * 0.5,
                                height: (widget.stationName == Station.all)
                                    ? cons.maxHeight * 0.45
                                    : cons.maxHeight * 0.35,
                                stream: _streamControllerAllPower.stream),
                        ],
                      ),
                      if (widget.stationName != Station.all &&
                          MediaQuery.of(context).size.height > 600)
                        SizedBox(height: cons.maxHeight * 0.075 * 0.5),
                      if (widget.stationName == Station.distribution)
                        _streamManualAuto(
                          width: cons.maxWidth,
                          height: cons.maxHeight,
                          stream: _streamControllerDistributionManAuto.stream,
                        ),
                      if (widget.stationName == Station.sorting)
                        _streamManualAuto(
                          width: cons.maxWidth,
                          height: cons.maxHeight,
                          stream: _streamControllerSortingManAuto.stream,
                        ),
                    ],
                  )
                ],
              );
            });
      },
    );
  }
}
