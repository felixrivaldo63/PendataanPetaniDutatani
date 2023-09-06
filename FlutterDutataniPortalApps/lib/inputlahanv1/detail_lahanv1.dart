import 'dart:convert';
import 'dart:typed_data';
import 'package:dutatani_mapping_iot/model/lahan.dart';
import 'package:dutatani_mapping_iot/model/dLahan.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class DetailLahanV1 extends StatefulWidget {
  final VoidCallback reload;
  final Lahan lahan;

  const DetailLahanV1({Key key,@required this.lahan, this.reload}): super(key:key);
  @override
  _DetailLahanState createState() => _DetailLahanState();
}

class _DetailLahanState extends State<DetailLahanV1> {
  
  List <DLahan> _listDetail = [];
  final Set<Marker> _markers = {};
  LatLng _cameraPos;
  String longitude, latitude;

  Location loc;
  LocationData locData;
  GoogleMapController mapController;

  var lati = [];
  var loti = [];

  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  int _polygonIdCounter = 1;
  PolygonId selectedPolygon;

  static final clientID = 0;
  static final maxMessageLength = 4096 - 3;

  cek() {
      simpanData();
  }

  simpanData() async{
    final response = await http.post(
    "http://dutatani.id/si_mapping/api/insert_one_titik_lahan.php",
    body: {
      "id_lahan": widget.lahan.ID_Lahan,
      "lat" : locData.latitude.toString(),
      "longt" : locData.longitude.toString()
    });
    final data = jsonDecode(response.body);
    int statusData = data['status'];

    if(statusData == 1){
      fetchData();
    }else{
      print(print);
    }
  }

  void _add() {
    final int polygonCount = polygons.length;

    if (polygonCount == 12) {
      return;
    }

    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygonIdCounter++;
    final PolygonId polygonId = PolygonId(polygonIdVal);

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: Colors.red,
      strokeWidth: 2,
      fillColor: Color.fromARGB(110, 255, 164,0 ),
      points: _createPoints(),
      onTap: () {
        _onPolygonTapped(polygonId);
      },
    );

    setState(() {
      polygons[polygonId] = polygon;
    });
  }

   void _onPolygonTapped(PolygonId polygonId) {
      setState(() {
        selectedPolygon = polygonId;
      });
    }

  int strokeColorsIndex = 0;
  int fillColorsIndex = 2;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  final List<LatLng> points = <LatLng>[];

  Future<Null> fetchData() async{
    final response =
    await http.get("http://dutatani.id/si_mapping/api/read_one_detail_lahan.php?id_lahan="+widget.lahan.ID_Lahan);
    // print(response.body);
    if(response.statusCode ==  200){
      final detailLahan =  jsonDecode(response.body);
      setState(() {
        _listDetail.clear();
        for (Map i in detailLahan){
          // points.add(_createLatLng(DLahan.formJson(i).lat, DLahan.formJson(i).longt));
          _listDetail.add(DLahan.formJson(i));
        }
      });
      polygons.clear();
      _createPoints();
      _add();
    }
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.clear();
    for(var i in _listDetail){
      points.add(_createLatLng(double.tryParse(i.lat), double.tryParse(i.longt)));
      
      // _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(i.id_detail),
          position:LatLng(double.tryParse(i.lat), double.tryParse(i.longt)),
          icon: BitmapDescriptor.defaultMarkerWithHue(32.0) 
        ));
    } 
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    setState(() {
      _cameraPos = LatLng(double.tryParse(widget.lahan.lat), double.tryParse(widget.lahan.longt));
    });

    loc = new Location();
    loc.getLocation();
    loc.onLocationChanged.listen((LocationData cLoc){
      updatePinOnMap();
      setState(() {
        locData = cLoc;
      });
    });
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: 19.0,
      target: LatLng(locData.latitude, locData.longitude),
    );

    mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
      LatLng(locData.latitude, locData.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
         onPressed: (){Navigator.pop(context,true);}
        ),
        centerTitle: true,
        elevation: 0.0,
        title: Text("DETAIL LAHAN V1 ID "+widget.lahan.ID_Lahan),
      ),
      body:
          Column(
            children: <Widget>[
              Container(
               height: 480.0,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  mapType: MapType.satellite,
                  initialCameraPosition:
                  CameraPosition(
                    // target: LatLng(-7.786650869532198, 110.37848766893148),
                    target: _cameraPos,
                    zoom: 19.0,
                  ),
                  markers: _markers,
                  polygons: Set<Polygon>.of(polygons.values),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10.0))),
                  elevation: 0.0,
                  minWidth: 300.0,
                  height: 46.0,
                  color: Color(0xff009c41).withOpacity(0.8),
                  onPressed: () {
                    cek();
                  },
                  child: Text(
                    "TAMBAH TITIK LAHAN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.0),
                  ),
                )
              )
            ])
    );
  }
}