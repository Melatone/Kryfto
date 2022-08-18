

import 'package:flutter/material.dart';
import 'theme.dart';
import 'game_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Scaffold(
      body: Login(),),
      debugShowCheckedModeBanner: false,
      theme: theme(),
     
    );
  }
}
class Login extends StatefulWidget {
  const Login({Key? key}) : super (key:key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  @override
  void dispose(){
    userController.dispose();
    passController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(color: Theme.of(context).backgroundColor,
  width:300,
  height:400,child: 
    Center(child:
    Column(children: <Widget>[

const Spacer(),
        Text("Username",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20,fontWeight: FontWeight.bold)),

Padding(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            controller: userController,
            decoration: const InputDecoration(
              
              border: OutlineInputBorder(),
              labelText: 'Enter your username',
            ),
          ),
        ),
        const Spacer(),
        Text("Password",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20,fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            controller: passController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your password',
            ),
          ),
        ),
        const Spacer(),
      ElevatedButton(
                style: ElevatedButton.styleFrom(
shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
minimumSize: const Size(130,50),
maximumSize: const Size(130,50),
primary: Theme.of(context).primaryColor,
                ),
                
              
              child: const Text("Login" ,style: TextStyle(
                fontSize: 20,
              ),), 
              onPressed: () { 
                if (userController.text == "Brandyn"&& passController.text == "Cronin"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage()));
                }
               },),

        const Spacer(flex: 2),
    ],
    ),
    ),
  
    );
        
       
        
  }
}