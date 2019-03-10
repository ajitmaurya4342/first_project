import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_project/mainlogin.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lottie_flutter/lottie_flutter.dart';
import 'dart:async';

@override

class ChangePass extends StatefulWidget {
  _ChangePassState createState() => _ChangePassState(
  );
}

class _ChangePassState extends State<ChangePass> with SingleTickerProviderStateMixin{
   int _counter = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(onChanged);
    _registerPassController.addListener(onChanged);
    _emailController.addListener(onChanged);
    _mobileController.addListener(onChanged);
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,

    );

  }
   LottieComposition _composition;
   AnimationController _controller;
   String groupValue;
   int loginId;
   String fullName, email, password;
   int phoneNumber;
   bool checkErrorCheckbox=true;
   bool setLoading=false;
   bool setLogin=false;

  onChanged() async {
    if(_counter>0) {
      submitNew();
    }
  }

  void _loadButtonCompleted(String assetName,BuildContext context)  {
    loadAsset(assetName).then((LottieComposition composition) {

      if(_controller.value>0){
        _controller.reset();
        _controller.forward();
        setState(() {

          _composition = composition;

        });

      }else{
        setState(() {

          _composition = composition;
          _controller.forward();
        });
      }

    });
  }

  void _submit (String fullName, String email, String password, String phoneNumber, BuildContext context) async{
    final form = formKey.currentState;

    setState(() {
      this.setLoading=true;
      this._counter++;
    });
    if (form.validate()) {
     form.save();
      _performReg(fullName, email, password, phoneNumber, context);
      }else{
          new Timer(new Duration(seconds: 1), () {
        this.setLoading=false;
        setState(() {
          });
        });
      }
  }
   submitNew() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
    }
  }


  void _performReg(String fullName, String email, String password, String phoneNumber,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var req = {
      "id": prefs.getInt("loginId") ?? 17,
      "password":password,
      
    };
    // ignore: unused_local_variable
    final res =  await http.post("http://3.0.103.32/Flutter/changePassword.php",
        body: json.encode(req),
        headers:{
          "Accept": "application/json"
        }
    );

    _loadButtonCompleted("assets/checked_done_.json",context);
    setState(() {
      setLogin=true;
    });

  // ignore: unused_local_variable
  Timer timer=new Timer(new Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  MainLoginPage(loginVal: new LoginPageval(prefs.getString("email"),password))
      ));

    });
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _registerPassController = TextEditingController();
  final _mobileController = TextEditingController();
  final _registerPassController2 = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final w = MediaQuery.of(context).size.width;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text("Change Password"),
            centerTitle: true,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>  Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) =>  MainLoginPage(loginVal: new LoginPageval(null, null),)
                 )  ),

            ),
          ),


          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: formKey,

                child: ListView(
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(height: 20),
//
                        TextFormField(
//                          key: passKey,
                          decoration: InputDecoration(labelText: 'New Password *'),
                          controller: _registerPassController,
                          validator: (val) =>
                          val.length < 6 ? 'Password too short.' : null,

                          obscureText: true,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Confirm Password *'),
                          validator: (val) {
                            if (val != _registerPassController.text) {
                              return 'Password is not matching';
                            }
//                            var password = passKey.currentState.value;
//                            return equals(_passwordConfirm, password)
//                                ? null
//                                : "Password not matching";
                          },
//                          onSaved: (val) => _passwordConfirm = val,
                          obscureText: true,
                          controller: _registerPassController2,
                        ),

                        SizedBox(
                          height: 7,
                        ),

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
                        ):Container(
                          width: w,

                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),

                            ),
                            onPressed: () {
                              String fullName = _nameController.text;
                              String email = _emailController.text;
                              String password = _registerPassController.text;
                              String phoneNumber = _mobileController.text;
                              _submit(fullName, email, password, phoneNumber, context);

                            },
                            padding: EdgeInsets.all(12),
                            color: Colors.red,
                            child: Text('Log In', style: TextStyle(color: Colors.white)),
                          ),
                        ),

                        setLogin==true?new Center(child:new Text("Password Created")):new Text(""),


                      ],
                    ),
                  ],
                )),
          ),
        ));
  }
}

class DetailScreen extends StatelessWidget {
  final Person person;


  // In the constructor, require a Person
  DetailScreen({Key key, @required this.person}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(

      body: GestureDetector(

        child: Container(

          width:w,
          height:h,

          padding: EdgeInsets.all(15),
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
                "http://3.0.103.32/uploadFlutter/dummy/${person.name}"
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String, dynamic>>((String data) => json.decode(data))
      .then((Map<String, dynamic> map) => new LottieComposition.fromMap(map));
}
class Person {
  final String name;
  final String age;

  Person(this.name, this.age);
}

