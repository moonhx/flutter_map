import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'dart:math' as math;

void main()=>runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
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
  List<CircleMarker> _circles;
  LatLng tempLat;
  List<CircleMarker> _guideCircles;

  Crs crs;
  MapController _mapController;
  double _extentRadius;


  @override
  void initState() {
    _points = [];
    _circles = [];
    _guideCircles = [];
    _extentRadius = 30.0;
    crs = const Epsg3857();
    _mapController = MapController();
    super.initState();
  }

  // 获取屏幕间两点的位置
  double getOffsetDistance(Offset o1, Offset o2){
    return math.sqrt(math.pow(o1.dx - o2.dx, 2) + math.pow(o1.dy - o2.dy, 2));
  }

  Offset _crsToOffset(LatLng point){
    // Get the widget's offset
    var renderObject = context.findRenderObject() as RenderBox;
    var width = renderObject.size.width;
    var height = renderObject.size.height;

    var localPoint = crs.latLngToPoint(point, _mapController.zoom);
    var mapCenter = crs.latLngToPoint(_mapController.center, _mapController.zoom);
    var localPointCenterDistance = mapCenter - localPoint;

    return Offset( width / 2 - localPointCenterDistance.x,  height / 2 - localPointCenterDistance.y);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  crs: crs,
                  onTap: (lat, focalOffset){
                    // print(1231);
                    // print(lat);
                    // var point = crs.latLngToPoint(lat, _mapController.zoom);
                    tempLat = lat;
                    setState(() {
                      _points.add(lat); 
                      _circles.add(
                        CircleMarker(
                          point: lat,
                          borderStrokeWidth: 1,
                          borderColor: Colors.red,
                          color: Colors.transparent,
                          radius: 4.0,
                        )
                      );
                      _guideCircles = [
                        CircleMarker(
                          point: lat,
                          borderStrokeWidth: 3,
                          borderColor: Colors.red,
                          color: Colors.transparent,
                          radius: _extentRadius,
                        )
                      ];
                    });
                  },
                  onDragStart: (lat, focalOffset){
                    if(tempLat == null){
                      return false;
                    }
                    var offsetCrs = _crsToOffset(tempLat);
                    if(getOffsetDistance(focalOffset,offsetCrs)<=_extentRadius+20){
                      return true;
                    }else{
                      return false;
                    }
                  },
                  onDragUpdate: (lat, focalOffset){
                    var offsetCrs = _crsToOffset(tempLat);
                    if(getOffsetDistance(offsetCrs,focalOffset) > 20){
                      setState(() {
                        tempLat = lat;
                        _points.add(lat); 
                        _circles.add(
                          CircleMarker(
                            point: lat,
                            borderStrokeWidth: 1,
                            borderColor: Colors.red,
                            color: Colors.transparent,
                            radius: 4.0,
                          )
                        );
                        _guideCircles = [
                          CircleMarker(
                            point: lat,
                            borderStrokeWidth: 3,
                            borderColor: Colors.red,
                            color: Colors.transparent,
                            radius: 30.0,
                          )
                        ];
                      });
                    }
                      
                  },
                  onDragEnd: (focalOffset){
                    return true;
                  },
                  center: LatLng(51.5, -0.09),
                  zoom: 14.0,
                  maxZoom: 19.0,
                  minZoom: 3.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']
                  ),
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                        points: _points,
                        strokeWidth: 4.0,
                        color: Colors.purple
                      ),
                    ],
                  ),
                  // 点或者线上面的效果点
                  CircleLayerOptions(circles: _circles),   
                  // 开始的指引点（引导点）
                  CircleLayerOptions(circles: _guideCircles),

                ],
              )
            )
          ],
        )
      );
  }
}