import 'package:flutter/material.dart';

import '../global/enum_data.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    Key? key,
    required this.width,
    required this.height,
    required this.stationName,
  }) : super(key: key);
  final double width;
  final double height;
  final Station stationName;

  static const _offColor =  Color.fromRGBO(12, 4, 4, 0.2);

  Widget _controlBn(
          {required Map<String, double> dimension,
          required String text,
          required Function() onTap}) =>
      SizedBox(
        height: dimension['height'],
        width: dimension['width'],
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(text),
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
            Container(
              width: width * 0.2,
              height: height * 0.3,
              decoration: BoxDecoration(
                color: isActive ? Colors.deepOrange[400] :_offColor,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, cons) {
        Map<String, double> bnDimensions = {
          'width': width * 0.35,
          'height': height * 0.075,
        };
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                Widget>[
              _controlBn(dimension: bnDimensions, text: 'START', onTap: () {}),
              _controlBn(dimension: bnDimensions, text: 'STOP', onTap: () {}),
              _controlBn(dimension: bnDimensions, text: 'RESET', onTap: () {}),
              _controlBn(
                  dimension: bnDimensions,
                  text: 'SWITCH\nMANUAL',
                  onTap: () {}),
            ]),
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: cons.maxHeight * 0.075 * 0.5),
                    const Text('POWER'),
                    Container(
                      width: cons.maxWidth * 0.5,
                      height: cons.maxHeight * 0.35,
                      decoration: BoxDecoration(
                          // color: Colors.green, //todo POWER ON
                          color:_offColor,
                          border: Border.all(
                            color:_offColor,
                          ),
                          shape: BoxShape.circle),
                    ),
                  ],
                ),
                SizedBox(height: cons.maxHeight * 0.075 * 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _autoManualDisplay(
                      width: cons.maxWidth,
                      height: cons.maxHeight,
                      text: 'Auto',
                      dividerColor: Theme.of(context).primaryColor,
                      isActive: false,
                    ),
                    _autoManualDisplay(
                      width: cons.maxWidth,
                      height: cons.maxHeight,
                      text: 'Manual',
                      dividerColor: Theme.of(context).primaryColor,
                      isActive: true,
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
