import 'package:flutter/material.dart';

import '../../global/enum_data.dart';
import '../../global/monitor_data.dart';

class StepperView extends StatelessWidget {
  const StepperView(this.currentStep, this.stationName, this.workpiece,
      {Key? key})
      : super(key: key);
  final int currentStep;
  final Station stationName;
  final Workpiece? workpiece;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> distributionSteps = distributionData();
    List<Map<String, String>> sortingSteps = sortingData(workpiece!);
    List<Map<String, String>> allStationsSteps = allStationsData(workpiece!);

    return SingleChildScrollView(
      reverse: true,
      child: AnimatedContainer(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 300),
        height: currentStep == 9
            ? 760
            : currentStep == 8
            ? 700
            : currentStep == 7
            ? 650
            : currentStep == 6
            ? 600
            : currentStep == 5
            ? 550
            : currentStep == 4
            ? 480
            : currentStep == 3
            ? 450
            : currentStep == 2
            ? 375
            : currentStep == 1
            ? 320
            : currentStep == 0
            ? 250
            : 300,
        child: Stepper(
            type: StepperType.vertical,
            currentStep: currentStep,
            steps: [
              if (stationName == Station.distribution)
                ...distributionSteps.map(
                      (step) {
                    int id = int.parse((step['id'] as String));
                    // print(id);
                    return Step(
                      state: (currentStep < id)
                          ? StepState.indexed
                          : StepState.complete,
                      title: Text(step['title'] as String),
                      isActive: (currentStep == id) ? true : false,
                      // subtitle: Text(step['subtitle'] as String),
                      content: Text(step['content'] as String),
                    );
                  },
                ).toList(),
              if (stationName == Station.sorting)
                ...sortingSteps.map(
                      (step) {
                    int id = int.parse((step['id'] as String));
                    // print(id);
                    return Step(
                      state: (currentStep < id)
                          ? StepState.indexed
                          : StepState.complete,
                      title: Text(step['title'] as String),
                      isActive: (currentStep == id) ? true : false,
                      // subtitle: Text(step['subtitle'] as String),
                      content: Text(step['content'] as String),
                    );
                  },
                ).toList(),
              if (stationName == Station.all)
                ...allStationsSteps.map(
                      (step) {
                    int id = int.parse((step['id'] as String));
                    // print(id);
                    return Step(
                      state: (currentStep < id)
                          ? StepState.indexed
                          : StepState.complete,
                      title: Text(step['title'] as String),
                      isActive: (currentStep == id) ? true : false,
                      // subtitle: Text(step['subtitle'] as String),
                      content: Text(step['content'] as String),
                    );
                  },
                ).toList(),
            ]),
      ),
    );
  }
}
