import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loginapp/control/editNot.dart';
import 'package:loginapp/control/viewNots.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  CollectionReference myNots = FirebaseFirestore.instance.collection("nots");
  FirebaseMessaging userFirebaseMessage = FirebaseMessaging.instance;
  getUser() {
    var user = FirebaseAuth.instance.currentUser;
    print(user!.email);
  }

  @override
  void initState() {
    userFirebaseMessage.getToken();
    FirebaseMessaging.onMessage.listen((event) {
      AwesomeDialog(
          context: context,
          title: "Title",
          body: Text("${event.notification?.body}"),
          dialogType: DialogType.noHeader)
        ..show();
    });
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD8655D),
        title: Text("homePage"),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 216, 93, 93),
              ),
              onPressed: (() async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed("Login");
              }),
              icon: Icon(FontAwesomeIcons.arrowUpFromBracket, size: 20),
              label: Text("Sing Out"),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Navigator.of(context).pushNamed("addNot");
          }),
          child: Icon(Icons.add)),
      body: Container(
        child: FutureBuilder(
          future: myNots
              .where("userId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      key: Key("$index"),
                      onDismissed: (direction) async {
                        await myNots.doc(snapshot.data.docs[index].id).delete();
                        await FirebaseStorage.instance
                            .refFromURL(snapshot.data.docs[index]['notPhoto'])
                            .delete()
                            .then((value) {
                          print("==================");
                          print("Deleted");
                        });
                      },
                      child: ListNots(
                        nots: snapshot.data.docs[index],
                        docID: snapshot.data.docs[index].id,
                      ));
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class ListNots extends StatelessWidget {
  final nots, docID;
  const ListNots({this.nots, this.docID});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ViewNots(myNot: nots);
        }));
      }),
      child: Card(
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Image.network(
                "${nots['notPhoto']}",
                fit: BoxFit.fill,
                height: 80,
              )),
          Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${nots['notTitle']}"),
                subtitle: Text("${nots['notBody']}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (() {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return editNot(
                        docId: docID,
                        listOfNots: nots,
                      );
                    }));
                  }),
                ),
              ))
        ]),
      ),
    );
  }
}
