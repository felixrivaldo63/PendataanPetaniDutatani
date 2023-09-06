import 'dart:async';
import 'package:dutatani_mapping_iot/dashboard_adm.dart';
import 'package:dutatani_mapping_iot/dashboard_ptn.dart';
import 'package:dutatani_mapping_iot/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignin, signInAdm, signInPet }

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignin;
  String username, password;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  cek() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    var bytes = utf8.encode(password);
    var hashed = sha1.convert(bytes).toString();
    final response = await http.post(
        "https://dutatani.id/api/login",
        body: {"ID_User": username, "Password": hashed});
    String responseapi = response.body.toString().replaceAll("\n","");
    final data = jsonDecode(responseapi);
    String user = data["user"];
    String kat = data["kategori"];
    int value = data["value"];
    if (value == 1 && kat == "ADP") {
      setState(() {
        _loginStatus = LoginStatus.signInAdm;
        savePref(user, kat, value);
      });
    }else if(value == 1 && kat == "PET"){
      setState(() {
        _loginStatus = LoginStatus.signInPet;
        savePref(user, kat, value);
      });
    }
    else {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
       AlertDialog alert = AlertDialog( title: Text("Username / Password Salah"),
        content: Text("Silahkan Masukkan Username / Password Yang Benar!"),
        actions: [
          okButton,
        ],);
       showDialog(
           context: context,
           builder: (BuildContext context) {
             return alert;
           },
       );
    }
    print(data);
  }

  savePref(String user, String kat, int value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("user", user);
      preferences.setString("kategori", kat);
      preferences.setInt("value", value);
      preferences.commit();
    });
  }

  var user;
  var kat;
  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user = preferences.getString("user");
      kat = preferences.getString("kategori");
      value = preferences.getInt("value");
      if(kat == "ADP"){
        _loginStatus = value == 1 ? LoginStatus.signInAdm : LoginStatus.notSignin;
      }
      if(kat == "PET"){
        _loginStatus = value == 1 ? LoginStatus.signInPet : LoginStatus.notSignin;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignin:
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 36, horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login",
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
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Form(
                          key: _key,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Silahkan Masukan Username";
                                  }
                                },
                                onSaved: (e) => username = e,
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
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Silahkan Masukan Password";
                                  }
                                },
                                  obscureText: _secureText,
                                onSaved: (e) => password = e,
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
                                  color: Color(0xff009c41),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    cek();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Belum Punya Akun?",
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
                                    "Register",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RegisPage(
                                                // title: "Home Page",
                                                ))).then(onGoBack);
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
          ),
        );
        break;
      case LoginStatus.signInAdm:
        return DashboardAdm(id_adm: this.user,);
        break;
      case LoginStatus.signInPet:
        return DashboardPtn(id_ptn: this.user,);
        break;
    }
  }
}
