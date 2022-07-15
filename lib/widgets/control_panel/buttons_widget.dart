import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../providers/activate_button.dart';
import '../../global/enum_data.dart';
import '../../global/global_data.dart';

class ControlBns extends StatefulWidget {
  const ControlBns({
    Key? key,
    required this.streamController,
    required this.controlBn,
    required this.bnDimensions,
    required this.stationName,
    required this.streamManAutoBn,
  }) : super(key: key);

  // final Function controlBn
  //
  // ({required Map<String, double> dimension,
  // required String text,
  // required Function() onTap});

  final Widget Function(
      {required Map<String, double> dimension,
      required String text,
      required Function() onTap,
      required bool activeBn}) controlBn;
  final Widget Function(
      {required Map<String, double> bnDimensions,
      required bool activeBn}) streamManAutoBn;
  final Map<String, double> bnDimensions;
  final Station stationName;
  final StreamController streamController;

  // static void manualAutoPressing(){
  //
  // }

  @override
  State<ControlBns> createState() => _ControlBnsState();
}

class _ControlBnsState extends State<ControlBns> {
  Uri url(String station) =>
      Uri.parse('${GlobalData.mainEndpointUrl}/Stations/control/$station.json');

  Future<void> _bnTrue() => Future.delayed(
        const Duration(milliseconds: GlobalData.activeBnDelayTime),
      ).then((_) => setState(() =>
          Provider.of<ActivateBn>(context, listen: false)
              .changeActiveBnStatus(true)));

  Future<void> _startStopResetPressed(String button) async {
    Provider.of<ActivateBn>(context, listen: false).changeActiveBnStatus(false);
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

  @override
  Widget build(BuildContext context) {
    final activeBn = Provider.of<ActivateBn>(context).bnStatus;
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          widget.controlBn(
              dimension: widget.bnDimensions,
              text: 'START${(widget.stationName == Station.all) ? ' ALL' : ''}',
              onTap: () => _startStopResetPressed('start'),
              activeBn: activeBn),
          widget.controlBn(
            dimension: widget.bnDimensions,
            activeBn: activeBn,
            text: 'STOP${(widget.stationName == Station.all) ? ' ALL' : ''}',
            onTap: () => _startStopResetPressed('stop'),
          ),
          widget.controlBn(
            dimension: widget.bnDimensions,
            activeBn: activeBn,
            text: 'RESET${(widget.stationName == Station.all) ? ' ALL' : ''}',
            onTap: () => _startStopResetPressed('reset'),
          ),
          // if (widget.stationName == Station.distribution)
          //   widget.streamManAutoBn(
          //     bnDimensions: widget.bnDimensions,
          //     activeBn: activeBn,
          //   ),
          // if (widget.stationName == Station.sorting)
          //   widget.streamManAutoBn(
          //     bnDimensions: widget.bnDimensions,
          //     activeBn: activeBn,
          //   ),
        ]);
  }
}
