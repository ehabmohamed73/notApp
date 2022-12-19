import 'package:flutter/material.dart';

class ViewNots extends StatefulWidget {
  final myNot;
  const ViewNots({super.key, this.myNot});

  @override
  State<ViewNots> createState() => _ViewNotsState();
}

class _ViewNotsState extends State<ViewNots> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text("${widget.myNot['notTitle']}")),
          backgroundColor: Color(0xFFD8655D)),
      body: Container(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Image.network(
              "${widget.myNot['notPhoto']}",
              width: double.infinity,
              height: 400,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              "${widget.myNot['notTitle']}",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 165, 81, 48),
            ),
            width: double.infinity,
            child: Text(
              "${widget.myNot['notBody']}",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      )),
    );
  }
}
