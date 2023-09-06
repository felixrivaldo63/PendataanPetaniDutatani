import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dutatani_mapping_iot/apiservices.dart';
import 'package:dutatani_mapping_iot/daftar_petani.dart';
import 'package:dutatani_mapping_iot/dashboard_ptn.dart';
import 'package:dutatani_mapping_iot/inputlahanv2/daftar_petaniv2.dart';
import 'package:dutatani_mapping_iot/login_page.dart';
import 'package:dutatani_mapping_iot/model.dart';
import 'package:dutatani_mapping_iot/model/DataWilayah.dart';
import 'package:dutatani_mapping_iot/profilPetani.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dutatani_mapping_iot/tambah_petani.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PendataanPers extends StatefulWidget {
  final String id_ptn;
  Petani pet;

  PendataanPers({Key key, this.id_ptn, this.pet}) : super(key: key);

  @override
  _PendataanPersState createState() => _PendataanPersState(id_ptn, pet);
}

String validateUsername(String value) {
  if (value.isEmpty) {
    return 'Nama Tidak Boleh Kosong !!!';
  }
  return null;
}

final formKey = GlobalKey<FormState>();
String prov;
String jk;

String validatePassword(String value) {
  if (value.isEmpty) {
    return 'Password Tidak Boleh Kosong !!!';
  }
  return null;
}

class _PendataanPersState extends State<PendataanPers> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final String id_ptn;
  Petani pet;
  bool _isLoading = false;

  _PendataanPersState(this.id_ptn, this.pet);

  SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilPtn(
                      id_ptn: id_ptn,
                    )));
        print("Profile");
        break;
      case 1:
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setInt("is_login", 0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        break;
    }
  }

  final controlKab = TextEditingController();
  final controlKec = TextEditingController();
  final controlDes = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controlKab.text = this.pet.kabupaten;
    controlKec.text = this.pet.kecamatan;
    controlDes.text = this.pet.kelurahan_desa;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            //Custom AppBar
            Container(
              // margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              color: Color(0xff009c41),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPtn(
                                      id_ptn: this.id_ptn,
                                    )));
                      },
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                        size: 30,
                      )),
                  Image.asset(
                    "assets/images/logo_dutatani_2.png",
                    width: 120,
                    height: 59,
                  ),
                  PopupMenuButton<int>(
                    elevation: 40,
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 35,
                    ),
                    offset: Offset(0, 60),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(
                          pet.nama,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                        // value: 0,
                      ),
                      PopupMenuItem<int>(
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Color(0xff009c41),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text("Profile",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff009c41))),
                          ],
                        ),
                        value: 0,
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem<int>(
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text("Logout",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                          ],
                        ),
                        value: 1,
                      ),
                    ],
                    onSelected: (item) => SelectedItem(context, item),
                  )
                ],
              ),
            ),
            //Card Section
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Divider(
                      color: Color(0xff009c41), thickness: 2.5, endIndent: 10),
                  Text(
                    'PENDATAAN PRIBADI',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff009c41)),
                  ),
                  Divider(
                    color: Color(0xff009c41),
                    thickness: 2.5,
                    endIndent: 10,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 10),
              height: 450,
              width: 172,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xff009c41),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Username",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xff009c41),
                            ),
                          ),
                          initialValue: this.id_ptn,
                          enabled: false,
                          validator: validateUsername,
                          onSaved: (String value) {
                            this.pet.id = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Nama",
                            prefixIcon: Icon(
                              Icons.assignment_ind,
                              color: Color(0xff009c41),
                            ),
                          ),
                          initialValue: this.pet.nama,
                          validator: validateUsername,
                          onSaved: (String value) {
                            this.pet.nama = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Email",
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Color(0xff009c41),
                            ),
                          ),
                          initialValue: pet.email,
                          validator: validateUsername,
                          onSaved: (String value) {
                            this.pet.email = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Alamat",
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Color(0xff009c41),
                            ),
                          ),
                          initialValue: pet.alamat,
                          validator: validateUsername,
                          onSaved: (String value) {
                            this.pet.alamat = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.map,
                              color: Color(0xff009c41),
                            ),
                          ),
                          value: this.pet.provinsi,
                          //elevation: 5,
                          style: TextStyle(color: Colors.black),
                          items: <String>[
                            'Aceh',
                            'Banten',
                            'Bengkulu',
                            'DI Yogyakarta',
                            'DKI Jakarta',
                            'Gorontalo',
                            'Jambi',
                            'Jawa Barat',
                            'Jawa Tengah',
                            'Jawa Timur',
                            'Kalimantan Barat',
                            'Kalimantan Selatan',
                            'Kalimantan Tengah',
                            'Kalimantan TImur',
                            'Kalimantan Utara',
                            'Kepulauan Bangka Belitung',
                            'Kepulauan Riau',
                            'Lampung',
                            'Maluku',
                            'Maluku Utara',
                            'Nusa Tenggara Barat',
                            'Nusa Tenggara Timur',
                            'Papua',
                            'Papua Barat',
                            'Riau',
                            'Sulawesi Barat',
                            'Sulawesi Selatan',
                            'Sulawesi Tengah',
                            'Sulawesi Tenggara',
                            'Sulawesi Utara',
                            'Sumatera Barat',
                            'Sumatera Selatan',
                            'Sumatera Utara',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text(
                            "Provinsi",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              this.pet.provinsi = value;
                              getAllKab();
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SimpleAutoCompleteTextField(
                            controller: controlKab,
                            suggestions: DataWilayah().dataKab,
                            clearOnSubmit: false,
                            textChanged: (text) => text,
                            style: TextStyle(
                              color: Colors.black
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.map_outlined, color: Color(0xff009c41),),
                                labelText: 'Kabupaten',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                )
                            ),
                          textSubmitted: (kab){
                              // print("tes:"+kab);
                              this.pet.kabupaten = kab;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SimpleAutoCompleteTextField(
                          controller: controlKec,
                          suggestions: DataWilayah().dataKec,
                          clearOnSubmit: false,
                          textChanged: (text) => text,
                          style: TextStyle(
                              color: Colors.black
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.map_outlined, color: Color(0xff009c41),),
                              labelText: 'Kecamatan',
                              floatingLabelBehavior:
                              FloatingLabelBehavior.never,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )
                          ),
                          textSubmitted: (kec){
                            // print("tes:"+kab);
                            this.pet.kecamatan = kec;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SimpleAutoCompleteTextField(
                          controller: controlDes,
                          suggestions: DataWilayah().dataDesa,
                          clearOnSubmit: false,
                          textChanged: (text) => text,
                          style: TextStyle(
                              color: Colors.black
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.map_outlined, color: Color(0xff009c41),),
                              labelText: 'Kelurahan / Desa',
                              floatingLabelBehavior:
                              FloatingLabelBehavior.never,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )
                          ),
                          textSubmitted: (kelDes){
                            // print("tes:"+kab);
                            this.pet.kelurahan_desa = kelDes;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Nomor Telfon",
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Color(0xff009c41),
                            ),
                          ),
                          initialValue: pet.nomor_telpon,
                          validator: validateUsername,
                          onSaved: (String value) {
                            this.pet.nomor_telpon = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color(0xffe7edeb),
                            prefixIcon: Icon(
                              Icons.people,
                              color: Color(0xff009c41),
                            ),
                          ),
                          //elevation: 5,
                          style: TextStyle(color: Colors.black),
                          hint: Text(
                            "Jenis Kelamin",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                          value: pet.jenis_kelamin.toString(),
                          items: [
                            DropdownMenuItem<String>(
                              child: Row(
                                children: <Widget>[
                                  Text('Laki-Laki'),
                                ],
                              ),
                              value: "0",
                            ),
                            DropdownMenuItem<String>(
                              child: Row(
                                children: <Widget>[
                                  Text('Perempuan'),
                                ],
                              ),
                              value: "1",
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              this.pet.jenis_kelamin = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Jumlah Lahan",
                            prefixIcon: Icon(
                              Icons.landscape,
                              color: Color(0xff009c41),
                            ),
                          ),
                          initialValue: pet.jum_lahan,
                          validator: validateUsername,
                          onSaved: (String value) {
                            this.pet.jum_lahan = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Jumlah Tenaga Kerja Musiman",
                            prefixIcon: Icon(
                              Icons.work,
                              color: Color(0xff009c41),
                            ),
                          ),
                          initialValue: pet.jum_pekerja,
                          validator: validateUsername,
                          onSaved: (String value) {
                            this.pet.jum_pekerja = value;
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            elevation: 0.0,
                            minWidth: 200.0,
                            height: 45,
                            color: Colors.white,
                            child: Text(
                              "Update Data",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff009c41)),
                            ),
                            onPressed: () async {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Update Data"),
                                    content: Text(
                                        "Apakah Anda akan menyimpan data ini?"),
                                    // Text(this.ptn.tanggal_lahir + " " + this.ptn.jenis_kelamin),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Tidak"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          _formState.currentState.save();
                                          setState(() => _isLoading = true);
                                          ApiServices()
                                              .updateProfil(this.pet)
                                              .then((isSuccess) {
                                            setState(() => _isLoading = false);
                                            if (isSuccess) {
                                              return showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Data Berhasil Diubah"),
                                                      content: Text(
                                                          "Data Telah Diperbaharui !"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            DashboardPtn(
                                                                              id_ptn: this.id_ptn,
                                                                            )));
                                                          },
                                                          child: Text("Ok"),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                              // _showNotification();
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => LoginPage(
                                              //           // title: "Home Page",
                                              //         )));
                                            }
                                          });
                                        },
                                        child: Text("Ya"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Get State information by API
  String kabTerpilih;
  List dataKab = List();

  Future getAllKab() async {
    var response = await http.get(
        "http://10.0.2.2:8000/api/dataKecamatan/" + this.pet.provinsi,
        headers: {"Accept": "application/json"});
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      dataKab = jsonData;
    });
    print(jsonData);
    return "success";
  }
}
