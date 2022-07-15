import './enum_data.dart';

List<Map<String, String>> distributionData() => [
      {
        'id': '0',
        'title': 'STOP',
        'subtitle': 'Distribution Station Off',
        'content': 'Distribution Station Off',
        'imageUrl': 'assets/images/distribution/step0.jpg'
      },
      {
        'id': '1',
        'title': 'RESET',
        'subtitle': 'Reset Button Pressed!',
        'content': 'Reset Button Pressed!',
        'imageUrl': 'assets/images/distribution/step9.jpg'
      },
      {
        'id': ' 2',
        'title': 'STEP ONE',
        'subtitle': 'Waiting for W/p in Magazine',
        'content': 'Waiting for W/p in Magazine',
        'imageUrl': 'assets/images/distribution/step1.PNG'
      },
      {
        'id': '3',
        'title': 'STEP TWO',
        'subtitle': 'Extending Feed Cylinder',
        'content': 'Extending Feed Cylinder',
        'imageUrl': 'assets/images/distribution/step2.PNG'
      },
      {
        'id': '4',
        'title': 'STEP THREE',
        'subtitle': 'Retracting Feed Cylinder',
        'content': 'Retracting Feed Cylinder',
        'imageUrl': 'assets/images/distribution/step3.PNG'
      },
      {
        'id': '5',
        'title': 'STEP FOUR',
        'subtitle': 'Conveyor Moving...',
        'content': 'Conveyor Moving...',
        'imageUrl': 'assets/images/distribution/step4.PNG'
      },
      {
        'id': '6',
        'title': 'STEP FIVE',
        'subtitle': 'Block Cylinder Opened',
        'content': 'Block Cylinder Opened',
        'imageUrl': 'assets/images/distribution/step5.PNG'
      },
      {
        'id': '7',
        'title': 'STEP SIX',
        'subtitle': 'Waiting for w/p to reach station 2',
        'content': 'Waiting for w/p to reach station 2',
        'imageUrl': 'assets/images/distribution/step6.PNG'
      },
      {
        'id': '8',
        'title': 'STEP SEVEN',
        'subtitle': 'W/p at station 2',
        'content': 'W/p at station 2',
        'imageUrl': 'assets/images/distribution/step7.PNG'
      },
      {
        'id': '9',
        'title': 'STEP EIGHT',
        'subtitle': 'Cycle Complete',
        'content': 'Cycle Complete',
        'imageUrl': 'assets/images/distribution/step8.PNG'
      },
    ];
// const Workpiece _workpiece = Workpiece.black;
List<Map<String, String>> sortingData(Workpiece workpiece) => [
      {
        'id': '0',
        'title': 'STOP',
        'subtitle': 'Sorting Station Off',
        'content': 'Sorting Station Off',
        'imageUrl': 'assets/images/distribution/step0.jpg'
      },
      {
        'id': '1',
        'title': 'RESET',
        'subtitle': 'Reset Button Pressed!',
        'content': 'Reset Button Pressed!',
        'imageUrl': 'assets/images/distribution/step9.jpg'
      },
      {
        'id': '2',
        'title': 'STEP ONE',
        'subtitle': 'Station 2 Ready',
        'content': 'Station 2 Ready',
        'imageUrl': 'assets/images/sorting/step1.PNG'
      },
      {
        'id': '3',
        'title': 'STEP TWO',
        'subtitle': 'Conveyor moving...',
        'content': 'Conveyor moving...',
        'imageUrl': 'assets/images/sorting/step2.PNG'
      },
      workpiece == Workpiece.black
          ? {
              'id': '4',
              'title': 'STEP THREE',
              'subtitle': 'Sorting Black w/p',
              'content': 'Sorting Black w/p',
              'imageUrl': 'assets/images/sorting/step3_black.PNG'
            }
          : workpiece == Workpiece.red
              ? {
                  'id': '4',
                  'title': 'STEP THREE',
                  'subtitle': 'Sorting Red w/p',
                  'content': 'Sorting Red w/p',
                  'imageUrl': 'assets/images/sorting/step3_red.PNG'
                }
              : workpiece == Workpiece.metallic
                  ? {
                      'id': '4',
                      'title': 'STEP THREE',
                      'subtitle': 'Sorting Metallic w/p',
                      'content': 'Sorting Metallic w/p',
                      'imageUrl': 'assets/images/sorting/step3_metallic.PNG'
                    }
                  : {
                      'id': '4',
                      'title': 'STEP THREE',
                      'subtitle': 'Unknown w/p',
                      'content': 'Unknown w/p',
                      'imageUrl': 'assets/images/sorting/step3_metallic.PNG'
                    },
      workpiece == Workpiece.black
          ? {
              'id': '5',
              'title': 'STEP FOUR',
              'subtitle': 'Stopper Retracted',
              'content': 'Stopper Retracted',
              'imageUrl': 'assets/images/sorting/step4_black.PNG'
            }
          : workpiece == Workpiece.red
              ? {
                  'id': '5',
                  'title': 'STEP FOUR',
                  'subtitle': 'Stopper Retracted',
                  'content': 'Stopper Retracted',
                  'imageUrl': 'assets/images/sorting/step4_red.PNG'
                }
              : {
                  'id': '5',
                  'title': 'STEP FOUR',
                  'subtitle': 'Stopper Retracted',
                  'content': 'Stopper Retracted',
                  'imageUrl': 'assets/images/sorting/step4_metallic.PNG'
                },
      {
        'id': '6',
        'title': 'STEP FIVE',
        'subtitle': 'Cycle Complete',
        'content': 'Cycle Complete',
        'imageUrl': 'assets/images/sorting/step5.PNG'
      },
      {
        'id': '7',
        'title': 'ALERT!',
        'subtitle': 'SLIDER FULL!!!',
        'content': 'SLIDER FULL!!!',
        'imageUrl': 'assets/images/distribution/step7.PNG'
      },
      {
        'id': '8',
        'title': 'STEP EIGHT',
        'subtitle': 'Cycle Complete',
        'content': 'Cycle Complete',
        'imageUrl': 'assets/images/distribution/step8.PNG'
      },
    ];

List<Map<String, String>> allStationsData(Workpiece workpiece) => [
      {
        'id': '0',
        'title': 'STOP',
        'subtitle': 'Distribution Station Off',
        'content': 'Distribution Station Off',
        'imageUrl': 'assets/images/distribution/step0.jpg'
      },
      {
        'id': '1',
        'title': 'RESET',
        'subtitle': 'Reset Button Pressed!',
        'content': 'Reset Button Pressed!',
        'imageUrl': 'assets/images/distribution/step9.jpg'
      },
      {
        'id': ' 2',
        'title': 'STEP ONE',
        'subtitle': 'Waiting for W/p in Magazine',
        'content': 'Waiting for W/p in Magazine',
        'imageUrl': 'assets/images/distribution/step1.PNG'
      },
      {
        'id': '3',
        'title': 'STEP TWO',
        'subtitle': 'Extending Feed Cylinder',
        'content': 'Extending Feed Cylinder',
        'imageUrl': 'assets/images/distribution/step2.PNG'
      },
      {
        'id': '4',
        'title': 'STEP THREE',
        'subtitle': 'Retracting Feed Cylinder',
        'content': 'Retracting Feed Cylinder',
        'imageUrl': 'assets/images/distribution/step3.PNG'
      },
      {
        'id': '5',
        'title': 'STEP FOUR',
        'subtitle': 'Conveyor Moving...',
        'content': 'Conveyor Moving...',
        'imageUrl': 'assets/images/distribution/step4.PNG'
      },
      {
        'id': '6',
        'title': 'STEP FIVE',
        'subtitle': 'Block Cylinder Opened',
        'content': 'Block Cylinder Opened',
        'imageUrl': 'assets/images/distribution/step5.PNG'
      },
      {
        'id': '7',
        'title': 'STEP SIX',
        'subtitle': 'Waiting for w/p to reach station 2',
        'content': 'Waiting for w/p to reach station 2',
        'imageUrl': 'assets/images/distribution/step6.PNG'
      },
      {
        'id': '8',
        'title': 'STEP SEVEN',
        'subtitle': 'W/p at station 2',
        'content': 'W/p at station 2',
        'imageUrl': 'assets/images/distribution/step7.PNG'
      },
      {
        'id': '9',
        'title': 'STEP EIGHT',
        'subtitle': 'Cycle Complete',
        'content': 'Cycle Complete',
        'imageUrl': 'assets/images/distribution/step8.PNG'
      },
      {
        'id': '10',
        'title': 'STOP',
        'subtitle': 'Sorting Station Off',
        'content': 'Sorting Station Off',
        'imageUrl': 'assets/images/distribution/step0.jpg'
      },
      {
        'id': '11',
        'title': 'RESET',
        'subtitle': 'Reset Button Pressed!',
        'content': 'Reset Button Pressed!',
        'imageUrl': 'assets/images/distribution/step9.jpg'
      },
      {
        'id': '12',
        'title': 'STEP ONE',
        'subtitle': 'Station 2 Ready',
        'content': 'Station 2 Ready',
        'imageUrl': 'assets/images/sorting/step1.PNG'
      },
      {
        'id': '13',
        'title': 'STEP TWO',
        'subtitle': 'Conveyor moving...',
        'content': 'Conveyor moving...',
        'imageUrl': 'assets/images/sorting/step2.PNG'
      },
      workpiece == Workpiece.black
          ? {
              'id': '14',
              'title': 'STEP THREE',
              'subtitle': 'Sorting Black w/p',
              'content': 'Sorting Black w/p',
              'imageUrl': 'assets/images/sorting/step3_black.PNG'
            }
          : workpiece == Workpiece.red
              ? {
                  'id': '14',
                  'title': 'STEP THREE',
                  'subtitle': 'Sorting Red w/p',
                  'content': 'Sorting Red w/p',
                  'imageUrl': 'assets/images/sorting/step3_red.PNG'
                }
              : workpiece == Workpiece.metallic
                  ? {
                      'id': '14',
                      'title': 'STEP THREE',
                      'subtitle': 'Sorting Metallic w/p',
                      'content': 'Sorting Metallic w/p',
                      'imageUrl': 'assets/images/sorting/step3_metallic.PNG'
                    }
                  : {
                      'id': '14',
                      'title': 'STEP THREE',
                      'subtitle': 'Unknown w/p',
                      'content': 'Unknown w/p',
                      'imageUrl': 'assets/images/sorting/step3_metallic.PNG'
                    },
      workpiece == Workpiece.black
          ? {
              'id': '15',
              'title': 'STEP FOUR',
              'subtitle': 'Stopper Retracted',
              'content': 'Stopper Retracted',
              'imageUrl': 'assets/images/sorting/step4_black.PNG'
            }
          : workpiece == Workpiece.red
              ? {
                  'id': '15',
                  'title': 'STEP FOUR',
                  'subtitle': 'Stopper Retracted',
                  'content': 'Stopper Retracted',
                  'imageUrl': 'assets/images/sorting/step4_red.PNG'
                }
              : {
                  'id': '15',
                  'title': 'STEP FOUR',
                  'subtitle': 'Stopper Retracted',
                  'content': 'Stopper Retracted',
                  'imageUrl': 'assets/images/sorting/step4_metallic.PNG'
                },
      {
        'id': '16',
        'title': 'STEP FIVE',
        'subtitle': 'Cycle Complete',
        'content': 'Cycle Complete',
        'imageUrl': 'assets/images/sorting/step5.PNG'
      },
      {
        'id': '17',
        'title': 'ALERT!',
        'subtitle': 'SLIDER FULL!!!',
        'content': 'SLIDER FULL!!!',
        'imageUrl': 'assets/images/distribution/step7.PNG'
      },
    ];
