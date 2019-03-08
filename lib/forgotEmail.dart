
import 'package:first_project/otpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:first_project/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:first_project/home/home.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
//import 'dart:ui';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

//import 'lo';

class ForgotPage extends StatefulWidget {
//  final LoginPageval loginVal;
//
//
//  // In the constructor, require a Person
//  MainLoginPage({Key key, @required this.loginVal}) : super(key: key);

  static String tag = 'login-page';
  @override
  _ForgetPageState createState() => new _ForgetPageState();
}

class _ForgetPageState extends State<ForgotPage> with TickerProviderStateMixin {

  LottieComposition _composition;
  String _assetName;
  AnimationController _controller;
  bool setLogin=false;
  int pin_new=0;



  bool _repeat;

String widgetEmail;
String widgetPassword;
  @override
  void initState() {
    super.initState();

    getData1();

    _repeat = false;
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,

    );

    _controller.addStatusListener((status) {
      print(_controller.value);
      if(status == AnimationStatus.completed) {


      }

    });

    _controller.addListener((){
      setState(() {});
    });



    _emailController.addListener(onChanged);
    _passwordController.addListener(onChanged);
  }
  int _counter=0;
  onChanged(){

    if(_counter>0) {


      _submitNew();
    }
  }
  getData1(){
//     if(widget.loginVal!=null){
//      _emailController.text=widget.loginVal.email;
//      _passwordController.text=widget.loginVal.password;
//
//
//      setState(() {
//
//      });
//       }


   }
  _submitNew(){
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();



  String invalidUsername;
  bool setLoading=false;
  bool canceled=false;

  String validateName(String value) {

    if (value.length < 3) {

      return 'Name must be more than 2 charater';
    }else {
      return null;

    }

  }

//  void _loadButtonPressed(String assetName) {
//    loadAsset(assetName).then((LottieComposition composition) {
//
//
//      setState(() {
//        _assetName = assetName;
//        _composition = composition;
//        _controller.reset();
//
//      });
//    });
//  }


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

//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }

  @override
  void dispose() async {

    super.dispose();
    _controller.reset();
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    print(prefs.remove("Otp"));

  }



  void _submit(String email, BuildContext context) {


final form = formKey.currentState;
    setState(() {
      this._counter++;
      this.setLoading=true;
    });
 if (form.validate()) {

      form.save();

      _performReg(email, context);

    }else{

   Timer timer = new Timer(new Duration(seconds: 1), () {
     this.setLoading=false;
     setState(() {

     });

   });


 }

  }


  _performReg(email,BuildContext context) async {



    final res =  await http.post("http://3.0.103.32/Flutter/checkEmail.php",
        body: json.encode({ "email": email}),
        headers:{
          "Accept": "application/json"
        }
    );

    final data = json.decode(res.body);
    print(data);


    if(data['statusCode']==1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("loginId", data['id']);
      prefs.setString("Otp", data['Otp']);
      prefs.setString("email", data['email']);


      _loadButtonCompleted("assets/checked_done_.json",context);
      setState(() {
        setLogin=true;
      });

      Timer timer = new Timer(new Duration(seconds: 3), () {
//        print(prefs.getInt('Otp'));

    _showAlert(context);
//        Navigator.pushReplacement(
//            context, MaterialPageRoute(builder: (context) => Home()
//      ));

      });

    }else{
      this.invalidUsername="Email Not found.";

      setState(() {
        setLoading=false;
      });

//
//      Timer timer = new Timer(new Duration(seconds: 1), () {
//        print("ffdsff");
//
//
//      });



    }


  }





  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset("assets/logo.png"),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      validator: validateName,

      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,

      obscureText: true,
      validator: (val) =>
      val.length < 6 ? 'Password too short.' : null,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );


    final lottieVal= new Lottie(
      composition: _composition,
      size: const Size(200, 150),
      controller: _controller,


    );
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          String email = _emailController.text;
//          String password = _passwordController.text;



       _submit(email,context);

//  Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final SignUpLabel = FlatButton(
      child: Text(
        'Sign Up For New Account?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {

        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  Login()
        )  );
      },
    );
    final forgotLabel = FlatButton(
      padding: EdgeInsets.only(top:0),
      child: Text(
        'forgot your password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {

        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  Login()
        )  );
      },
    );

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    final Error=  invalidUsername!=null? new Container(
        padding:EdgeInsets.only(left:8),
      child:new Text(invalidUsername, style: new TextStyle(
        fontSize: 15.0,
        color: Colors.red,

        fontWeight: FontWeight.bold))): new Container();


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:  Form(
        key: formKey,

        child:ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
//            SizedBox(height: 8.0),
//            password,
            SizedBox(height: 12.0),
            Error,
            setLogin==true?
           Container(
            height:70,
               width:w,
            child:new Center(child:new Lottie(
              coerceDuration: true,
              composition: _composition,
              size: const Size(100.0, 150.0),
              controller: _controller,
            ))):setLoading==true?new Center(
               child: CircularProgressIndicator(strokeWidth: 2),
             ):loginButton,

            setLogin==true?new Center(child:new Text("Email Found & Otp Sent on your mail.")):new Text(""),

//           setLogin==false?SignUpLabel:new Container(),
//           setLogin==false?forgotLabel:new Container(),




          ],
        ),
      ),
      ),
    );
  }
}
class LoginPageval{
  final String email;
  final String password;

  LoginPageval(this.email, this.password);

}

Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String, dynamic>>((String data) => json.decode(data))
      .then((Map<String, dynamic> map) => new LottieComposition.fromMap(map));
}


Future<void> _showAlert(BuildContext context) async{

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return OtpPage();
    },
  );
}



