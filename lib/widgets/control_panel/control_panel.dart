import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../splash_screen.dart';
import '../../global/enum_data.dart';
import '../../global/global_data.dart';
import './widget_functions.dart';

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

  static const offColor = Color.fromRGBO(12, 4, 4, 0.2);

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  var _activeBn = true;
  late MachineMode machineModeDistribution;
  late MachineMode machineModeSorting;
  late bool powerDistribution;
  late bool powerSorting;
  late bool powerAll;

  Uri url(String station) =>
      Uri.parse('${GlobalData.mainEndpointUrl}$station.json');

  // Streams Initialization
  final StreamController _streamControllerDistribution = StreamController();
  final StreamController _streamControllerSorting = StreamController();
  final StreamController _streamControllerAll = StreamController();
  final StreamController _streamControllerDistributionPower =
      StreamController();
  final StreamController _streamControllerSortingPower = StreamController();
  final StreamController _streamControllerAllPower = StreamController();
  final StreamController _streamControllerDistributionManualAuto =
      StreamController();
  final StreamController _streamControllerDistributionBnManAuto =
      StreamController();
  final StreamController _streamControllerSortingManualAuto =
      StreamController();
  final StreamController _streamControllerSortingBnManAuto = StreamController();
  final StreamController _streamControllerDistributionTxtManAuto =
      StreamController();
  final StreamController _streamControllerSortingTxtManAuto =
      StreamController();

  @override
  void initState() {
    super.initState();
    machineModeDistribution = MachineMode.auto;
    machineModeSorting = MachineMode.manual;
    powerDistribution = true;
    powerSorting = false;
    powerAll = false;

    Timer.periodic(const Duration(milliseconds: GlobalData.iotUpdateTime),
        (timer) {
      _getServerData();
    });
  }

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

  Future<void> _bnTrue() => Future.delayed(
        const Duration(milliseconds: GlobalData.activeBnDelayTime),
      ).then((_) => setState(() => _activeBn = true));

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
        final manualData = {
          'system_mode': systemMode,
          'manual_step_number': manualStepNo
        };
        _streamControllerDistributionPower.sink.add(systemPower);
        _streamControllerDistributionManualAuto.sink.add(manualData);
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
        final manualData = {
          'system_mode': systemMode,
          'manual_step_number': manualStepNo
        };
        _streamControllerSortingPower.sink.add(systemPower);
        _streamControllerSortingManualAuto.sink.add(manualData);
        _streamControllerSortingBnManAuto.sink.add(systemMode);
        _streamControllerSortingTxtManAuto.sink.add(manualStepNo);
        _streamControllerSorting.sink.add(response);
        break;
      case Station.all:
        final response = await http.get(url('stationAllControl'));
        final stnData = json.decode(response.body);
        final systemPower = stnData["system_on"] == "true" ? true : false;
        _streamControllerAllPower.sink.add(systemPower);
        _streamControllerAll.sink.add(response);
        break;
    }
  }

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
            final machineStateMode = snapshot.data as Map<String, dynamic>;
            MachineMode mcMode = machineStateMode['system_mode'] as MachineMode;
            final stp = machineStateMode['manual_step_number'] as String;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ControlWidget.autoManualDisplay(
                    width: width,
                    height: height,
                    text: 'Auto',
                    dividerColor: Theme.of(context).primaryColor,
                    isActive: mcMode == MachineMode.auto ? true : false,
                    step: stp),
                ControlWidget.autoManualDisplay(
                    width: width,
                    height: height,
                    text: 'Manual',
                    dividerColor: Theme.of(context).primaryColor,
                    isActive: mcMode == MachineMode.manual ? true : false,
                    step: stp)
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
                return const SplashScreen();
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
                            ControlWidget.streamPower(
                                width: cons.maxWidth * 0.5,
                                height: (widget.stationName == Station.all)
                                    ? cons.maxHeight * 0.45
                                    : cons.maxHeight * 0.35,
                                stream:
                                    _streamControllerDistributionPower.stream),
                          if (widget.stationName == Station.sorting)
                            ControlWidget.streamPower(
                                width: cons.maxWidth * 0.5,
                                height: (widget.stationName == Station.all)
                                    ? cons.maxHeight * 0.45
                                    : cons.maxHeight * 0.35,
                                stream: _streamControllerSortingPower.stream),
                          if (widget.stationName == Station.all)
                            ControlWidget.streamPower(
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
                          stream:
                              _streamControllerDistributionManualAuto.stream,
                        ),
                      if (widget.stationName == Station.sorting)
                        _streamManualAuto(
                          width: cons.maxWidth,
                          height: cons.maxHeight,
                          stream: _streamControllerSortingManualAuto.stream,
                        ),
                    ],
                  )
                ],
              );
            });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    switch (widget.stationName) {
      case Station.distribution:
        _streamControllerSorting.close();
        _streamControllerAll.close();
        _streamControllerSortingPower.close();
        _streamControllerAllPower.close();
        _streamControllerSortingManualAuto.close();
        _streamControllerSortingBnManAuto.close();
        _streamControllerSortingTxtManAuto.close();
        break;
      case Station.sorting:
        _streamControllerDistribution.close();
        _streamControllerAll.close();
        _streamControllerDistributionPower.close();
        _streamControllerAllPower.close();
        _streamControllerDistributionManualAuto.close();
        _streamControllerDistributionBnManAuto.close();
        _streamControllerDistributionTxtManAuto.close();
        break;
      case Station.all:
        _streamControllerDistribution.close();
        _streamControllerSorting.close();
        _streamControllerDistributionPower.close();
        _streamControllerSortingPower.close();
        _streamControllerDistributionManualAuto.close();
        _streamControllerSortingManualAuto.close();
        _streamControllerDistributionBnManAuto.close();
        _streamControllerSortingBnManAuto.close();
        _streamControllerDistributionTxtManAuto.close();
        _streamControllerSortingTxtManAuto.close();
        break;
    }
  }
}
