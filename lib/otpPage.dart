
import 'package:first_project/otpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:first_project/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:first_project/home/home.dart';
import 'package:first_project/forgetPass.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
//import 'dart:ui';

import 'dart:async';
import 'dart:convert';
import 'dart:io';


class OtpPage extends StatefulWidget {

  final OnOTPSubmit mL;


  OtpPage({Key key, this.mL}) : super(key : key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with TickerProviderStateMixin{


  void initState() {
    super.initState();
     _controller = new AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,

    );



  }

  void _loadButtonCompleted(String assetName,BuildContext context)  {
    loadAsset(assetName).then((LottieComposition composition) {

      print(_controller.value);

      if(_controller.value>0){
        _controller.reset();
        _controller.forward();
        setState(() {
          _assetName = assetName;
          _composition = composition;

        });

      }else{
        setState(() {
          _assetName = assetName;
          _composition = composition;
          _controller.forward();
        });
      }

    });
  }

  LottieComposition _composition;
  String _assetName;
  int setLogin=0;
  String pinGenerate = "";
  AnimationController _controller;
  @override
  Widget build(BuildContext context) {

    //Navigator.pop(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      child: AlertDialog(
        title: Text('Please enter your otp'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[

              PinEntryTextField(
                  pin: this.pinGenerate,
                  onSubmit: (String pin)  async {
//             pin_new= pin;

                    SharedPreferences prefs= await SharedPreferences.getInstance();

                    print("${prefs.getString('Otp')} is " + pin);

                    if(prefs.getString('Otp')==pin){

//                      _showAlert(context);
//                    print("matched");
                    setState(() {
                      this.pinGenerate=pin;
                      this.setLogin=2;
                    });

                    _loadButtonCompleted("assets/checked_done_.json",context);
//                    setState(() {
//                      setLogin=2;
//                    });

                    Timer timer = new Timer(new Duration(seconds: 3), () {
//        print(prefs.getInt('Otp'));

//                      Navigator.pop(context);
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => ChangePass()
                      ));

                    });

                    }else{

                      print("unmatched");
                      setState(() {
                        this.pinGenerate=pin;
                        this.setLogin=1;

                      });



                    }


                  }
              ),
              Container(
                child:setLogin==2?Container(
                    height:70,
                    width:w,
                    child:new Center(child:new Lottie(
                      coerceDuration: true,
                      composition: _composition,
                      size: const Size(100.0, 150.0),
                      controller: _controller,
                    ))):setLogin==1?new Text("Your "+this.pinGenerate+" OTP Not Matched"):new Text(""),
              ),
              setLogin==2?new Center(child:new Text("Otp Matched")):new Text(""),
//              Form(
//                  child: TextFormField(
//                    decoration: InputDecoration(labelText: 'Email *'),
//                    keyboardType: TextInputType.emailAddress,
////                    validator: validateEmail,
////                    controller: _emailController,
////                    onSaved: (val) => _email = val,
//                  )),
//              SizedBox(
//                height: 20,
//              ),
//              Text(
//                  "Please check your inbox/spam folder for a link to reset your password.")
            ],
          ),
        ),
//        actions: <Widget>[
//          FlatButton(
//            child: Text('Submit'),
//            onPressed: () {
//              Navigator.pop(context);
//            },
//          ),
//        ],
      )
    );
  }
}


abstract class OnOTPSubmit{
  onOTPSubmit(String otp);
}


Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String, dynamic>>((String data) => json.decode(data))
      .then((Map<String, dynamic> map) => new LottieComposition.fromMap(map));
}