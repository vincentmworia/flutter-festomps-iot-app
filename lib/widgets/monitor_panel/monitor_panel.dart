import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../splash_screen.dart';
import '../../global/global_data.dart';
import '../../global/enum_data.dart';
import './image_view.dart';
import './stepper_view.dart';

class MonitorPanel extends StatefulWidget {
  const MonitorPanel(
    this.stationName, {
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);
  final Station stationName;
  final double width;
  final double height;

  @override
  State<MonitorPanel> createState() => _MonitorPanelState();
}

enum ViewMode {
  stepper,
  image,
}

class _MonitorPanelState extends State<MonitorPanel> {
  ViewMode _viewMode = ViewMode.stepper;

  Uri url(String station) => Uri.parse(
      '${GlobalData.mainEndpointUrl}/Stations/$station.json');

  final StreamController _stepDistribution = StreamController();
  final StreamController _stepSorting = StreamController();
  final StreamController _stepAll = StreamController();

  @override
  void initState() {
    super.initState();
    // todo adjust time to 10ms
    Timer.periodic(const Duration(milliseconds: GlobalData.iotUpdateTime), (timer) {
      _getServerData();
    });
  }

  Future<void> _getServerData() async {
    switch (widget.stationName) {
      case Station.distribution:
        final response = await http.get(url('station1Control'));
        final stnData = json.decode(response.body);
        final codeStepNo = stnData["code_step_number"] as String;
        _stepDistribution.sink.add(codeStepNo);
        break;
      case Station.sorting:
        final response = await http.get(url('station2Control'));
        final stnData = json.decode(response.body);
        final codeStepNo = stnData["code_step_number"] as String;
        _stepSorting.sink.add(codeStepNo);
        break;
      case Station.all:
        final response = await http.get(url('stationAllControl'));
        final stnData = json.decode(response.body);
        final codeStepNo = stnData["code_step_number"] as String;
        _stepAll.sink.add(codeStepNo);
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    switch (widget.stationName) {
      case Station.distribution:
        _stepSorting.close();
        _stepAll.close();
        break;
      case Station.sorting:
        _stepDistribution.close();
        _stepAll.close();
        break;
      case Station.all:
        _stepDistribution.close();
        _stepSorting.close();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Workpiece workpiece = Workpiece.black;
    return StreamBuilder(
        stream: widget.stationName == Station.distribution
            ? _stepDistribution.stream
            : widget.stationName == Station.sorting
                ? _stepSorting.stream
                : _stepAll.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          final step = snapshot.data as String;
          final currentStep = int.parse(step);

          return Stack(
            children: [
              if (_viewMode == ViewMode.image)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        StepperView(currentStep, widget.stationName, workpiece))
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageView(currentStep, widget.stationName,
                      widget.width, widget.height, workpiece),
                ),
              GestureDetector(
                onDoubleTap: () {
                  setState(
                    () => _viewMode == ViewMode.stepper
                        ? _viewMode = ViewMode.image
                        : _viewMode = ViewMode.stepper,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.width * 0.075),
                    // color: Theme.of(context).primaryColor.withOpacity(0.1), todo
                  ),
                ),
              ),
            ],
          );
        });
  }
}
