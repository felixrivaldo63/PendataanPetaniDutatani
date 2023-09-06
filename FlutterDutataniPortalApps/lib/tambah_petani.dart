import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahPetani extends StatefulWidget {
  final VoidCallback reload;
  TambahPetani(this.reload);
  @override
  _TambahPetaniState createState() => _TambahPetaniState();
}

class _TambahPetaniState extends State<TambahPetani> {
  String nama_petani, ID_User;
  final _key = new GlobalKey<FormState>();

  cek() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      //  print("$username, $password");
      simpanData();
    }
  }

  simpanData() async {
    final response = await http.post(
        "http://dutatani.id/si_mapping/api/insert_petani_urgent.php",
        body: {"ID_User": ID_User, "nama_petani": nama_petani});
        final data = jsonDecode(response.body);
        String status = data['status'];
        if(status == "berhasil"){
          widget.reload();
          Navigator.pop(context);
        }else{
          print(print);
        }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Color(0xff009c41), accentColor: Colors.deepOrangeAccent),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'TAMBAH PETANI (URGENT)',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              elevation: 0.0,
            ),
            body: Form(
              key: _key,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: ListView(children: <Widget>[
                  TextFormField(
                    onSaved: (e) => ID_User = e,
                    decoration: InputDecoration(labelText: "ID User"),
                  ),
                  TextFormField(
                    onSaved: (e) => nama_petani = e,
                    decoration: InputDecoration(labelText: "Nama Petani"),
                  ),
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
                ]),
              ),
            )));
  }
}
