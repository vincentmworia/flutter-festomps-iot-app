import 'package:flutter/material.dart';

import '../../global/enum_data.dart';
import '../../global/monitor_data.dart';

class ImageView extends StatelessWidget {
  const ImageView(this.currentStep, this.stationName, this.width, this.height,
      this.workpiece,
      {Key? key})
      : super(key: key);
  final int currentStep;
  final Station stationName;
  final double width;
  final double height;
  final Workpiece workpiece;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> data = stationName == Station.distribution
        ? distributionData():stationName == Station.sorting?
        sortingData(workpiece): allStationsData(workpiece);

    final imageUrl = data[currentStep]['imageUrl'] as String;
    return Center(
      child: Image(
        image: AssetImage(imageUrl),
        fit: BoxFit.contain,
        width: width,
        height: height,
      ),
    );
  }
}
