
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dutatani_mapping_iot/model/petani.dart';
import 'package:location/location.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dutatani_mapping_iot/model/DataWilayah.dart';

class TambahLahanV2 extends StatefulWidget {
  final VoidCallback reload;
  final Petani data;
  
  const TambahLahanV2({Key key, @required this.data, this.reload}): super(key:key);
  @override
  _TambahLahanState createState() => _TambahLahanState();
}

class _TambahLahanState extends State<TambahLahanV2> {
  final _key = new GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<String>> key_autocomplete = new GlobalKey();
  String namaLahan, jenisLahan, statusOrg, statusLahan, provinsi, kabupaten, kecamatan, desa;
  int luasLahan;
  String longitude, latitude;

  List _jenisLahan = ["Sawah","Tegalan"];
  List _statusOrg = ["Organik", "Non-Organik"];
  List _statusLahan = ["Milik","Sewa","Garap"];

  final Set<Marker> _markers = {};
  SimpleAutoCompleteTextField textFieldProv;
  SimpleAutoCompleteTextField textFieldKab;
  SimpleAutoCompleteTextField textFieldKec;
  SimpleAutoCompleteTextField textFieldDesa;
  final controlProv = TextEditingController();
  final controlKab = TextEditingController();
  final controlKec = TextEditingController();
  final controlDesa = TextEditingController();

  Location loc;
  LocationData locData;
  GoogleMapController mapController;

  cek() {
    final form = _key.currentState;

    print("haiii cek");
    if (form.validate()) {
      form.save();
      //  print("$username, $password");
      simpanData();
    }
  }

  simpanData() async {
  final response = await http.post(
    "http://dutatani.id/si_mapping/api/insert_lahan.php",
    body: {
      "ID_User": widget.data.ID_User,
      "nama_petani": widget.data.Nama_Petani,
      "lat" : locData.latitude.toString(),
      "longt" : locData.longitude.toString(),
      "nama_lahan": namaLahan,
      "luas_lahan":luasLahan.toString(),
      "status_lahan":statusLahan,
      "jenis_lahan":jenisLahan,
      "status_organik":statusOrg,
      "provinsi":controlProv.text,
      "Kabupaten":controlKab.text,
      "Kecamatan":controlKec.text,
      "Desa_Kelurahan":controlDesa.text
    });
    Navigator.pop(context);
    final data = jsonDecode(response.body);
    int statusData = data['status'];
    if(statusData == 1){
           widget.reload();
          Navigator.pop(context);
        }else{
          print(print);
        }
  }

  @override
  void initState() {
   // TODO: implement initState
    super.initState();

    loc = new Location();
    loc.getLocation();
    loc.onLocationChanged.listen((LocationData cLoc){
      updatePinOnMap();
      setState(() {
        locData = cLoc;
      });
    });
  }

  @override
  void dispose() {
    controlProv.dispose();
    controlKab.dispose();
    controlKec.dispose();
    controlDesa.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    textFieldProv = SimpleAutoCompleteTextField(
      //key: key_autocomplete,
      controller: controlProv,
      suggestions: DataWilayah().dataProv,
      textChanged: (text) => text,
      clearOnSubmit: true,
      decoration: InputDecoration(labelText: "Provinsi"),
    );

    textFieldKab = SimpleAutoCompleteTextField(
      controller: controlKab,
      suggestions: DataWilayah().dataKab,
      textChanged: (text) => text,
      clearOnSubmit: true,
      decoration: InputDecoration(labelText: "Kabupaten")
    );

    textFieldKec = SimpleAutoCompleteTextField(
      controller: controlKec,
      suggestions: DataWilayah().dataKec,
      textChanged: (text) => text,
      clearOnSubmit: true,
      decoration: InputDecoration(labelText: "Kecamatan")
    );

    textFieldDesa = SimpleAutoCompleteTextField(
      controller: controlDesa,
      suggestions: DataWilayah().dataDesa,
      textChanged: (text) => text,
      clearOnSubmit: true,
      decoration: InputDecoration(labelText: "Desa")
    );

    //init default location
    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(-7.796106, 110.370209),
      zoom: 19.0,
    );

    if (locData != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(locData.latitude, locData.longitude),
        zoom: 19.0,
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
         onPressed: (){Navigator.pop(context,true);}
        ),
        centerTitle: true,
        title:  Text('TAMBAH LAHAN'),
      ),
     body: Center(
          child:
       Column(
       children:<Widget>[
         Expanded(
           child:  Form(
            key: _key,  
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: ListView(
                children: <Widget>[
                   Container(
                          height: 250,
                          child :GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                            },
                            zoomGesturesEnabled: true,
                            tiltGesturesEnabled: false,
                            mapType: MapType.satellite,
                            initialCameraPosition: initialCameraPosition,
                    markers: _markers,
                    ),
                    ),
                    Divider(),
                  TextFormField(
                    initialValue: widget.data.Nama_Petani,
                    readOnly: true,
                    decoration: InputDecoration(labelText: "Nama Petani"),
                  ),
                  TextFormField(
                    onSaved: (e) => namaLahan = e,
                    decoration: InputDecoration(labelText: "Nama Lahan"),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number, 
                    onSaved: (input) => luasLahan = num.parse(input),
                    decoration: InputDecoration(labelText: "Luas Lahan (m2)"),
                  ),
                   Container(
                   padding: EdgeInsets.only(top:10, bottom:2),
                   child: DropdownButton(
                     hint: Text("Status Lahan"),
                     value: statusLahan,
                     items: _statusLahan.map((value){
                       return DropdownMenuItem(
                         child: Text(value),
                         value: value,
                       );
                     }).toList(),
                     onChanged: (value){
                       setState(() {
                         statusLahan = value;
                       });
                     },
                   ),
                 ),
                 Container(
                   padding: EdgeInsets.only(top:10, bottom:2),
                   child: DropdownButton(
                     hint: Text("Jenis Lahan"),
                     value: jenisLahan,
                     items: _jenisLahan.map((value){
                       return DropdownMenuItem(
                         child: Text(value),
                         value: value,
                       );
                     }).toList(),
                     onChanged: (value){
                       setState(() {
                         jenisLahan = value;
                       });
                     },
                   ),
                 ),
                 Container(
                   padding: EdgeInsets.only(top:10, bottom:2),
                   child: DropdownButton(
                     hint: Text("Status Organik"),
                     value: statusOrg,
                     items: _statusOrg.map((value){
                       return DropdownMenuItem(
                         child: Text(value),
                         value: value,
                       );
                     }).toList(),
                     onChanged: (value){
                       setState(() {
                         statusOrg = value;
                       });
                     },
                   ),
                 ),
                  textFieldProv,
                  textFieldKab,
                  textFieldKec,
                  textFieldDesa,
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        elevation: 0.0,
                        minWidth: 200.0,
                        height: 45,
                        color: Color(0xff009c41).withOpacity(0.8),
                        onPressed: () {
                          cek();
                        },
                        child: Text(
                          "SIMPAN",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ))

                ],
              ),
            ))
           ),       
        
       ])
     )
    );
  }

}