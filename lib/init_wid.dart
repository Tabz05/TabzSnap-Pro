import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';
import 'package:tabzsnappro/screens/agree.dart';
import 'package:tabzsnappro/screens/authentication/authenticate.dart';
import 'package:tabzsnappro/screens/home.dart';

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  State<InitializerWidget> createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {

  Future userAccepted() async{
      SharedPreferences sp = await SharedPreferences.getInstance();

      return await sp.getString('accept') ?? 'not';
  }

  @override
  Widget build(BuildContext context) {
     
    final user = Provider.of<UserIdModel?>(context);
    print(user);
    
    if(user==null)
    {
      return FutureBuilder(
          future: userAccepted(),
          builder: (ctx, snapshot) {
            // Checking if future is resolved or not
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return SizedBox();
                // if we got our data
              } else if (snapshot.hasData) {
                  
                  if(snapshot.data=='not')
                  {
                    return Agreement();
                  }
                  else
                  {
                     return Authenticate();
                  }

              }
              else 
              {
                 return SizedBox();
              }
            }
            else
            {
               return SizedBox();
            }
          },
        );
    }
    else
    {
      return Home();
    }
      
  }
}