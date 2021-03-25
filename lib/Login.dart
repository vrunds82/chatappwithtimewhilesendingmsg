import 'dart:convert';
import 'dart:io';
import 'package:chatapp/Global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
class Login extends StatefulWidget {
  Login() : super();
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  TextEditingController num = TextEditingController();
  Map data;
  String profileURL;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() {
    return users
        .doc(num.text.toString())
        .set({
      'Number': num.text.toString(),
      'profileImg':profileURL
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  _imgFromCamera() async {
    final PickedFile  = await picker.getImage(source: ImageSource.camera);
    File file = File(PickedFile.path);
    var save = await FirebaseStorage.instance.ref().child('profiles/${file.path}').putFile(file);
    profileURL = await save.ref.getDownloadURL();
    print(profileURL);
    setState(() {
      _image = File(PickedFile.path);
    });
  }
  _imgFromGallery() async {
    final PickedFile  = await picker.getImage(source: ImageSource.gallery);
    File file = File(PickedFile.path);
    var save = await FirebaseStorage.instance.ref().child('profiles/${file.path}').putFile(file);
    profileURL = await save.ref.getDownloadURL();
    setState(() {
      _image = File(PickedFile.path);
    });
  }
  File _image;
  final picker = ImagePicker();
  UploadImage() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final imagePicker = ImagePicker();
    PickedFile image;
    image = await imagePicker.getImage(source: ImageSource.camera);
    File file = File(image.path);
    if (image != null){
      var snapshot = await firebaseStorage.ref().child('profiles/${file.path}').putFile(file);
      var abc = await snapshot.ref.getDownloadURL();
      print(abc);
    }
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        UploadImage();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      UploadImage();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
          image: new AssetImage('assets/images/bg.jpg'),
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 32,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {

                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: grey,
                        child: _image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Container(
                          decoration: BoxDecoration(
                              color: grey,
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_front,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 28,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(decoration: new BoxDecoration(
                          color: grey,
                          boxShadow: [new BoxShadow(
                            color: Colors.white24,
                            blurRadius: 2.0,
                          ),]
                      ),
                        child: TextField(
                          controller: num,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "Enter Name",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  await addUser();
                  Global.currentuser = {
                    "num":num.text,
                    "profileimage":profileURL,
                  };
                  print("This is current user ${Global.currentuser}");
                  setState(() {
                  });
                  Navigator.of(context).pushNamed('home');
                },
                child: Card(
                  shadowColor: Colors.white24,
                  elevation: 4,
                  color: grey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.forward_outlined,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),),

            ],
          ),
        ),
      ),
    );
  }
}