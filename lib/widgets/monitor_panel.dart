import 'package:flutter/material.dart';

import '../global/enum_data.dart';

class MonitorPanel extends StatefulWidget {
  const MonitorPanel(this.stationName, {Key? key}) : super(key: key);
  final Station stationName;

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

  static const Map<String, Map<String, String>> distributionData = {
    '0': {'title': 'STOP', 'subtitle': 'Distribution Station Off', 'content': ''},
    '9': {'title': 'RESET', 'subtitle': 'Reset Button Pressed!', 'content': ''},
    '1': {'title': 'STEP ONE', 'subtitle': 'Waiting for W/p in Magazine', 'content': '', 'imageUrl': 'assets/images/distribution/step1.PNG'},
    '2': {'title': 'STEP TWO', 'subtitle': 'Extending Feed Cylinder', 'content': '', 'imageUrl': 'assets/images/distribution/step2.PNG'},
    '3': {'title': 'STEP THREE', 'subtitle': 'Retracting Feed Cylinder', 'content': ''},
    '4': {'title': 'STEP FOUR', 'subtitle': 'Conveyor Moving...', 'content': ''},
    '5': {'title': 'STEP FIVE', 'subtitle': 'Block Cylinder Opened', 'content': ''},
    '6': {'title': 'STEP SIX', 'subtitle': 'Waiting for w/p to reach station 2', 'content': ''},
    '7': {'title': 'STEP SEVEN', 'subtitle': 'W/p at station 2', 'content': ''},
    '8': {'title': 'STEP EIGHT', 'subtitle': 'Cycle Complete', 'content': ''},
  };
  static const Map<String, Map<String, String>> sortingData = {
    '0': {'title': 'STOP', 'subtitle': 'Sorting Station Off', 'content': '', 'imageUrl': ''},
    '1': {'title': 'RESET', 'subtitle': 'Reset Button Pressed!', 'content': ''},
    '2': {'title': 'STEP ONE', 'subtitle': 'Station 2 Ready', 'content': ''},
    '3': {'title': 'STEP TWO', 'subtitle': 'Conveyor moving...', 'content': ''},
    '4': {'title': 'STEP THREE', 'subtitle': 'Sorting Black w/p', 'content': ''},
    '5': {'title': 'STEP THREE', 'subtitle': 'Sorting Red w/p', 'content': ''},
    '6': {'title': 'STEP THREE', 'subtitle': 'Sorting Metallic w/p', 'content': ''},
    '7': {'title': 'STEP FOUR', 'subtitle': 'Stopper Retracted', 'content': ''},
    '8': {'title': 'STEP FIVE', 'subtitle': 'Cycle Complete', 'content': ''},
    '9': {'title': 'ALERT!', 'subtitle': 'SLIDER FULL!!!', 'content': ''},
  };

  @override
  Widget build(BuildContext context) {
    _currentStep = 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          _viewMode == ViewMode.stepper
              ? SingleChildScrollView(
                  reverse: true,
                  child: AnimatedContainer(
                    alignment: Alignment.topCenter,
                    duration: const Duration(milliseconds: 300),
                    height: _currentStep == 4
                        ? 500
                        : _currentStep == 3
                            ? 450
                            : _currentStep == 2
                                ? 375
                                : _currentStep == 1
                                    ? 320
                                    : _currentStep == 0
                                        ? 250
                                        : 300,
                    child: Stepper(
                        type: StepperType.vertical,
                        currentStep: _currentStep,
                        steps: [
                          Step(
                              state: (_currentStep < 1)
                                  ? StepState.indexed
                                  : StepState.complete,
                              title: const Text("STEP ONE"),
                              isActive: (_currentStep == 0) ? true : false,
                              subtitle: const Text("Brief Explanation"),
                              content: const Text("Let's begin...")),
                          Step(
                              state: (_currentStep < 2)
                                  ? StepState.indexed
                                  : StepState.complete,
                              title: const Text("STEP TWO"),
                              subtitle: const Text("Brief Explanation"),
                              isActive: (_currentStep == 1) ? true : false,
                              content: const Text("Ok, just a little more...")),
                          Step(
                              state: (_currentStep < 3)
                                  ? StepState.indexed
                                  : StepState.complete,
                              title: const Text("STEP THREE"),
                              subtitle: const Text("Brief Explanation"),
                              isActive: (_currentStep == 2) ? true : false,
                              content: const Text("Ok, just a little more...")),
                          Step(
                              state: (_currentStep < 4)
                                  ? StepState.indexed
                                  : StepState.complete,
                              title: const Text("STEP FOUR"),
                              subtitle: const Text("Brief Explanation"),
                              isActive: (_currentStep == 3) ? true : false,
                              content: const Text("Ok, just a little more...")),
                          Step(
                            state: (_currentStep < 5)
                                ? StepState.indexed
                                : StepState.complete,
                            title: const Text("STEP FIVE"),
                            subtitle: const Text("Brief Explanation"),
                            isActive: (_currentStep == 4) ? true : false,
                            content: const Text("And, we're done!"),
                          ),
                        ]),
                  ),
                )
              : const Center(
                  child: Text('IMAGE VIEW'),
                ),
          GestureDetector(
              onDoubleTap: () {
                setState(
                  () => _viewMode == ViewMode.stepper
                      ? _viewMode = ViewMode.image
                      : _viewMode = ViewMode.stepper,
                );
                print(_viewMode);
              },
              child: Container(
                color: Colors.black.withOpacity(0.0),
              )),
        ],
      ),
    );
  }
}
