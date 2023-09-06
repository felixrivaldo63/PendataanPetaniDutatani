import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dutatani_mapping_iot/apiservices.dart';
import 'package:dutatani_mapping_iot/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'model.dart';

class RegisPage extends StatefulWidget {
  @override
  _RegisPageState createState() => _RegisPageState();
}

enum LoginStatus { notSignin, signIn }

class _RegisPageState extends State<RegisPage> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String passwordCek, password;
  Petani ptn = new Petani();
  bool _secureText = true;
  bool _secureTextKonf = true;
  File _imageFile;
  DateTime selectedDate = DateTime.now();
  int _value;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1945),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        // DateUtils.dateOnly(selectedDate);
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        this.ptn.tanggal_lahir =
            formattedDate; //tgl yg dipilih masuk ke tabel jadwal kolom tgl
      });
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  showHideKonf() {
    setState(() {
      _secureTextKonf = !_secureTextKonf;
    });
  }

  bool _isLoading = false;
  String prov;
  String jk;

  String validateIsi(String value) {
    if (value.isEmpty) {
      return 'Tidak Boleh Kosong !';
    }
    return null;
  }

  String validatePassword(String value) {
    if (password != passwordCek) {
      return 'Password Tidak Cocok !';
    }
    return null;
  }

  final formKey = GlobalKey<FormState>();
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            color: Color(0xff009c41),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Image.asset(
                        "assets/images/logo_dutatani_2.png",
                        width: 200,
                        height: 65,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
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
                                fillColor: Color(0xffe7edeb),
                                hintText: "Username",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              validator: validateIsi,
                              onSaved: (String value) {
                                this.ptn.id = value;
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
                                fillColor: Color(0xffe7edeb),
                                hintText: "Nama",
                                prefixIcon: Icon(
                                  Icons.assignment_ind,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              validator: validateIsi,
                              onSaved: (String value) {
                                this.ptn.nama = value;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color(0xffe7edeb),
                                hintText: "Email",
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              validator: validateIsi,
                              onSaved: (String value) {
                                this.ptn.email = value;
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
                                fillColor: Color(0xffe7edeb),
                                hintText: "Alamat",
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              validator: validateIsi,
                              onSaved: (String value) {
                                this.ptn.alamat = value;
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
                                  Icons.map,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              value: prov,
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
                              validator: validateIsi,
                              onChanged: (String value) {
                                setState(() {
                                  this.ptn.provinsi = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color(0xffe7edeb),
                                hintText: "Nomor Telfon",
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              validator: validateIsi,
                              onSaved: (String value) {
                                this.ptn.nomor_telpon = value;
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
                              validator: validateIsi,
                              onChanged: (String value) {
                                setState(() {
                                  this.ptn.jenis_kelamin = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton.icon(
                              onPressed: () => _selectDate(context),
                              icon: Icon(Icons.date_range_rounded),
                              label: Text('Tanggal Lahir' +
                                  " : " +
                                  "${selectedDate}".split(' ')[0]),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                primary: Colors.white,
                                backgroundColor: Color(0xff009c41),
                                padding: EdgeInsets.only(
                                    left: 53, right: 53, top: 20, bottom: 15),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // RaisedButton(
                            //   onPressed: () => _selectDate(context),
                            //   //memanggil method _selectDate() diatas
                            //   child: Text(
                            //     'Tanggal Lahir' + " : " + "${selectedDate}".split(' ')[0],
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 15,
                            //     ),
                            //   ),
                            //   color: Color(0xff009c41),
                            //   elevation: 2,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(10),
                            //   ),
                            //   padding: EdgeInsets.only(
                            //       left: 50, right: 130, top: 20, bottom: 15),
                            // ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            TextFormField(
                              obscureText: _secureText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color(0xffe7edeb),
                                hintText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(0xff009c41),
                                ),
                                suffixIcon: IconButton(
                                    icon: Icon(
                                        _secureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Color(0xff009c41)),
                                    onPressed: showHide),
                              ),
                              onSaved: (String value) {
                                var bytes = utf8.encode(value);
                                var hashed = sha1.convert(bytes).toString();
                                this.ptn.password = hashed;
                              },
                            ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            // TextFormField(
                            //   obscureText: _secureTextKonf,
                            //   decoration: InputDecoration(
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(8),
                            //       borderSide: BorderSide.none,
                            //     ),
                            //     filled: true,
                            //     fillColor: Color(0xffe7edeb),
                            //     hintText: "Konfirmasi Password",
                            //     prefixIcon: Icon(
                            //       Icons.lock,
                            //       color: Color(0xff009c41),
                            //     ),
                            //     suffixIcon: IconButton(
                            //         icon: Icon(
                            //             _secureTextKonf
                            //                 ? Icons.visibility_off
                            //                 : Icons.visibility,
                            //             color: Color(0xff009c41)),
                            //         onPressed: showHideKonf),
                            //   ),
                            //   onSaved: (String value) {
                            //     passwordCek = value;
                            //   },
                            //   validator: validatePassword,
                            // ),
                            SizedBox(
                              height: 15,
                            ),
                            // _imageFile == null
                            //     ? Text("Silahkan Memilih Foto Profil!")
                            //     : Image.file(
                            //   _imageFile,
                            //   fit: BoxFit.cover,
                            //   height: 300.0,
                            //   alignment: Alignment.topCenter,
                            //   width: MediaQuery.of(context).size.width,
                            // ),
                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.all(
                            //           Radius.circular(10.0))),
                            //   // padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            //   elevation: 0.0,
                            //   minWidth: 200.0,
                            //   height: 45,
                            //   color: Color(0xff009c41),
                            //   onPressed: () {
                            //     _pickImage(ImageSource.gallery);
                            //   },
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: <Widget>[
                            //       new Icon(
                            //         Icons.image,
                            //         color: Colors.white,
                            //       ),
                            //       Text(
                            //         "Upload Foto",
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //             color: Colors.white,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  elevation: 0.0,
                                  minWidth: 200.0,
                                  height: 45,
                                  color: Color(0xff009c41),
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Simpan Data"),
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
                                                    .regisPtnWithFoto(this.ptn)
                                                    .then((isSuccess) {
                                                  setState(
                                                      () => _isLoading = false);
                                                  if (isSuccess) {
                                                    return showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text("Akun Berhasil Dibuat"),
                                                            content: Text("Silahkan Login Menggunakan Akun Yang Sudah Dibuat!"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => LoginPage(
                                                                            // title: "Home Page",
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
                                                  } else {
                                                    return showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text("Data Sudah Pernah Dipakai"),
                                                            content: Text("Silahkan Pakai Data Lain Atau Mencoba Login Kembali"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text("Ok"),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                    // Navigator.pop(context);
                                                  }
                                                });
                                              },
                                              child: Text("Ya"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Sudah Punya Akun?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                // fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                elevation: 0.0,
                                minWidth: 100.0,
                                height: 10,
                                color: Colors.white,
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff009c41)),
                                ),
                                onPressed: () async {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                              // title: "Home Page",
                                              )));
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
            ],
          ),
        ),
      ),
    );
  }
}
