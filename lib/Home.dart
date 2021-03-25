import 'dart:io';
import 'package:chatapp/Global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  String userNum;
  File _image;
  @override
  Widget build(BuildContext context) {
    var Firestore;
    return Scaffold(
      body: Container(decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
          image: new  AssetImage('assets/images/bg.jpg'),
        ),
      ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                FirebaseFirestore.instance.collection('users')./*where("Number",isNotEqualTo: Global.currentuser["num"])*/snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                      itemBuilder: (listContext, index) =>
                          buildItem(snapshot.data.docs[index]),
                      itemCount: snapshot.data.docs.length,
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  buildItem(doc) {
    String a = doc['profileImg'] ?? null;
    return (userNum != doc['Number'])
        ? GestureDetector(
      onTap: () {
        Global.otheruser = {
          "num": doc['Number'],
          "profileImage":doc['profileImg']
        };
        print(Global.otheruser);
        Navigator.of(context).pushNamed('chat');
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
        child: Card(elevation: 6,
          shadowColor: Colors.black,
          color: grey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Center(
                child: Row(
                  children: [
                    a == null
                        ? Container(
                      height: 60,
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.person,color: Colors.white,),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white.withOpacity(0.1),
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        a,
                        width: 60,
                        fit: BoxFit.cover,
                        height: 60,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                   Text(doc['Number'].toString(),
                    style: TextStyle(
                      color: Colors.white,fontSize: 17
                    ),), Spacer(),
                    doc['Number']== Global.currentuser["num"]? Icon(Icons.circle,color: Colors.greenAccent,size: 15,):Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    )
        : SizedBox();
  }
}