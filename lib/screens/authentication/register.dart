import 'package:flutter/material.dart';
import 'package:tabzsnappro/services/auth_service.dart';
import 'package:tabzsnappro/shared/loading.dart';

class Register extends StatefulWidget {
  
  final Function toggleView;
  Register(this.toggleView);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name="";
  String email="";
  String password="";
  String error="";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
      
    return loading? Loading() : SafeArea(
         child: Scaffold(
          backgroundColor:Colors.white,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Text('Create a new',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  Text('account',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  SizedBox(height: 30,),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Name",
                        icon: Icon(Icons.person),
                        border: InputBorder.none
                      ),
                      validator: (String?value){
                          if(value!=null && value.isEmpty)
                          {
                            return "please enter your name";
                          }
                          else
                          {
                              return null; 
                          }
                      },
                      onChanged: (val){ 
                           setState(() {
                             name=val;
                           });
                      },
                  ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        icon: Icon(Icons.email),
                        border: InputBorder.none
                      ),
                      validator: (String?value){
                          if(value!=null && value.isEmpty)
                          {
                            return "please enter email";
                          }
                          else
                          {
                              return null; 
                          }
                      },
                      onChanged: (val){ 
                           setState(() {
                             email=val;
                           });
                      },
                  ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(Icons.lock),
                        border: InputBorder.none
                      ),
                      validator: (String?value){
                          if(value!=null && value.isEmpty)
                          {
                            return "please enter password";
                          }
                          else if(value.toString().length<6)
                          {
                            return "password must be at least 6 characters";
                          }
                          else
                          {
                              return null; 
                          }
                      },
                      onChanged: (val){ 
                           setState(() {
                             password=val;
                           });
                      },
                  ),
                    ),
                    SizedBox(height: 30,),
                    GestureDetector(
                      onTap: () async{
                          
                        if(_formKey.currentState!.validate())
                        {
                          setState(() {
                            loading = true;
                          });

                          dynamic result = await _auth.registerWithEmailAndPassword(email,password,name);

                          if(result==null)
                          {
                              setState(() {
                                error = "Could not sign up. Check your internet connection";
                                loading = false;
                              });
                          }
                        }

                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.red),
                        child: Text("Register",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text("Already have an account?",style: TextStyle(color: Colors.black,fontSize: 16),),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: (){
                        widget.toggleView();
                      },
                      child: Text('Sign In',style: TextStyle(color: Colors.blue,fontSize: 16),)),
                    SizedBox(height: 20,),
                    Text(error,style: TextStyle(color: Colors.red,fontSize: 16),),
                    SizedBox(height: 20,),
                    ]),
                  )
              ]),
            ),
          ),
         ),
     );

  }
}