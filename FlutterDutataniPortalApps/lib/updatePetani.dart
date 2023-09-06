import 'dart:ui';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dutatani_mapping_iot/apiservices.dart';
import 'package:dutatani_mapping_iot/dafPetani.dart';
import 'package:dutatani_mapping_iot/daftar_petani.dart';
import 'package:dutatani_mapping_iot/model.dart';
import 'package:dutatani_mapping_iot/model/DataWilayah.dart';
import 'package:dutatani_mapping_iot/pendataan_personal.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class UpdatePetani extends StatefulWidget {
  final String id_adm;
  final String id_ptn;
  Petani pet;
  UpdatePetani({Key key, this.id_adm, this.pet, this.id_ptn}) : super(key: key);

  @override
  _UpdatePetaniState createState() => _UpdatePetaniState(id_adm, pet, id_ptn);
}

class _UpdatePetaniState extends State<UpdatePetani> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final String id_ptn;
  Petani pet;
  final String id_adm;
  bool _isLoading = false;

  List<Petani> lptn = new List();

  _UpdatePetaniState(this.id_adm, this.pet, this.id_ptn);

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  final controlKab = TextEditingController();
  final controlKec = TextEditingController();
  final controlDes = TextEditingController();

  @override
  void initState() {
    //print("NIM yang Sedang Login : " + this.nim_login);
    controlKab.text = this.pet.kabupaten;
    controlKec.text = this.pet.kecamatan;
    controlDes.text = this.pet.kelurahan_desa;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff009c41),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Update Data Petani"),
          backgroundColor: Color(0xff009c41),
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
          // height: 450,
          // width: 172,
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
                          // getAllKab();
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
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0))),
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
                                      setState(
                                              () => _isLoading = true);
                                      ApiServices()
                                          .updateProfil(this.pet)
                                          .then((isSuccess) {
                                        setState(
                                                () => _isLoading = false);
                                        if (isSuccess) {
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Data Berhasil Diubah"),
                                                  content: Text("Data Telah Diperbaharui !"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pushReplacement(
                                                            context, MaterialPageRoute(builder: (context) => DafPetani(id_adm: this.id_adm)));
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
      ),
    );
  }
}