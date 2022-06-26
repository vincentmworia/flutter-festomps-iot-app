import 'package:flutter/material.dart';

import '../global/enum_data.dart';
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
  var _currentStep = 0; // todo Provider to change steps
  ViewMode _viewMode = ViewMode.stepper;

  @override
  Widget build(BuildContext context) {
    const stepDistribution = 2;
    const stepSorting = 1;
    const stepAllStations = 4;
    _currentStep = widget.stationName == Station.distribution
        ? stepDistribution
        : widget.stationName == Station.sorting
            ? stepSorting
            : stepAllStations;
    Workpiece workpiece = Workpiece.black;
    return Stack(
      children: [
        if (_viewMode == ViewMode.image)
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: StepperView(_currentStep, widget.stationName, workpiece))
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageView(_currentStep, widget.stationName, widget.width,
                widget.height, workpiece),
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
  }
}
