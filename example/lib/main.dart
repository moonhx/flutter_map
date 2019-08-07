import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main()=>runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'map_demo',
      home: Scaffold(
        appBar: AppBar(title: Text('OnTap')),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text('Try tapping on the markers'),
              ),
              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                    onTap: (lat){
                      // print(lat);
                    },
                    onDragStart: (lat){
                      print(lat);
                      return true;
                    },
                    onDragUpdate: (lat){
                      print(lat);
                    },
                    onDragEnd: (){
                      print('绘制完成了！');
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


