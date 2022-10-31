import 'package:flutter/src/widgets/framework.dart';
import 'package:tabzsnappro/screens/authentication/register.dart';
import 'package:tabzsnappro/screens/authentication/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView()
  {
    setState(() {
      showSignIn = !showSignIn;
    });
    
  }


  @override
  Widget build(BuildContext context) {

     return showSignIn? SignIn(toggleView) : Register(toggleView);

  }
}