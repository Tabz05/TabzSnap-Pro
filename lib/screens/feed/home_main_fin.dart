import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/user_data_models/following_data_model.dart';
import 'package:tabzsnappro/models/post_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_data_model.dart';
import 'package:tabzsnappro/screens/feed/home_feed.dart';
import 'package:tabzsnappro/screens/myChats/my_chats.dart';
import 'package:tabzsnappro/services/database_service.dart';
import 'package:tabzsnappro/shared/colors.dart';
import 'package:tabzsnappro/shared/loading.dart';

class HomeMainFin extends StatefulWidget {
  const HomeMainFin({Key? key}) : super(key: key);

  @override
  State<HomeMainFin> createState() => _HomeMainFinState();
}

class _HomeMainFinState extends State<HomeMainFin> {
  @override
  Widget build(BuildContext context) {
      
      final userDetails = Provider.of<UserDataModel?>(context);

      List<dynamic> followingsList = [];

      if(userDetails!=null)
      {
        followingsList = userDetails.followings.toList();
        followingsList.add(userDetails.uid);
      }

      return userDetails==null? Loading() : StreamProvider<List<PostModel>?>.value(
      catchError:(_,__)=>null,
      initialData: null,
      value: DatabaseService(uid: userDetails.uid,followingsList:followingsList).myFeed,
      child: HomeFeed()
    );
  }
}