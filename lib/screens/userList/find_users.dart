import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/user_data_models/blocked_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';
import 'package:tabzsnappro/screens/userList/find_user_list.dart';
import 'package:tabzsnappro/services/database_service.dart';
import 'package:tabzsnappro/shared/colors.dart';
import 'package:tabzsnappro/shared/loading.dart';

class FindUsers extends StatefulWidget {
  const FindUsers({Key? key}) : super(key: key);

  @override
  State<FindUsers> createState() => _FindUsersState();
}

class _FindUsersState extends State<FindUsers> {

  String usernameToSearch="";

  @override
  Widget build(BuildContext context) {

      final userDetails = Provider.of<UserDataModel?>(context);

      List<dynamic> blocked_list=[];
      List<dynamic> blocked_by_list=[];

      List<dynamic> blockedList=[];

      if(userDetails!=null)
      {
         blocked_list = userDetails.blocked.toList();
         blocked_by_list = userDetails.blocked_by.toList();
         
         blockedList = blocked_list + blocked_by_list;
         blockedList.add('#');

         print("blocked list: "+blockedList.toString());
      }
       
      return userDetails==null? Loading() : SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: red_main),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(  
                    hintText: 'Enter username...',
                    border: InputBorder.none,
                  ),
                  cursorColor: red_main,
                  onChanged: (value){
                     setState(() {
                       usernameToSearch = value;
                     });
                  },
                ),
              ),
              StreamProvider<List<UserDataModel>?>.value(
              catchError:(_,__)=>null,
              initialData: null,
              value: DatabaseService(uid:userDetails.uid,usernameToSearch:usernameToSearch,blockedList: blockedList).getUsers,
              child: FindUserList()
                ),
            ],
          ),
        ),
      );

  } 
}