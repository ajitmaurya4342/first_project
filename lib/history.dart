import 'package:flutter/material.dart';
import 'package:first_project/home/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var moviesAll = [];

  getData() async {
    final HEADERS = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    final url = "http://gogocinema.binarynumbers.io/api/GetAllShow/";

    final res1 = await http.post(url,
        body: json.encode({"CountryID": 1}), headers: HEADERS);

    final map = json.decode(res1.body);
//    print(map["shows"][0]["Movies"]);
    final moviesJson = map["shows"][0]["Movies"];
    this.moviesAll = moviesJson;


    setState(() {

    });


//    moviesJson.forEach((movieName){
//      print(movieName["Image"]);
//    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<Widget> listMyWidgets(w, h, list2) {
    List<Widget> list = new List();

    for (var i = 0; i < list2.length; i++) {
      list.add(new Container(
          height: 200,
          width: w * 0.25,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://www.thenews.com.pk//assets/uploads/updates/2018-05-16/317506_1804291_updates.jpg"),
                fit: BoxFit.cover,
              ))));
    }

    return list;
  }

  final list = ["Apple", "bb", "cc", "dd", "ee"];
  final list2 = ["image", "image", "image", "image"];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    var userProfileImage="";

    return Scaffold(
        appBar: AppBar(title: Text('History')),
        drawer:new Drawer(
          child: new SizedBox(
//        width: 250,
            child: Drawer(
              elevation: 12.0,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: new Text(
                      "Hey Capshun",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    accountEmail: null,
                    currentAccountPicture: new CircleAvatar(
                        child: userProfileImage != null
                            ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: NetworkImage("https://www.thenews.com.pk//assets/uploads/updates/2018-05-16/317506_1804291_updates.jpg"),
                                  fit: BoxFit.cover),
                            ))
                            : Image.asset(
                          'images/profile_image.png',
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          scale: 16,
                        )),
                    decoration: BoxDecoration(color: Colors.transparent),
                  ),

                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (build) => History()));
                    },
                    leading: new Icon(FontAwesomeIcons.history, size: 18),
                    title: new Text(
                      "History",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),

                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (build) => Home()));
                    },
                    leading: new Icon(FontAwesomeIcons.history, size: 18),
                    title: new Text(
                      "Home",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),



                  Divider(),
//                ListTile(
//                    title: new Text(userId != null ? "Logout" : "Sign In"),
//                    onTap: () {
//                      userId != null ? _logout(context) : _signIn(context);
//                    }),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(

              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  Container(
                    width: w,
                    color: Colors.white,
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Now Showing",
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                      height: h * 0.3,
                      color:Colors.white,

                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: this.moviesAll.length,
                          itemBuilder: (context, i) {
                            return Container(

                              width: w *0.45,
                              height: h * 0.3,
                              padding: EdgeInsets.only(left: 8,top:8,right:8,bottom: 8),
                              child: new Container(
                                  height: h * 0.3,
                                  width: w * 0.40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(this.moviesAll[i]['Image']),
                                        fit: BoxFit.cover,
                                      ))),
                              // child:Row(
                              //  children: listMyWidgets(w,h,list2),

                              // ),
                            );
                          })
                  ),
                  new  Container(
                    color: Colors.blueGrey,
                    width: w,

                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Special Screening",
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                      height: h * 0.3,
                      color: Colors.blueGrey,

                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: this.moviesAll.length,
                          itemBuilder: (context, i) {
                            return Container(

                              width: w *0.45,
                              height: h * 0.3,
                              padding: EdgeInsets.only(left: 8,right:8,bottom: 8),
                              child: new Container(
                                  height: h * 0.3,
                                  width: w * 0.40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(this.moviesAll[i]['Image']),
                                        fit: BoxFit.cover,
                                      ))),
                              // child:Row(
                              //  children: listMyWidgets(w,h,list2),

                              // ),
                            );
                          })
                  ),
                  new  Container(
                    color: Colors.white,
                    width: w,

                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Special Screening",
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                      height: h * 0.3,
                      color: Colors.white,

                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: this.moviesAll.length,
                          itemBuilder: (context, i) {
                            return Container(

                              width: w *0.45,
                              height: h * 0.3,
                              padding: EdgeInsets.only(left: 8,right:8,bottom: 8),
                              child: new Container(
                                  height: h * 0.3,
                                  width: w * 0.40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(this.moviesAll[i]['Image']),
                                        fit: BoxFit.cover,
                                      ))),
                              // child:Row(
                              //  children: listMyWidgets(w,h,list2),

                              // ),
                            );
                          })
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
