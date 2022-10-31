import 'package:firebase_auth/firebase_auth.dart';

class FollowerDataModel{
    
    final String uid;
    final String name;
    final String email;

    var followers = [];
    var followings = [];
    var blocked=[];
    var blocked_by=[];

    final String profilePicUri;
    final bool hasProfilePic;

    FollowerDataModel(this.uid,this.name,this.email,this.followers,this.followings,this.blocked,this.blocked_by,this.profilePicUri,this.hasProfilePic);

}