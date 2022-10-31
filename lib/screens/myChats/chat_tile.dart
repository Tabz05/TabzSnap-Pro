import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/user_data_models/other_user_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';
import 'package:tabzsnappro/screens/singleChat/single_chat.dart';
import 'package:tabzsnappro/shared/loading.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({super.key});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    
    final userDetials = Provider.of<UserDataModel?>(context);
    final otherUserDetails = Provider.of<OtherUserDataModel?>(context);

    bool blocked=false;

    if(userDetials!=null && otherUserDetails!=null)
    {
        if(userDetials.blocked.contains(otherUserDetails.uid) ||
           userDetials.blocked_by.contains(otherUserDetails.uid))
           {
             blocked = true;
           }
    }

    return userDetials==null || otherUserDetails==null ? SizedBox() : 
           blocked? SizedBox() : 
           GestureDetector(
            onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SingleChat(otherUserDetails.uid,otherUserDetails.name)));
            },
             child: ListTile(  
                  leading: otherUserDetails.hasProfilePic? 
                           CircleAvatar( 
                            backgroundImage: NetworkImage(otherUserDetails.profilePicUri),
                           ) :
                           CircleAvatar(
                            backgroundImage: AssetImage('assets/images/usericon.png'),
                           ),
                  title: Text(otherUserDetails.name),
             ),
           );

  }
}