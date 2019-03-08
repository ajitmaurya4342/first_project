import 'package:flutter/material.dart';

//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:first_project/home/home.dart';
//import 'package:first_project/history.dart';
import 'package:first_project/mainlogin.dart';
import 'package:image_picker_modern/image_picker_modern.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
@override

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState(
  );
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin{

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

    _controller.addStatusListener((status) {
      print(_controller.value);
      if(status == AnimationStatus.completed) {


      }

    });
  }


  LottieComposition _composition;
  String _assetName;
  AnimationController _controller;



  onChanged(){
    if(_counter>0) {

      _submitNew();
    }
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





  String _email;
  String _name;
  String _password;
  String _passwordConfirm;
  int _mobile;
  String groupValue;
  var ImagePathFull='';
  bool _validate = false;
  String fullName, email, password;
  int phoneNumber;
  bool checkErrorCheckbox=true;
 bool setLoading=false;
 bool setLogin=false;
  //   This is for Obscure text
  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  validateCheckbox(){
    for(var i=0;i<this.hobbies.length;i++){

      if(this.hobbies[i]['value']==false){


        setState(() {
          this.checkErrorCheckbox=false;
        });


      }else{


        setState(() {
          this.checkErrorCheckbox=true;
        });
        break;

      }

    }


  }

  void _submit(String fullName, String email, String password, String phoneNumber,String _color1, BuildContext context) {


    final form = formKey.currentState;

    setState(() {
      this.setLoading=true;
      this._counter++;
    });
    for(var i=0;i<this.hobbies.length;i++){

      if(this.hobbies[i]['value']==false){


        setState(() {
          this.checkErrorCheckbox=false;
          Timer timer = new Timer(new Duration(seconds: 1), () {
            this.setLoading=false;
            setState(() {

            });

          });
        });
         }else{
         setState(() {
          this.checkErrorCheckbox=true;
        });
        break;

      }

    }


    if (form.validate() && this.groupValue!=null && this.checkErrorCheckbox==true && this.ImagePathFull!='') {


      form.save();
//
//      // Email & password matched our validation rules
//      // and are saved to _email and _password fields.
//      _performReg();
      _performReg(fullName, email, password, phoneNumber,_color1,this.groupValue,this.ImagePathFull, context);

    }else{

      Timer timer = new Timer(new Duration(seconds: 1), () {
        this.setLoading=false;
        setState(() {

        });

      });


    }
  }
  _submitNew(){
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
    }
  }


  void _performReg(String fullName, String email, String password, String phoneNumber,String _color1,String groupValue,String uploadFile,BuildContext context) async {

    final res =  await http.post("http://3.0.103.32/Flutter/addVendorMaster.php",
        body: json.encode({"fullName": fullName,"_color1": _color1,"hobbies":this.hobbies,"ImagePathFull": uploadFile,"groupValue": groupValue, "email": email, "password": password, "phoneNumber": phoneNumber,"id":""}),
        headers:{
          "Accept": "application/json"
        }
    );

    final data = json.decode(res.body);

//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setInt("loginId",data['id']);
//    prefs.setString("Username",data['username']);
//    prefs.setString("ProfileImg",data['image']);
    _loadButtonCompleted("assets/checked_done_.json",context);
    setState(() {
      setLogin=true;
    });

    Timer timer = new Timer(new Duration(seconds: 3), () {

//        _showAlert(context, _composition, _controller);
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>  MainLoginPage(loginVal: new LoginPageval(email,password))
    )  );

    });
//
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

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String validateName(String value) {

    if (value.length < 3) {

      return 'Name must be more than 2 charater';
    }else {
      return null;

    }

  }
  dropdownValidate(String value){
    if (value==null) {
      return 'Select Color';
    }else{
      return null;
    }

  }

 cropImage(File imageFile) async {
File image = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

 var bytes = image.readAsBytesSync();



    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();

    var uri = Uri.parse("http://3.0.103.32/Flutter/uploadFile.php");

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(image.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      setState(() {
        ImagePathFull=value;
      });


    });

 }

//  File _image;
  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
   cropImage(image);
//    var image = await ImagePicker.pickImage(source: ImageSource.camera);

//    setState(() {
//      _image = image;
//    });

  }

  var hobbies=[{"value":false,"text":"Cricket"},{"value":false,"text":"Chess"}];

  List<Widget> myHobies(){
    List<Widget> list = new List();
    for(var i=0;i<this.hobbies.length;i++) {


      list.add(new Checkbox(value: hobbies[i]["value"], onChanged: (e){



        setState(() {
          this.hobbies[i]["value"]=e;
        });
        if(this._counter>0) {


          validateCheckbox();

        }



      }));
      list.add(new Text(hobbies[i]["text"]));



    }
    return list;
  }


  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();
  final _registerPassController = TextEditingController();
  final _mobileController = TextEditingController();
  final _registerPassController2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;


    String _mobile;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text("Sign Up"),
            centerTitle: true,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>  Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) =>  MainLoginPage()
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
                        TextFormField(
                          decoration: InputDecoration( labelText: 'Full Name *'),
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          validator: validateName,
                          onSaved: (String val){
                            _name = val;

                          },

                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email *'),
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          controller: _emailController,
                          onSaved: (val) => _email = val,
                        ),
                        TextFormField(
//                          key: passKey,
                          decoration: InputDecoration(labelText: 'Password *'),
                          controller: _registerPassController,
                          validator: (val) =>
                          val.length < 6 ? 'Password too short.' : null,
                          onSaved: (val) => _password = val,
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
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Mobile No:'),
                          keyboardType: TextInputType.phone,
                          validator: validateMobile,
                          controller: _mobileController,
                          onSaved: (val) => _mobile = val,
                        ),

                        new FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                icon: const Icon(Icons.color_lens),
                                labelText: 'Color',
                                errorText: _color == '' && this._counter>0 ? "Please Select Color" : null,
                              ),
                              isEmpty: _color == '',
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                  value: _color,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _color = newValue;
                                      state.didChange(newValue);
                                      onChanged();
                                    });
                                  },
                                  items: _colors.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                          validator: (val) {
                            return val != '' ? null : 'Please select a color';
                          },
                        ),

                        new Row(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(left: 8,top:16,right:8),
                              child: Text("Gender: ",

                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),

                              ),

                            ),
                            this.groupValue==null && this._counter>0 ?
                            new Container(
                              padding: EdgeInsets.only(top:16, right:8),
                              child: Text("Select Gender",

                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),

                              ),

                            ):new Container(
                            )

                          ],
                        ),
                        new Row(
                            children:[
                              new Radio(value: "Ajit", groupValue: groupValue, onChanged: (e){
                                setState(() {
                                  groupValue = e;
                                });
                              },activeColor:Colors.lightBlue),
                              new Text("Male"),

                              new Radio(value: "Sur", groupValue: groupValue,  onChanged: (e){
                                setState(() {
                                  groupValue = e;
                                });


                              },activeColor:Colors.lightBlue),
                              new Text("Female"),

                            ]
                        ),
                        new Row(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(left: 8,top:16,right:8),
                              child: Text("Select Hobies: ",

                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),

                              ),

                            ),
                            this.checkErrorCheckbox==false && this._counter>0 ?
                            new Container(
                              padding: EdgeInsets.only(top:16, right:8),
                              child: Text("Atleast One hobies",

                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),

                              ),

                            ):new Container(
                            )

                          ],
                        ),
                        new Row(
                            children:myHobies(),
                        ),
                        new Row(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(left: 8,top:16,right:8),
                              child: Text("Upload FIle: ",

                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),

                              ),

                            ),
                            this.ImagePathFull=='' && this._counter>0 ?
                            new Container(
                              padding: EdgeInsets.only(top:16, right:8),
                              child: Text("Select File",

                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),

                              ),

                            ):new Container(
                            )

                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            Container(
                              width: w/2,
                              child: FlatButton(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.redAccent,

                                ),

                                onPressed: this._getImage,
                                color: Colors.blueGrey,

                              ),
                              margin: EdgeInsets.only(top: 10.0,right:15.0),
                            ),
                            GestureDetector(
                              child: this.ImagePathFull!=''?
                              Container(

                                height:100,
                                  width:100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                        image: NetworkImage("http://3.0.103.32/uploadFlutter/dummy/${this.ImagePathFull}"),
                                        fit: BoxFit.cover),

                                  ),


                              ): Container(
                                 ),

                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(builder: (context) => new DetailScreen(person: new Person(this.ImagePathFull,"28"))));
                              },


                            ),

                          ],
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
                              String _color1 = this._color;



                              _submit(fullName, email, password, phoneNumber,_color1, context);

//  Navigator.of(context).pushNamed(HomePage.tag);
                            },
                            padding: EdgeInsets.all(12),
                            color: Colors.red,
                            child: Text('Log In', style: TextStyle(color: Colors.white)),
                          ),
                        ),

                        setLogin==true?new Center(child:new Text("Account Created")):new Text(""),


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
class UserInput{
  String fullName, email, password, phoneNumber;

  UserInput(this.fullName, this.email, this.password, this.phoneNumber);
  Map toJson(){
    return{"fullName": fullName, "email": email, "password": password, "phoneNumber": phoneNumber};
  }
}



//                    new TextFormField(
//                      decoration: const InputDecoration(
//                          labelText: 'Password',
//                          icon: const Padding(
//                              padding: const EdgeInsets.only(top: 15.0),
//                              child: const Icon(Icons.remove_red_eye))
//                      ),
//                      validator: (val) => val.length < 6 ? 'Password too short.' : null,
//                      onSaved: (val) => _password = val,
//                      obscureText: _obscureText,
//                    ),
//                      new IconButton(icon: Icon(Icons.remove_red_eye), onPressed: _toggle)

//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                color: Colors.red,
//                width: (w * .80) - 40,
//                child: TextField(
//                  decoration: InputDecoration(hintText: 'Password'),
//                  obscureText: _obscureText,
//                ),
//              ),
//              Container(
//                color: Colors.yellow,
//
//                child: new IconButton(
//                    icon: Icon(Icons.remove_red_eye), onPressed: _toggle),
//              )
//            ],
//          )
//  onChanged1(){
//    print("");
//    _mobileController.text="8286181719";
//    _emailController.text="ajitnew@gmail.com";
//    _registerPassController.text="8286181719";
//    _registerPassController2.text="8286181719";
//
//  }
