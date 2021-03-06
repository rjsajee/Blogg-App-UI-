import 'dart:convert';

import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Pages/SignUpPage.dart';
import 'package:flutter/material.dart';
import '../NetworkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class SignInPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignInPage> {
 bool vis=true;
 final _globalKey = GlobalKey<FormState>();
 NetworkHandler networkHandler = NetworkHandler();
TextEditingController _usernameController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
String errorText;
bool validate=false;
bool circular=false;
final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.green[200]
            ],
            begin: const FractionalOffset(0.0, 8.0),
            end: const FractionalOffset(0.0, 0.0),
            stops:  [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        
        child: Form(
          key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign in with Email", style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                ),
                SizedBox(height:20),
                usernameTextField(),
                SizedBox(height: 15.0),
                passwordTextField(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Text("Forgot Password?", 
                  style: TextStyle(
                  fontSize: 15.0, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.blue),),
                  SizedBox(width: 20.0),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: Text("New User?",
                    style: TextStyle(
                    fontSize: 15.0, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.blue[900]),),
                  ),
                ],
                ),
                SizedBox(height: 20.0),
                InkWell(
                  onTap: () async{
                    setState(() {
                      circular=true;
                    });
                    Map <String,String> data= {
                     "username":_usernameController.text,
                    "password":_passwordController.text,
                  };
                  var response = await networkHandler.post("/user/login", data);
                  
                  if(response.statusCode==200 || response.statusCode==201){
                    Map <String, dynamic> output = json.decode(response.body); 
                    print(output["token"]);
                    await storage.write(key: "token", value: output['token']);
                    setState(() {
                      validate = true;
                      circular = false;
                    });
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(),
                    ),
                    (route) => false);
                  }
                  else{
                    String output = json.decode(response.body); 
                    setState(() {
                      validate = false;
                      errorText = output;
                      circular = false;
                    });
                  }
                  },
                    child: Container(
                    height: 50,
                    width: 150, 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff00A86B),
                    ),
                    child: Center(
                      child: circular
                    ? CircularProgressIndicator()
                    : Text("Sign In", style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                ),
              ],
          ),
            ),
        ),
      ),
    );
  }
    

  Widget usernameTextField(){
      return Column(children: [
        Text("Username"),
        TextFormField(
          controller: _usernameController,
        
        decoration: InputDecoration(
          errorText: validate ? null : errorText,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2
           ),
          ),
        ),
      )
      ]);
  }


  Widget passwordTextField(){
      return Column(children: [
        Text("Password"),
        TextFormField(
          controller: _passwordController,
          obscureText: vis,
        decoration: InputDecoration(
          errorText: validate ? null : errorText,
          suffixIcon: IconButton(
            icon: Icon(vis ? Icons.visibility_off : Icons.visibility), 
            onPressed: (){
              setState(() {
                vis = !vis;
              });
            }),
          helperStyle: TextStyle(
            fontSize: 16,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
           ),
          ),
        ),
      )
      ]);
  }
}