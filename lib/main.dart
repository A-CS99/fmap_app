import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'pages/map.dart';
import 'pages/list.dart';
import 'funcs.dart';
import 'http.dart';
import 'const.dart';
import 'types.dart';
import 'bar.dart';

enum ShowPointType {
  none,
  places,
  all,
}

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
  List<Point> points = [];
  List<Point> showPoints = [];
  List<GeoPoint> pathPoints = [];
  bool showBottomBar = true;
  ShowPointType showPointType = ShowPointType.none;

  void setShowBottomBar(bool show) {
    setState(() {
      showBottomBar = show;
    });
  }

  void switchShowPointType() {
    setState(() {
      String toastMsg = '';
      switch(showPointType) {
        case ShowPointType.none:
          showPointType = ShowPointType.places;
          toastMsg = '显示景点';
          break;
        case ShowPointType.places:
          showPointType = ShowPointType.all;
          toastMsg = '显示所有点（包括路径点）';
          break;
        case ShowPointType.all:
          showPointType = ShowPointType.none;
          toastMsg = '隐藏所有点';
          break;
      }
      updateShowPoints();
      Fluttertoast.showToast(
        msg: toastMsg, 
        toastLength: Toast.LENGTH_SHORT, 
        gravity: ToastGravity.CENTER, 
        timeInSecForIosWeb: 1, 
        backgroundColor: Colors.blue, 
        textColor: Colors.white, 
        fontSize: 16.0
      );
    });
  }

  void updateShowPoints () {
    List<Point> showPointsTemp = [];
    if(showPointType == ShowPointType.none) {
      showPointsTemp = [];
    } else if (showPointType == ShowPointType.places) {
      showPointsTemp = places.map((e) => Point(e.id, e.id, e.geoPoint)).toList();
    } else {
      showPointsTemp = points;
    }
    setState(() {
      showPoints = showPointsTemp;
    });
  }

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
      myGet('/allPoints', []).then((res) {
          final List<Point> resPoints = res['data'].map<Point>((e) => 
            Point(e['id'], e['placeId'], GeoPoint(e['x'], e['y']))
          ).toList();
          setState(() {
            points = resPoints;
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
    final mapHeight = screenSize.width / mapImgSize.width * mapImgSize.height;
    mapSize = (width: mapWidth, height: mapHeight);

    consoleLog('mapWidth: $mapWidth, mapHeight: $mapHeight');
    consoleLog('places: $places');
    
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: MyAppBar(setShowBottomBar),
          body: TabBarView(
            children: [
              MapPage(showPoints),
              ListPage(places),
            ],
          ),
          bottomNavigationBar: BottomBar(showBottomBar, switchShowPointType),
          floatingActionButton: showBottomBar ? FloatingActionButton(
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
              onPressed: () {},
              child: const Icon(Icons.navigation_outlined, color: Colors.white,),
          ) : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, //悬浮按钮位置
        ),
      ),
    );
  }
}