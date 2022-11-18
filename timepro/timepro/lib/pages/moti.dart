import 'package:flutter/material.dart';


class motiScreen extends StatefulWidget {
  @override
  motiScreenState createState() => motiScreenState();
}

class motiScreenState extends State<motiScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 1,
      ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/timeb2.jpg'), fit: BoxFit.fill),),
        padding: const EdgeInsets.fromLTRB(60, 100, 60, 100),
        height: 1000,
        child: Column(
          children: [
            Text("Stay Focused",style: TextStyle(color: Colors.yellow, fontSize: 20, height: 2)),
            Text("Learn as if you will live forever, live like you will die tomorrow.” — Mahatma Gandhi", style: TextStyle(color: Colors.yellow, fontSize: 20, height: 2),),
            Text("Write it on your heart that every day is the best day in the year.”",style: TextStyle(color: Colors.yellow, fontSize: 20,height: 2)),
            Text("Push your boundaries beyond the ordinary; be that “extra” in “extraordinary.”",style: TextStyle(color: Colors.yellow, fontSize: 20, height: 3))
          ],
        ),
        //child: Text("Stay Focused", style: TextStyle(color: Colors.yellow, fontSize: 50, fontWeight: FontWeight.bold,)),
      ),
    );
  }
}
//“