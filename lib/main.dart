import 'package:flutter/material.dart';
import 'funcs.dart';
import 'http.dart';
import 'paint.dart';
import 'const.dart';
import 'types.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();  
}

class _MainAppState extends State<MainApp> {
  List<Place> places = [];

  @override
  void initState() {
    super.initState();

    try {
      myGet('/allPlaces', []).then((res) 
        {
            final List<Place> resPlaces = res['data'].map<Place>((e) => 
              Place(e['id'], e['name'], GeoPoint(e['x'], e['y']))
            ).toList();
            setState(() {
              places = resPlaces;
            });
        }
      );
    } catch (e) {
      consoleLog('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final mapWidth = screenSize.width;
    final mapHeight = screenSize.width / mapSize.width * mapSize.height;

    consoleLog('mapWidth: $mapWidth, mapHeight: $mapHeight');
    consoleLog('places: $places');
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text( '数据结构课程设计——地图导航$places', style: TextStyle(fontSize: 18)),
        ),
        body: Center(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: mapWidth,
                  height: mapHeight,
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
                  size: Size(mapWidth, mapHeight),
                  painter: MyPainter(places),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}