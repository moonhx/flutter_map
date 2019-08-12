import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main()=>runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  List<LatLng> _points;

  @override
  void initState() {
    _points = <LatLng>[
      LatLng(51.5, -0.09),
      LatLng(53.3498, -6.2603),
      LatLng(48.8566, 2.3522),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'map_demo',
      home: MyMap()
    );
  }
}

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {

  List<LatLng> _points;

  @override
  void initState() {
    _points = <LatLng>[
      LatLng(51.5, -0.09),
      LatLng(53.3498, -6.2603),
      LatLng(48.8566, 2.3522),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  onTap: (lat){
                    setState(() {
                      _points.add(lat); 
                    });
                  },
                  onDragStart: (lat){
                    return true;
                  },
                  onDragUpdate: (lat){
                    setState(() {
                    _points.add(lat); 
                    });
                  },
                  onDragEnd: (){
                    return true;
                  },
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                  maxZoom: 5.0,
                  minZoom: 3.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                  polylines: [
                    Polyline(
                        points: _points,
                        strokeWidth: 4.0,
                        color: Colors.purple),
                  ],
                )   
                ],
              )
            )
          ],
        )
      );
  }
}