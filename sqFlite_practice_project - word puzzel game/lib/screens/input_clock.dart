import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sqflite_practice_project/screens/gridViewGameLevel.dart';

final word = ["W", "O", "N"];
final wordList = ["WON", "OWN", "NOW"];

class ClockInputPart extends StatefulWidget {
  final int miniCircleCount;
  void Function(String word) callBackFunction;

  ClockInputPart(
      {required this.miniCircleCount, required this.callBackFunction});

  @override
  State<ClockInputPart> createState() => _ClockInputPartState();
}

class _ClockInputPartState extends State<ClockInputPart>
    with TickerProviderStateMixin {
  late AnimationController _shuffleController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shuffleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
    );
  }

  @override
  void dispose() {
    _shuffleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            Positioned.fill(
              child: RotationTransition(
                  turns: _shuffleController,
                  child: MiniCircles(
                      miniCircleCount: widget.miniCircleCount,
                      callBackFunction: widget.callBackFunction)),
            ),
            Positioned(
              child: Center(
                child: RotationTransition(
                  turns: _shuffleController,
                  child: IconButton(
                    icon: Icon(Icons.shuffle),
                    onPressed: () {
                      _shuffleMiniCircles();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shuffleMiniCircles() {
    _shuffleController.forward(from: 0.0);
    setState(() {
      word.shuffle();
    });
    print("Shuffle button clicked!");
  }
}

class MiniCircles extends StatefulWidget {
  final int miniCircleCount;
  void Function(String word) callBackFunction;

  MiniCircles({required this.miniCircleCount, required this.callBackFunction});

  @override
  State<MiniCircles> createState() => _MiniCirclesState();
}

class _MiniCirclesState extends State<MiniCircles> {
  List<int> activatedCircles = [];
  List<Offset> connectionPoints = [];
  List<String> matchedResults = [];
  int? activeCircleIndex;

  @override
  Widget build(BuildContext context) {
    final circleRadius = 125.0;
    final miniCircleRadius = circleRadius / 4;
    final miniCircleGap = circleRadius / 3.5;

    return GestureDetector(
      onPanDown: (details) {
        _handlePanStart(details.localPosition);
      },
      onPanUpdate: (details) {
        _handlePanUpdate(details.localPosition);
      },
      onPanEnd: (details) {
        _handlePanEnd(widget.callBackFunction);
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: CircleAvatar(
                radius: miniCircleRadius,
              ),
            ),
          ),
          ...List.generate(widget.miniCircleCount, (index) {
            final angle = (2 * pi * index) / widget.miniCircleCount;
            final dx =
                circleRadius + (circleRadius - miniCircleGap) * cos(angle);
            final dy =
                circleRadius + (circleRadius - miniCircleGap) * sin(angle);

            final isActive = activatedCircles.contains(index);

            return Positioned(
              left: dx - miniCircleRadius,
              top: dy - miniCircleRadius,
              child: GestureDetector(
                onTap: () {
                  activateMiniCircle(index);
                },
                onPanUpdate: (details) {
                  Offset touchPoint = details.localPosition - Offset(dx, dy);
                  if (touchPoint.distance <= miniCircleRadius) {
                    activateMiniCircle(index);
                  }
                },
                child: CircleAvatar(
                  radius: miniCircleRadius,
                  backgroundColor: isActive ? Colors.green : Colors.red,
                  child: Text(
                    word[index % word.length].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
            );
          }),
          CustomPaint(
            size: Size(2 * circleRadius, 2 * circleRadius),
            painter: CircleConnectionPainter(
              circleRadius: circleRadius,
              connectionPoints: connectionPoints,
            ),
          ),
        ],
      ),
    );
  }

  // void shuffleMiniCircles() {
  //   print("suffle clicked");
  //   setState(() {
  //     word.shuffle();
  //   });
  // }

  void activateMiniCircle(int index) {
    if (!activatedCircles.contains(index)) {
      setState(() {
        activatedCircles.add(index);
        activeCircleIndex = index;
      });
    }
  }

  // void _handlePanStart(Offset touchPoint) {
  //   final int closestIndex = _getClosestActiveMiniCircleIndex(touchPoint);
  //   ;

  //   if (!activatedCircles.contains(closestIndex)) {
  //     setState(() {
  //       activeCircleIndex = closestIndex;
  //       connectionPoints.add(_calculateFocusPoint(closestIndex));
  //       activateMiniCircle(closestIndex);
  //     });
  //   }
  // }

  void _handlePanStart(Offset touchPoint) {
    int? closestIndex;
    final double circleRadius = 125.0;
    final double miniCircleGap = circleRadius / 3.5;
    final double angleStep = 2 * pi / widget.miniCircleCount;

    for (int i = 0; i < widget.miniCircleCount; i++) {
      final double angle = (2 * pi * i) / widget.miniCircleCount;
      final double dx =
          circleRadius + (circleRadius - miniCircleGap) * cos(angle);
      final double dy =
          circleRadius + (circleRadius - miniCircleGap) * sin(angle);
      final Offset miniCircleOffset = Offset(dx, dy);

      final double distance = (touchPoint - miniCircleOffset).distance;
      if (distance <= circleRadius / 4) {
        closestIndex = i;
        break;
      }
    }

    if (closestIndex != null) {
      setState(() {
        activeCircleIndex = closestIndex;
        connectionPoints.add(_calculateFocusPoint(closestIndex!));
        activateMiniCircle(closestIndex!);
      });
    }
  }

  // void _handlePanUpdate(Offset touchPoint) {
  //   if (activeCircleIndex != null) {
  //     final int closestIndex = _getClosestActiveMiniCircleIndex(touchPoint);
  //     if (activeCircleIndex != closestIndex) {
  //       setState(() {
  //         activeCircleIndex = closestIndex;
  //         if (!activatedCircles.contains(closestIndex)) {
  //           connectionPoints.add(_calculateFocusPoint(closestIndex));
  //           activatedCircles.add(closestIndex);
  //         } else {}
  //       });
  //     }
  //   }
  // }
  void _handlePanUpdate(Offset touchPoint) {
    final double circleRadius = 125.0;
    final double miniCircleGap = circleRadius / 3.5;

    if (activeCircleIndex != null) {
      final double angleStep = 2 * pi / widget.miniCircleCount;
      int? closestIndex;

      for (int i = 0; i < widget.miniCircleCount; i++) {
        final double angle = (2 * pi * i) / widget.miniCircleCount;
        final double dx =
            circleRadius + (circleRadius - miniCircleGap) * cos(angle);
        final double dy =
            circleRadius + (circleRadius - miniCircleGap) * sin(angle);
        final Offset miniCircleOffset = Offset(dx, dy);

        final double distance = (touchPoint - miniCircleOffset).distance;
        if (distance <= circleRadius / 4) {
          closestIndex = i;
          break;
        }
      }

      if (closestIndex != null && activeCircleIndex != closestIndex) {
        setState(() {
          activeCircleIndex = closestIndex;
          if (!activatedCircles.contains(closestIndex)) {
            connectionPoints.add(_calculateFocusPoint(closestIndex!));
            activatedCircles.add(closestIndex);
          }
        });
      }
    }
  }

  void _handlePanEnd(void Function(String word) callBackFunction) {
    String result = activatedCircles
        .map((index) => word[index % word.length].toString())
        .join();
    setState(() {
      puzzelWord = result;
      callBackFunction(result);
    });

    print('Activated Circles in Order: $result');

    bool isMatched = false;
    for (int i = 0; i < wordList.length; i++) {
      if (result == wordList[i]) {
        isMatched = true;
        print('Matched with wordList\'s ${i + 1} element');
        matchedResults.add(result);
        print('All Matched results are: ${matchedResults}');

        break;
      }
    }

    if (!isMatched) {
      print('No match found in wordList');
    }

    setState(() {
      connectionPoints.clear();
      activeCircleIndex = null;
      activatedCircles.clear();
    });
  }

  // int _getClosestActiveMiniCircleIndex(Offset touchPoint) {
  //   final double circleRadius = 125.0;
  //   final double miniCircleGap = circleRadius / 3.5;
  //   final int numMiniCircles = widget.miniCircleCount;
  //   final double angleStep = 2 * pi / numMiniCircles;

  //   double minDistance = double.infinity;
  //   int closestIndex = 0;

  //   for (int i = 0; i < numMiniCircles; i++) {
  //     final double angle = (2 * pi * i) / numMiniCircles;
  //     final double dx =
  //         circleRadius + (circleRadius - miniCircleGap) * cos(angle);
  //     final double dy =
  //         circleRadius + (circleRadius - miniCircleGap) * sin(angle);
  //     final Offset miniCircleOffset = Offset(dx, dy);

  //     final double distance = (touchPoint - miniCircleOffset).distance;
  //     if (distance < minDistance) {
  //       minDistance = distance;
  //       closestIndex = i;
  //     }
  //   }

  //   return closestIndex;
  // }

  Offset _calculateFocusPoint(int index) {
    final double circleRadius = 125.0;
    final double miniCircleGap = circleRadius / 3.5;
    final double angle = (2 * pi * index) / widget.miniCircleCount;
    final double x = circleRadius + (circleRadius - miniCircleGap) * cos(angle);
    final double y = circleRadius + (circleRadius - miniCircleGap) * sin(angle);
    return Offset(x, y);
  }
}

class CircleConnectionPainter extends CustomPainter {
  final double circleRadius;
  final List<Offset> connectionPoints;

  CircleConnectionPainter({
    required this.circleRadius,
    required this.connectionPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    final path = Path();
    if (connectionPoints.isNotEmpty &&
        connectionPoints.length <= word.length + 1) {
      final startPoint = connectionPoints.first;
      path.moveTo(startPoint.dx, startPoint.dy);

      for (int i = 1; i < connectionPoints.length; i++) {
        final point = connectionPoints[i];
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
