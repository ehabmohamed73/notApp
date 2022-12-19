import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class addNot extends StatefulWidget {
  const addNot({super.key});

  @override
  State<addNot> createState() => _addNotState();
}

class _addNotState extends State<addNot> {
  CollectionReference myNots = FirebaseFirestore.instance.collection("nots");

  final notKey = GlobalKey<FormState>();
  String? notTitle, notBody;
  XFile? pickedImage;
  var imageUrl;
  var imageName;
  addNotFunc(context) async {
    Reference storageRef = FirebaseStorage.instance.ref("images/$imageName");
    if (pickedImage == null)
      return AwesomeDialog(
          context: context,
          title: "Alert",
          body: Text("plase chose an image"),
          dialogType: DialogType.error)
        ..show();
    await storageRef.putFile(File(pickedImage!.path));
    imageUrl = await storageRef.getDownloadURL();
    print("======== $imageUrl");
    var formData = notKey.currentState;
    if (formData!.validate()) {
      Center(
          child: Row(
        children: [Text("loading..   "), CircularProgressIndicator()],
      ));
      formData.save();
      await myNots.add({
        'notTitle': notTitle,
        'notBody': notBody,
        'notPhoto': imageUrl,
        'userId': FirebaseAuth.instance.currentUser!.uid
      }).then((value) {
        print("Added");
        Navigator.of(context).pushNamed("homePage");
      }).catchError((onError) {
        print("error=== $onError");
      });
    } else {
      print("not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD8655D),
        title: Center(child: Text("ADD NOT")),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFD8655D),
              ),
              onPressed: () async {
                await addNotFunc(context);
              },
              child: Text(
                "ADD",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Form(
                autovalidateMode: AutovalidateMode.always,
                key: notKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20, top: 20, left: 20),
                      child: TextFormField(
                          onSaved: (newValue) => notTitle = newValue,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return " Title con't be Empty";
                            }
                          },
                          maxLines: 1,
                          maxLength: 30,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.note_add_sharp,
                                color: Colors.red,
                              ),
                              label: Text("Title"),
                              labelStyle: TextStyle(color: Colors.red),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 107, 15, 8))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 107, 15, 8))))),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20, top: 20, left: 20),
                      child: TextFormField(
                          onSaved: (newValue) => notBody = newValue,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return " Not con't be Empty";
                            }
                          },
                          maxLines: 3,
                          minLines: 1,
                          maxLength: 200,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.note_add_sharp,
                                color: Colors.red,
                              ),
                              label: Text("not"),
                              labelStyle: TextStyle(color: Colors.red),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 107, 15, 8))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 107, 15, 8))))),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 400,
                      width: double.infinity,
                      child: pickedImage == null
                          ? Center(child: const Text("No Image Chosen"))
                          : Image.file(File(pickedImage!.path)),
                    ),
                    Container(
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            primary: Color(0xFFD8655D),
                          ),
                          onPressed: () {
                            showBottomShetToChose(context);
                          },
                          icon: Icon(Icons.add_a_photo_outlined),
                          label: Text("Pick up Image")),
                    )
                  ],
                ))
          ],
        )),
      ),
    );
  }

  showBottomShetToChose(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            padding: EdgeInsets.all(20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                "Chose From Where Your Image",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        InkWell(
                          child: Text(
                            "Camera",
                            style: TextStyle(fontSize: 17),
                          ),
                          onTap: () async {
                            final myImage = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            setState(() {
                              pickedImage = myImage;
                              imageName = basename(pickedImage!.path);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.red,
                        )
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: [
                        InkWell(
                          child: Text("Galery", style: TextStyle(fontSize: 17)),
                          onTap: () async {
                            final myImage = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            setState(() {
                              pickedImage = myImage;
                              imageName = basename(pickedImage!.path);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.red,
                        )
                      ],
                    )),
                  ],
                ),
              )
            ]),
          );
        });
  }
}
