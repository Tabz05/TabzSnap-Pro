import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/user_data_models/following_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/other_user_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_data_model.dart';
import 'package:tabzsnappro/screens/UserProfile/user_profile_posts.dart';
import 'package:tabzsnappro/services/database_service.dart';

class UserProfileFollowings extends StatefulWidget {
  
  UserProfileFollowings();

  @override
  State<UserProfileFollowings> createState() => _UserProfileFollowingsState();
}

class _UserProfileFollowingsState extends State<UserProfileFollowings> {

  @override
  Widget build(BuildContext context) {

    final otherUserDetails = Provider.of<OtherUserDataModel?>(context);

    List<dynamic> followingsList = [];

    if(otherUserDetails!=null)
    {
       followingsList = otherUserDetails.followings.toList();
       followingsList.add('#');
    }
    
    return StreamProvider<List<FollowingDataModel>?>.value(
      catchError:(_,__)=>null,
      initialData: null,
      value: DatabaseService(followingsList:followingsList).otherUserFollowings,
      child: UserProfilePosts()
    );
      
  }
}
