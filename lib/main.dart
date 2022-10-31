import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/firebase_options.dart';
import 'package:tabzsnappro/init_wid.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';
import 'package:tabzsnappro/services/auth_service.dart';

void main() async{

WidgetsFlutterBinding.ensureInitialized();
  
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserIdModel?>.value(
      catchError:(_,__)=>null,
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
         debugShowCheckedModeBanner: false,
         home: InitializerWidget(),
      ),
    );
  }
}