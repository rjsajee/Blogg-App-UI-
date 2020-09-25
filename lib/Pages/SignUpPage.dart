import 'dart:convert';
import 'package:flutter/material.dart';
import '../NetworkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'HomePage.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
 bool vis=true;
 final _globalKey = GlobalKey<FormState>();
 NetworkHandler networkHandler = NetworkHandler();
TextEditingController _usernameController = TextEditingController();
TextEditingController _emailController = TextEditingController();
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
              emailTextField(),
              passwordTextField(),
              SizedBox(height: 20),
              InkWell(
                onTap: () async{
                  setState(() {
                    circular  = true;
                  });
                  await checkUser();
                  if(_globalKey.currentState.validate() && validate){
                  //we will send the data to rest server
                  Map <String,String> data= {
                     "username":_usernameController.text,
                    "email":_emailController.text,
                    "password":_passwordController.text,
                  };
                  print(data);
                  var responseRegister = 
                 await networkHandler.post("/user/register", data);

                 //Lohin Logic Added Here
                 if(responseRegister.statusCode==200 || responseRegister.statusCode==201){
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
                    Scaffold.of(context).showSnackBar(SnackBar (content: Text("Network error")));
                  }
                 }
                 setState(() {
                    circular  = false;
                  });
                }
                else{
                  setState(() {
                    circular  = false;
                  });
                }
                },
                  child: circular
                  ? CircularProgressIndicator()
                  : Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff00A86B),
                  ),
                  child: Center(
                    child: Text("Sign Up", style: TextStyle(
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
    );
  }
  checkUser()async{
    if(_usernameController.text.length==0)
    {
      setState(() {
        // circular=false;
        validate=false;
        errorText="Username can't be empty";
      });
    }
    else{
      var response = await networkHandler
    .get("/user/checkUsername/${_usernameController.text}");
    if(response['Status']) {
      setState(() {
        // circular = false;
        validate = false;
        errorText = "Username already taken";
      });
    }
    else{
      setState(() {
        // circular = false;
        validate = true;
      });
    }
    }
  }
    

  Widget usernameTextField(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(children: [
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
      ]),
    );
  }

  Widget emailTextField(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          Text("Email"),
          TextFormField(
            controller: _emailController,
            validator: (value){
              if(value.isEmpty)
                return "Email can't be empty";
                if(!value.contains("@"))
                return "Email is invalid";
                return null;
            },
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2
             ),
            ),
          ),
        )
      ]),
    );
  }

  Widget passwordTextField(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          Text("Password"),
          TextFormField(
            controller: _passwordController,
            validator: (value){
              if(value.isEmpty)
              return "Password can't be empty";
              if(value.length < 8)
              return "Password length must have >=8";
              return null;
            },
            obscureText: vis,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(vis ? Icons.visibility_off : Icons.visibility), 
              onPressed: (){
                setState(() {
                  vis = !vis;
                });
              }),
            helperText: "Password length should have >=8",
            helperStyle: TextStyle(
              fontSize: 16,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2
             ),
            ),
          ),
        )
      ]),
    );
  }
}