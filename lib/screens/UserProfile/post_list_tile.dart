import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/post_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';
import 'package:tabzsnappro/screens/UserProfile/single_post_details.dart';

class PostListTile extends StatefulWidget {
  
  final PostModel postModel;
  PostListTile(this.postModel);

  @override
  State<PostListTile> createState() => _PostListTileState();
}

class _PostListTileState extends State<PostListTile> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserIdModel?>(context);

    bool userHasBlocked=false;

    if(user!=null)
    {
        if(widget.postModel.blockedBy.contains(user.uid))
        {
           userHasBlocked = true;
        }
    }
     
    return user==null? SizedBox(): userHasBlocked? Icon(Icons.block,size:48) :  !widget.postModel.postImageUri.isEmpty ? 
      GestureDetector(
        child: Image(image: NetworkImage(widget.postModel.postImageUri),fit: BoxFit.cover,),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
                       builder: (context) => SinglePostDetails(widget.postModel)));
        },) 
      : GestureDetector(
        child: Image(image: AssetImage('assets/images/imageicon.png'),fit: BoxFit.cover,),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
                       builder: (context) => SinglePostDetails(widget.postModel)));
        },);

      

  }
}