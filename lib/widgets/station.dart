import 'package:flutter/material.dart';

import '../global/enum_data.dart';
import './control_panel.dart';
import './monitor_panel.dart';

class StationPage extends StatelessWidget {
  const StationPage(this.stationName, {Key? key}) : super(key: key);
  final Station stationName;

  Widget _cardView(
          {required double width,
          required double height,
          required Color backgroundColor,
          required Widget child}) =>
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.075),
        ),
        elevation: 8,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width * 0.075),
            color: backgroundColor,
          ),
          child: child,
        ),
      );

  Widget _headerText({
    required double textHeight,
    required String title,
    required Color color,
  }) =>
      SizedBox(
        width: double.infinity,
        height: textHeight,
        child: Center(
            child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 22.0, letterSpacing: 2.0),
        )),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: LayoutBuilder(builder: (context, cnt) {
        final dataWidth = cnt.maxWidth;
        final dataHeight = cnt.maxHeight;
        final cardHeight = dataHeight * 0.4;
        final textHeight = dataHeight * 0.0675 * 0.5;
        const cardBackgroundClr = Colors.white;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: dataWidth,
              height: dataHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _headerText(
                      textHeight: textHeight,
                      title: 'MONITOR PANEL',
                      color: Theme.of(context).primaryColor),
                  _cardView(
                    width: dataWidth,
                    height: cardHeight,
                    backgroundColor: cardBackgroundClr,
                    child: MonitorPanel(
                      stationName == Station.distribution
                          ? Station.distribution
                          : stationName == Station.sorting
                              ? Station.sorting
                              : Station.all,
                    ),
                  ),
                  _headerText(
                      textHeight: textHeight,
                      title: 'CONTROL PANEL',
                      color: Theme.of(context).primaryColor),
                  _cardView(
                    width: dataWidth,
                    height: cardHeight,
                    backgroundColor: cardBackgroundClr,
                    child: ControlPanel(
                      width: cnt.maxWidth,
                      height: cnt.maxHeight,
                      stationName: stationName == Station.distribution
                          ? Station.distribution
                          : stationName == Station.sorting
                              ? Station.sorting
                              : Station.all,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

/*

   Container(
                            width: cts.maxWidth * 0.05,
                            height: cts.maxHeight,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(
                                cnt.maxWidth * 0.05,
                              ),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                            ),
                          ),

*/
