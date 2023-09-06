import 'package:dutatani_mapping_iot/homeScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';
import 'package:flutter/services.dart';

var myKey = 'AIzaSyBXq3jQLhnbscMc4-JoKuRGANpaWXPdCcg';
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xff009c41), // status bar color
  ));

runApp(
    new MaterialApp(
      theme:
      ThemeData(
          primaryColor: Color(0xff009c41),
          accentColor: Colors.deepOrange
      ),
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      title: "DUTATANI",
    ));
} 

    class MyApp extends StatefulWidget {
      @override
      _MyAppState createState() => _MyAppState();
    }
    
    class _MyAppState extends State<MyApp> {
      var _height = 100.0;
      Timer _loadState;

      @override
      void initState() { 
        super.initState();
        _loadState = Timer.periodic(Duration(seconds: 1), (Timer t){
          setState(() {
            if(_height != 200)
              _height = _height + 100;
          });
        });
        startSplashScreen();  
      }

      startSplashScreen() async{
        var duration = const Duration(seconds: 5);
        return Timer(duration,()
          {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_){
                  return LoginPage();
                  // return HomeScreen();
                }),
            );
          });
      }

      @override
      Widget build(BuildContext context) {
        double _tinggi = MediaQuery.of(context).size.height/2;
        return Scaffold(
          body:Center(
            child: Container(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: _tinggi*0.6, horizontal: 100),
                  child: Column(
                    children: <Widget>[
                      AnimatedContainer(
                        height: _height,
                        duration: Duration(seconds: 1),
                        curve: Curves.bounceOut,
                        child: Image.asset(
                          "assets/images/logo_dutatani.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Text('Dutatani.id',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                              color: Color(0xff009c41)
                          )
                      )
                    ],
                  )
                )
            ),
          ),
        );
      }
    }

    //code for static splashscreen using column and default container
//mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    new Image.asset('assets/images/logo_dutatani.png'),
//                    Text('Dutatani.id',
//                        style: TextStyle(fontWeight: FontWeight.bold,
//                            fontSize: 50.0,
//                            color: Color(0xff009c41)
//                        )
//                    )
//                  ],