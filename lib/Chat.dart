import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:chatapp/Global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'Global.dart';

class ChatP extends StatefulWidget {
  @override
  _ChatPState createState() => _ChatPState();
}
class _ChatPState extends State<ChatP> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  UploadImage() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final imagePicker = ImagePicker();
    PickedFile image;
    image = await imagePicker.getImage(source: ImageSource.camera);
    File file = File(image.path);
    if (image != null){
      var snapshot = await firebaseStorage.ref().child('chats/${file.path}').putFile(file);
      var abc = await snapshot.ref.getDownloadURL();

      DateTime date = DateTime.now();
      String time = "${date.hour}:${date.minute}:${date.second}";

      FirebaseFirestore.instance.collection(
          '${Global.currentuser["num"]}_${Global.otheruser["num"]}').add({
        "message": abc,
        "messageType": "img",
        "timestamp": time,
        "senderId": Global.currentuser["num"],
      });
      FirebaseFirestore.instance.collection(
          '${Global.otheruser["num"]}_${Global.currentuser["num"]}').add({
        "message": abc,
        "messageType": "img",
        "timestamp": time,
        "senderId": Global.currentuser["num"],
      });
      print(abc);
    }
  }



  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(backgroundColor: grey,
        appBar: AppBar(backgroundColor: Colors.white,

          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [


              Text('${Global.otheruser["num"]}',
               style: TextStyle(
                 color: Colors.black
               ),),

              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(fit: BoxFit.cover,
                        image: Global.otheruser["profileImage"] != null ? NetworkImage('${Global.otheruser["profileImage"]}') :  AssetImage('assets/images/chat.png')
                    )
                ),

              ),],
          ),
        ),
        body: Container(decoration: new BoxDecoration(
          color: const Color(0xff7c94b6),
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: new AssetImage('assets/images/bg.jpg'),
          ),
        ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(
                '${Global.currentuser["num"]}_${Global.otheruser["num"]}').orderBy(
                'timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Column(
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemBuilder: (listContext, index) =>
                              buildItem(snapshot.data.docs[index]),
                          itemCount: snapshot.data.docs.length,
                          reverse: true,
                        )),
                    Card(color: Colors.white12,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 10, right: 10, top: 6),
                              child: TextField(
                                decoration: InputDecoration(hintText: 'Message',
                                  hintStyle: TextStyle(
                                    color: Colors.white
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 10, bottom: 11, top: 11, right: 15),),
                                style: TextStyle(color: Colors.white),
                                controller: textEditingController,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.image,
                              color:Colors.white,
                            ),
                            onPressed: () => UploadImage(),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: () => sendMsg(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: SizedBox(
                      height: 36,
                      width: 36,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ));
              }
            },
          ),
        ),
      ),
    );
  }
  sendMsg() {
    String msg = textEditingController.text.trim();
    if (msg.isNotEmpty) {
      print('msgprint $msg');

      DateTime date = DateTime.now();
      var time = DateFormat('hh:mm a').format(date);
      //String time = "${date.hour}:${date.minute}:${date.second}:${date.jm}";
      FirebaseFirestore.instance.collection(
          '${Global.currentuser["num"]}_${Global.otheruser["num"]}').add({
        "message": msg,
        "messageType": "message",
        "timestamp": time,
        "senderId": Global.currentuser["num"],
      });
      FirebaseFirestore.instance.collection(
          '${Global.otheruser["num"]}_${Global.currentuser["num"]}').add({
        "message": msg,
        "messageType": "message",
        "timestamp": time                                                                                                                                                             ,
        "senderId": Global.currentuser["num"],
      });
      setState(() {});
      textEditingController.text = "";
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      print('Please enter some text to send');
    }
  }
  buildItem(doc) {
    var messageType;
    return Padding(
      padding: EdgeInsets.only(
          top: 8.0,
          left: ((doc['senderId'] == Global.otheruser["num"]) ? 10 : 60),
          right: ((doc['senderId'] == Global.currentuser["num"]) ? 10 : 60)),
      child: Card(elevation: 4,color: grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: doc['messageType']=='message'
            ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(width: 200,
                    child: Text('${doc['message']} ', style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600
                    ),),
                  ),
                ),
                Spacer(),
                Text('${doc['timestamp']}',style: TextStyle(
                  color: Colors.white60,fontSize: 10
                ),),
                SizedBox(width: 5,),

              ],
            )
            :Column(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FullScreenWidget(
                  child: Hero(
                    tag: "customTag",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:Image.network('${doc['message']}',
                        fit: BoxFit.cover,),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('${doc['timestamp']}',
                  style: TextStyle(
                    color: Colors.white38
                  ),),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}