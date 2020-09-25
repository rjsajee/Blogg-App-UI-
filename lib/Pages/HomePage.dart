import 'package:blogapp/Screen/HomeScreen.dart';
import 'package:blogapp/Screen/ProfileScreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentState = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> titleString = ["HomePage" , "Profile Page"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("@Username"),
                ],    
              ),
            ),
            ListTile(
              title: Text("All Post"),
            ),
          ],)
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(titleString[currentState]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications), onPressed: () {
          }
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(onPressed: null,
      backgroundColor: Colors.teal,
      child: Text("+", 
      style: TextStyle(fontSize: 30.0)),),
      bottomNavigationBar: BottomAppBar(
      color: Colors.teal,
      shape: CircularNotchedRectangle(),
      notchMargin: 12.0,
      child: Container(
        height:50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              IconButton(icon: Icon(Icons.home), 
              color: currentState== 0 ? Colors.white : Colors.white54,
              onPressed: () {
                setState(() {
                  currentState = 0;
                });
              },
              iconSize: 35,),
              IconButton(icon: Icon(Icons.person), 
              color: currentState== 1 ? Colors.white : Colors.white54,
              onPressed: () {
                currentState = 1;
              },
              iconSize: 35,),
            ],
          ),
        ),
      ),
      ),
      body: widgets[currentState],
      );
  }
}