import 'dart:async';

import 'package:flutter/material.dart';
import 'pages/map.dart';
import 'pages/list.dart';
import 'funcs.dart';
import 'http.dart';
import 'types.dart';
import 'bar.dart';

enum ShowPointType {
  none,
  places,
  all,
  tsp,
  nav,
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
  NavPlaces navPlaces = NavPlaces.wait();
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
        case ShowPointType.tsp:
          showPointType = ShowPointType.none;
          toastMsg = '关闭TSP路径';
          setState(() {
            pathPoints = [];
          });
          break;
        case ShowPointType.nav:
          showPointType = ShowPointType.none;
          toastMsg = '关闭导航';
          setState(() {
            pathPoints = [];
          });
          break;
      }
      updateShowPoints();
      showToast(toastMsg);
    });
  }

  void updateShowPoints () {
    List<Point> showPointsTemp = [];
    switch(showPointType) {
      case ShowPointType.none:
        showPointsTemp = [];
        break;
      case ShowPointType.places:
        showPointsTemp = places.map((e) => Point(e.id, e.id, e.geoPoint)).toList();
        break;
      case ShowPointType.all:
        showPointsTemp = points;
        break;
      case ShowPointType.tsp:
        Place startPlace = navPlaces.from;
        showPointsTemp = [Point(startPlace.id, startPlace.id, startPlace.geoPoint)];
        break;
      case ShowPointType.nav:
        Place startPlace = navPlaces.from;
        Place endPlace = navPlaces.to;
        showPointsTemp = [Point(startPlace.id, startPlace.id, startPlace.geoPoint), Point(endPlace.id, endPlace.id, endPlace.geoPoint)];
        break;
    }
    setState(() {
      showPoints = showPointsTemp;
    });
  }

  void searchTSP() {
    // 请输入起点名称
    if (places.isEmpty) {
      showToast('请先获取景点数据');
      return;
    }
    if (showPointType == ShowPointType.tsp) {
      switchShowPointType();
      return ;
    }
    if (navPlaces.from.id == -1) {
      showToast('请选择TSP起点');
      return;
    }
    setState(() {
      showPointType = ShowPointType.tsp;
      setState(() {
        showPoints = places.map((e) => Point(e.id, e.id, e.geoPoint)).toList();
      });
    });
    showToast('搜索TSP路径');
    final startId = navPlaces.from.id;
    myGet('/TSP', [{'id': startId.toString()}]).then((res) {
      final List<GeoPoint> resPathPoints = res['data']['path'].map<GeoPoint>((e) => GeoPoint(e['x'], e['y'])).toList();
      int i = 2;
      Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {
          pathPoints = resPathPoints.getRange(0, i).toList();
        });
        i++;
        if (i > resPathPoints.length) {
          timer.cancel();
          showToast('TSP路径搜索成功, 路径长度: ${res['data']['distance']*1000}m');
        }
       });
    });
  }

  void navigate() {
    if (showPointType == ShowPointType.nav || showPointType == ShowPointType.tsp) {
      switchShowPointType();
      return ;
    }
    if (navPlaces.from.id == -1 || navPlaces.to.id == -1) {
      showToast('请选择起点和终点');
      return;
    }
    setState(() {
      showPointType = ShowPointType.nav;
      updateShowPoints();
    });
    myPost('/navigate', [], {
      'from': {
        'id': navPlaces.from.id,
        'name': navPlaces.from.name,
        'x': navPlaces.from.geoPoint.longitude,
        'y': navPlaces.from.geoPoint.latitude,
      },
      'to': {
        'id': navPlaces.to.id,
        'name': navPlaces.to.name,
        'x': navPlaces.to.geoPoint.longitude,
        'y': navPlaces.to.geoPoint.latitude,
      },
    }).then((res) {
      showToast('开始导航, 路径长度: ${res['data']['distance']*1000}m');
      final List<GeoPoint> resPathPoints = res['data']['path'].map<GeoPoint>((e) => GeoPoint(e['x'], e['y'])).toList();
      int i = 2;
      Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {
          pathPoints = resPathPoints.getRange(0, i).toList();
        });
        i++;
        if (i > resPathPoints.length) {
          timer.cancel();
        }
       });
    });
  }

  void setNavPlaces(Place from, Place to) {
    setState(() {
      navPlaces = NavPlaces(from, to);
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
      ).catchError((e) {
        consoleLog('error: $e');
      });
      myGet('/allPoints', []).then((res) {
          final List<Point> resPoints = res['data'].map<Point>((e) => 
            Point(e['id'], e['placeId'], GeoPoint(e['x'], e['y']))
          ).toList();
          setState(() {
            points = resPoints;
          });
        }
      ).catchError((e) {
        consoleLog('error: $e');
      });
    } catch (e) {
      consoleLog('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: MyAppBar(setShowBottomBar),
          body: TabBarView(
            children: [
              MapPage(places, showPoints, pathPoints, navPlaces, setNavPlaces),
              ListPage(places),
            ],
          ),
          bottomNavigationBar: BottomBar(showBottomBar, switchShowPointType, searchTSP),
          floatingActionButton: showBottomBar ? FloatingActionButton(
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
              onPressed: navigate,
              child: const Icon(Icons.navigation_outlined, color: Colors.white, size: 32,),
          ) : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, //悬浮按钮位置
        ),
      ),
    );
  }
}