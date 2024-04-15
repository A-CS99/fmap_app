import 'package:flutter/material.dart';
import '/funcs.dart';
import '/const.dart';
import '/paint.dart';
import '/types.dart';

class MapPage extends StatelessWidget {
  final List<Point> showPoints;

  const MapPage(this.showPoints, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MapCanvas(showPoints),
    );
  }
}

class MapCanvas extends StatelessWidget {
  final List<Point> showPoints;

  const MapCanvas(this.showPoints, {super.key});

  @override
  Widget build(BuildContext context) {
    consoleLog('showPoints: $showPoints');
    return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: mapSize.width,
              height: mapSize.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/imgs/map.jpg'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0, 
            child: CustomPaint(
              size: Size(mapSize.width, mapSize.height),
              painter: MyPainter(showPoints),
            ),
          ),
        ],
      );
  }
}