import 'dart:developer';
//import 'package:flutter_mysql/dependency_Injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/Service/auth_services.dart';
import 'package:flutter_firebase/pages/signup.dart';
// import 'package:flutter_mysql/dbconnection.dart';
// import 'package:flutter_mysql/first.dart';
//import 'package:flutter_mysql/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';




class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
   Widget? suffixIcon;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formkey=GlobalKey<FormState>();
   FToast? fToast;
   bool _isObscured=true;
   
   void login(BuildContext context)async{
    final authservice=AuthService();
    try{
      await authservice.signinWithEmailAndPAssword(usernameController.text, passwordController.text);
    }
    catch(e){
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ));
    }
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //dependencyInjection.init();
    fToast=FToast();
    fToast!.init(context);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Login '),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (name) {
                  if(name == ""){
                    //if(name!.length<3){return "name should have atleast 3 characters";}
                  return "Required*";
                  };
                 },
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    
                    
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                  icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
                    ),
                    validator: (name) {
                  if(name == ""){
                    //if(name!.length<3)return "name should have atleast 3 characters";
                  return "Required*";
                  };
                 },
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    
                    onPressed: ()async {
                      // Handle button press
                     // bool idExists = await database().login(uname:usernameController.text??'',pwod:passwordController.text??'');
                      if(_formkey.currentState!.validate()){
                        login(context);
                       }
                      
                      else{
                       
                       // _showToast1();
                
                      // Add your logic for handling username and password
                      //print('Username: $username, Password: $password');
                    }
                      },
                      
                      
                    child: Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle button press
                      Navigator.push(context,MaterialPageRoute(builder: (context) => signup()),);
                    },
                    child: Text('Sign up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  
    
  }
  _showTost(name) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey,
        ),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            //Icon(Icons.check),
            SizedBox(
            width: 12.0,
            ),
            Text(name,style: TextStyle(color: Colors.black),),
        ],
        ),
    );


    // fToast?.showToast(
    //     child: toast,
    //     gravity: ToastGravity.BOTTOM,
    //     toastDuration: Duration(seconds: 2),
    // );
    
    // Custom Toast Position
    fToast?.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM,
        );
}
  void _showToast1() {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text('field is empty'),
        //action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}