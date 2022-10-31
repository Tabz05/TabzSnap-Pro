import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/user_data_models/follower_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/following_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/other_user_data_model.dart';
import 'package:tabzsnappro/models/post_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';
import 'package:tabzsnappro/screens/UserProfile/follower_list_tile.dart';
import 'package:tabzsnappro/screens/UserProfile/following_list_tile.dart';
import 'package:tabzsnappro/screens/UserProfile/post_list_tile.dart';
import 'package:tabzsnappro/screens/singleChat/single_chat.dart';
import 'package:tabzsnappro/services/database_service.dart';
import 'package:tabzsnappro/shared/colors.dart';
import 'package:tabzsnappro/shared/loading.dart';

class UserProfileMain extends StatefulWidget {
  const UserProfileMain({Key? key}) : super(key: key);

  @override
  State<UserProfileMain> createState() => _UserProfileMainState();
}

class _UserProfileMainState extends State<UserProfileMain> {

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserIdModel?>(context);
    final userDetails = Provider.of<UserDataModel?>(context);

    final otherUserDetails = Provider.of<OtherUserDataModel?>(context);

    final followersList = Provider.of<List<FollowerDataModel>?>(context);
    final followingsList = Provider.of<List<FollowingDataModel>?>(context);

    final postsList = Provider.of<List<PostModel>?>(context);

    bool userHasBlocked = false;
    bool userIsBlocked = false;

    if(user != null && userDetails!=null && otherUserDetails != null && followersList != null &&
        followingsList != null && postsList != null)
    {
          if(otherUserDetails.blocked_by.contains(userDetails.uid))
          {
             userHasBlocked = true;
          }

          if(otherUserDetails.blocked.contains(userDetails.uid))
          {
             userIsBlocked = true;
          }
    }

    return user == null || userDetails==null ||
            otherUserDetails == null ||
            followersList == null ||
            followingsList == null ||
            postsList == null
        ? Loading()
        : 
        userIsBlocked || userHasBlocked? SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(  
              backgroundColor: red_main,
            ),
            body: Container(
               width: double.infinity,
               height: double.infinity,
               margin: EdgeInsets.all(20),
               alignment: Alignment.center,
               child: Column(  
                children: [
                   Icon(Icons.block,color: red_main,size:36),
                   Text('Blocked',style: TextStyle(color: red_main),)
                ],
               ),
            ),
          )) :
        SafeArea(
            child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: red_main,
              title: Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: SizedBox(),
                  ),
                  Text(otherUserDetails.name),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: SizedBox(),
                  ),
                  user.uid != otherUserDetails.uid
                      ? Row(
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.message_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SingleChat(
                                        otherUserDetails.uid,
                                        otherUserDetails.name)));
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              child: //Icon(Icons.block,color: Colors.white,size: 24,),
                                  Text('block',style: TextStyle(fontSize: 14),),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Block '+otherUserDetails.name+"?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                              child: Text('No')),
                                          TextButton(
                                              onPressed: () async {

                                                await _databaseService.addBlock(
                                                    user.uid,
                                                    otherUserDetails.uid);
                                                
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                              child: Text('Yes')),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ],
                        )
                      : Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: SizedBox(),
                        ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(children: [
                  SizedBox(
                    height: 20,
                  ),
                  !otherUserDetails.hasProfilePic
                      ? CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              AssetImage('assets/images/usericon.png'),
                          backgroundColor: red_main)
                      : CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              NetworkImage(otherUserDetails.profilePicUri)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    otherUserDetails.name,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(otherUserDetails.email),
                  SizedBox(
                    height: 20,
                  ),
                  otherUserDetails.uid == user.uid
                      ? SizedBox()
                      : otherUserDetails.followers.contains(user.uid)
                          ? GestureDetector(
                              onTap: () async {
                                await _databaseService.unfollow(
                                    user.uid, otherUserDetails.uid);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Unfollow',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.red),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                await _databaseService.follow(
                                    user.uid, otherUserDetails.uid);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Follow',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green),
                              ),
                            ),
                  userDetails.uid == otherUserDetails.uid? SizedBox():
                  GestureDetector(
                    onTap: (){
                       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("User Reported."),
                          ),
                        );
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(  
                          color: Colors.yellow[700],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Report',style: TextStyle(color: Colors.white,fontSize: 16),),
                     ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Flexible(
                            child: SizedBox(), flex: 1, fit: FlexFit.tight),
                        Text(
                          'Followers',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                            child: SizedBox(), flex: 1, fit: FlexFit.tight),
                        Text(
                          'Posts',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                            child: SizedBox(), flex: 1, fit: FlexFit.tight),
                        Text(
                          'Followings',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                            child: SizedBox(), flex: 1, fit: FlexFit.tight),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Flexible(
                            child: SizedBox(), flex: 1, fit: FlexFit.tight),
                        Text(
                          followersList.length.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                            child: SizedBox(), flex: 2, fit: FlexFit.tight),
                        Text(
                          postsList.length.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                            child: SizedBox(), flex: 2, fit: FlexFit.tight),
                        Text(
                          followingsList.length.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                            child: SizedBox(), flex: 1, fit: FlexFit.tight),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    child: Text(
                      'Followers',
                      style: TextStyle(fontSize: 18),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  followersList.isEmpty
                      ? Text(
                          "No Followers",
                          style: TextStyle(fontSize: 16),
                        )
                      : SizedBox(
                          height:
                              180, //height is required for horizontal scrolling
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: followersList.length,
                            itemBuilder: (context, index) {
                              return FollowerListTile(followersList[index]);
                            },
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    child: Text(
                      'Followings',
                      style: TextStyle(fontSize: 18),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  followingsList.isEmpty
                      ? Text(
                          "No Followings",
                          style: TextStyle(fontSize: 16),
                        )
                      : SizedBox(
                          height:
                              180, //height is required for horizontal scrolling
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: followingsList.length,
                            itemBuilder: (context, index) {
                              return FollowingListTile(followingsList[index]);
                            },
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    child: Text(
                      'Posts',
                      style: TextStyle(fontSize: 18),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  postsList.isEmpty
                      ? Column(
                          children: [
                            Text(
                              "No Posts",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 100 * (((postsList.length) / 3) + 1),
                              child: GridView.builder(
                                itemCount: postsList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return Container(
                                      width: double.infinity,
                                      height: 100,
                                      child: PostListTile(postsList[index]));
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                ]),
              ),
            ),
          ));
  }
}
