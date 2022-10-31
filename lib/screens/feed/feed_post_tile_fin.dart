import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/post_model.dart';
import 'package:tabzsnappro/models/user_data_models/other_user_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_data_model.dart';
import 'package:tabzsnappro/services/database_service.dart';
import 'package:tabzsnappro/shared/colors.dart';
import 'package:tabzsnappro/shared/loading.dart';

class FeedPostTileFin extends StatefulWidget {
  
  PostModel feedPost;
  FeedPostTileFin(this.feedPost);

  @override
  State<FeedPostTileFin> createState() => _FeedPostTileFinState();
}

class _FeedPostTileFinState extends State<FeedPostTileFin> {
  @override
  Widget build(BuildContext context) {

      final userDetails = Provider.of<UserDataModel?>(context);
      final otherUserDetails = Provider.of<OtherUserDataModel?>(context);

      final DatabaseService _databaseService = DatabaseService();

      bool userHasBlockedPost =false;
      bool userBlockedBy = false;
      bool userHasBlocked = false;

      if(userDetails!=null && otherUserDetails!=null)
      {
         if(widget.feedPost.blockedBy.contains(userDetails.uid))
         {
             userHasBlockedPost = true;
         }

         if(otherUserDetails.blocked.contains(userDetails.uid))
         {
           userBlockedBy=true;
         }

         if(otherUserDetails.blocked_by.contains(userDetails.uid))
         {
            userHasBlocked = true;
         }
      }
      
      return userDetails==null || otherUserDetails==null ? Loading() : userHasBlocked || userBlockedBy || userHasBlockedPost?
       SizedBox() : Container(  
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(  
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: red_main)
        ),
        child: Column(children: [
          Row(children: [
            otherUserDetails.hasProfilePic?
            CircleAvatar(backgroundImage: NetworkImage(otherUserDetails.profilePicUri)) :
            CircleAvatar(backgroundImage: AssetImage('assets/images/usericon.png'),
                         backgroundColor:red_main),
            SizedBox(width: 10,),
            Text(otherUserDetails.name,style: TextStyle(fontSize: 16),),
            Flexible(child: SizedBox(),fit:FlexFit.tight,flex: 1,),
            GestureDetector(
              onTap: (){
                 ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Post reported"),
                          ),
                        );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(  
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow[700]
                ),
                child: Text('Report'),
              ),
            ),
            GestureDetector(
              onTap: () async{

                 await _databaseService.addPostBlock(widget.feedPost.postId,userDetails.uid);

                 ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Post blocked"),
                          ),
                  );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(  
                  borderRadius: BorderRadius.circular(10),
                  color: red_main
                ),
                child: Text('Block',style: TextStyle(color: Colors.white),),
              ),
            )
          ],),
          SizedBox(height: 15,),
          Container(
            width: double.infinity,
            height: 200,
            child: !widget.feedPost.postImageUri.isEmpty ?
            Image(image: NetworkImage(widget.feedPost.postImageUri),fit:BoxFit.cover) :
            Image(image: AssetImage('assets/images/imageicon.png'),fit: BoxFit.cover,) ),
          SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.feedPost.postText,style: TextStyle(fontSize: 16),maxLines: 5,))
        ],)
       );


  }
}