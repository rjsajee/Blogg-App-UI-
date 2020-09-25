import 'package:blogapp/Pages/SignUpPage.dart';
import 'package:flutter/material.dart';

import 'SignInPage.dart';

class WelcomePage extends StatefulWidget {

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with 
TickerProviderStateMixin{
  AnimationController _controller1;
  Animation<Offset> animation1;
  AnimationController _controller2;
  Animation<Offset> animation2;

@override
  void initState() {
    //controller1
    super.initState();
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this);
      animation1=Tween<Offset>(
        begin:Offset(0.0, 1.0),
        end: Offset(0.0, 0.0),
         ).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeOut),
         );
         _controller1.forward();
  
    //controller2
      _controller2 = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this);
      animation2=Tween<Offset>(
        begin:Offset(0.0, 8.0),
        end: Offset(0.0, 0.0),
         ).animate(CurvedAnimation(parent: _controller2, curve: Curves.elasticInOut),
         );
         _controller2.forward();
  }
  
  void dispose(){
    
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
          child: Column(
            children: [
              SlideTransition(
                position: animation1,
                child: Text("Blogg App",
                 style: TextStyle(fontSize: 38,
                fontWeight: FontWeight.w600, letterSpacing: 2,
                ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),

              SlideTransition(
                position: animation2,
                  child: Text(
                  "Great Stories For Great People",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight:FontWeight.w600,
                  fontSize: 28,
                  letterSpacing: 2),
                ),
              ),
              SizedBox(height: 20,),
              boxContainer("assets/google.png", " Sign up with Google", null),
              SizedBox(height: 15,),
              boxContainer("assets/facebook.png", " Sign up with Facebook", null),
              SizedBox(height: 15,),
              boxContainer("assets/email.png", " Sign up with Email", onEmailClick),
              SizedBox(height: 15,),
              SlideTransition(
                position: animation2,
                              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Already Have an Account",
                  style: TextStyle( color: Colors.grey, fontSize: 15,
                   ), 
                  ),
                  SizedBox(width: 5),
                Row(children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      SignInPage(),));
                    },
                    child: Text("SIGN IN",
                    style: TextStyle( color: Colors.green, fontSize: 17, 
                    fontWeight: FontWeight.bold), ),
                  ),
                ],
                ),
                ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

onEmailClick(){
  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
  SignUpPage(),));
}
    Widget boxContainer(String path, String text, onClick)
    {
      return SlideTransition(
                position: animation2,
              child: InkWell(
                onTap: onClick,
          child: Container(
          height:60,
          width: MediaQuery.of(context).size.width-75,
          child: Card(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(children: [
                  Image.asset(
                    path,
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(width: 10),
                  Text(text, 
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
                ),
            ),
          ),
        ),
              ),
      );
    }
}

