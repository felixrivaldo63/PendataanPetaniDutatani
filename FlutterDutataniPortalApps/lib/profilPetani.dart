import 'package:dutatani_mapping_iot/apiservices.dart';
import 'package:dutatani_mapping_iot/daftar_petani.dart';
import 'package:dutatani_mapping_iot/dashboard_ptn.dart';
import 'package:dutatani_mapping_iot/inputlahanv2/daftar_petaniv2.dart';
import 'package:dutatani_mapping_iot/login_page.dart';
import 'package:dutatani_mapping_iot/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dutatani_mapping_iot/tambah_petani.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPtn extends StatefulWidget {
  ProfilPtn({Key key, this.id_ptn}) : super(key: key);
  final String id_ptn;
  Petani pet;

  @override
  _ProfilPtnState createState() => _ProfilPtnState(id_ptn);
}

class _ProfilPtnState extends State<ProfilPtn> {
  final String id_ptn;

  _ProfilPtnState(this.id_ptn);

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
                        child: FutureBuilder<Petani>(
                          future: ApiServices().getPetani(this.id_ptn),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data == null) {
                                return Text('no data');
                              } else {
                                return Text(
                                  snapshot.data.nama,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                );
                              }
                            } else if (snapshot.connectionState ==
                                ConnectionState.none) {
                              return Text('Error'); // error
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    "Something Wrong With Message: ${snapshot.error.toString()}"),
                              );
                            } else {
                              return CircularProgressIndicator(); // loading
                            }
                          },
                          // child: Text(
                          //   this.id_ptn,
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.black,
                          //       fontSize: 20),
                          // ),
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Divider(
                      color: Color(0xff009c41), thickness: 2.5, endIndent: 10),
                  Text(
                    'Profil Petani',
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
            FutureBuilder<Petani>(
              future: ApiServices().getPetani(this.id_ptn),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return Text('no data');
                  } else {
                    return Container(
                      margin: EdgeInsets.only(left: 16, right: 10, top: 5),
                      height: 500,
                      width: 172,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xff009c41),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(16),
                        // height: 400,
                        // width: 172,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Card(
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                left: 60,
                                child: QrImage(
                                  data: "https://dutatani.id/petani_qr/$id_ptn" ,
                                  version: QrVersions.auto,
                                  size: 225,
                                ),
                              ),
                              Positioned(
                                top: 220,
                                child: Text(
                                  "----------------------------------------",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff009c41),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15,
                                top: 245,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 250,
                                child: Text(
                                  snapshot.data.nama,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff009c41),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15,
                                top: 280,
                                child: Icon(
                                  Icons.location_on,
                                  size: 30,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 285,
                                child: Text(
                                  snapshot.data.alamat,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff009c41),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15,
                                top: 315,
                                child: Icon(
                                  Icons.email,
                                  size: 30,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 320,
                                child: Text(
                                  snapshot.data.email,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff009c41),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15,
                                top: 350,
                                child: Icon(
                                  Icons.phone,
                                  size: 30,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 355,
                                child: Text(
                                  snapshot.data.nomor_telpon,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff009c41),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15,
                                top: 385,
                                child: Icon(
                                  Icons.pin_drop_outlined,
                                  size: 30,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 390,
                                child: Text(
                                  snapshot.data.kelurahan_desa,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff009c41),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15,
                                top: 420,
                                child: Icon(
                                  Icons.map,
                                  size: 30,
                                  color: Color(0xff009c41),
                                ),
                              ),
                              Positioned(
                                left: 50,
                                top: 425,
                                child: Text(
                                  snapshot.data.jum_lahan,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff009c41),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Text('Error'); // error
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Something Wrong With Message: ${snapshot.error.toString()}"),
                  );
                } else {
                  return CircularProgressIndicator(); // loading
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
