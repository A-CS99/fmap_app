import 'package:flutter/material.dart';
import 'package:fmap_app/funcs.dart';
import 'package:fmap_app/http.dart';

import '/types.dart';

class ListPage extends StatefulWidget {
  final List<Place> places;
  const ListPage(this.places, {super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final dropdownValues = [0, 30, 50, 80, 120, 150];
  final Map<int, String> dropdownValueMap = {0: '所有范围', 30: '30m', 50: '50m', 80: '80m', 120: '120m', 150: '150m'}; 
  Place dropdownPlace = Place(-1, '', GeoPoint(0, 0));
  int disRange = 0;
  bool showDetail = false;
  Place selectedPlace = Place(0, '', GeoPoint(0, 0));
  List<Place> listPlaces = [];

  void setSelectedPlace (Place place) {
    setState(() {
      selectedPlace = place;
      showDetail = true;
    });
  }

  void backToList() {
    setState(() {
      showDetail = false;
    });
  }

  void updatePlacesInRange() {
    if (dropdownPlace.id == -1 || disRange == 0) {
      setState(() {
        listPlaces = widget.places;
      });
      return;
    }
    myPost('/searchNearByPoint', [], {'centerId': dropdownPlace.id, 'range': disRange / 1000.0})
      .then((res) {
        List resList = res['data'];
        resList.sort((a, b) => (a['distance'] as double).compareTo(b['distance']));
        consoleLog('resList: $resList');
        setState(() {
          listPlaces = resList.map<Place>((e) => Place(e['id'], e['name'], GeoPoint(e['x'], e['y']))).toList();
        });
      });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      listPlaces = widget.places;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showDetail) {
      return ListDetail(selectedPlace, backToList);
    }
    final dropdownPlacesItems = widget.places.map<DropdownMenuItem<int>>(
      (e) => DropdownMenuItem<int>(
        value: e.id, 
        child: Text(e.name)
      )
    ).toList();
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton(
                value: dropdownPlace.id, 
                items: [const DropdownMenuItem<int>(
                  value: -1,
                  child: Text('请选择所在地')
                )] + dropdownPlacesItems,
                onChanged: (int? id) {
                  if (id == null || id == -1) {
                    setState(() {
                      dropdownPlace = Place(-1, '请选择所在地', GeoPoint(0, 0));
                    });
                    updatePlacesInRange();
                    return;
                  }
                  final Place place = widget.places.firstWhere((e) => e.id == id);
                  setState(() {
                    dropdownPlace = place;
                    updatePlacesInRange();
                  });
                }
              ),
              DropdownButton(
                value: disRange, 
                items: dropdownValues.map<DropdownMenuItem<int>>(
                  (e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text(dropdownValueMap[e]!)
                  )).toList(), 
                onChanged: (int? value) {
                  if (value == null) return;
                  setState(() {
                    disRange = value;
                  });
                  updatePlacesInRange();
                }
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: listPlaces.length,
              itemBuilder: (context, index) {
                return ListCard(listPlaces[index], setSelectedPlace);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  final Place place;
  final Function setSelectedPlace;

  const ListCard(this.place, this.setSelectedPlace, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        child: ListTile(
          title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text('(${place.geoPoint.longitude}, ${place.geoPoint.latitude})'),
        ),
        onPressed: () {
          setSelectedPlace(place);
        },
      ),
    );
  }
}

class ListDetail extends StatefulWidget {
  final Place place;
  final Function backToList;

  const ListDetail(this.place, this.backToList, {super.key});

  @override
  State<ListDetail> createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  String info = '';

  @override
  void initState() {
    super.initState();
    myGet('/info', [{'placeId': widget.place.id.toString()}])
      .then((res) {
        setState(() {
          info = res['data']['info'];
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Text(widget.place.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 32),),
              Text('(${widget.place.geoPoint.longitude}, ${widget.place.geoPoint.latitude})'),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(info),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        widget.backToList();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50],
                        foregroundColor: Colors.blue[900],
                      ),
                      child: const Text('返回列表'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}