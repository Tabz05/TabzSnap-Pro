import 'dart:io'; // for File

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tabzsnappro/models/user_data_models/blocked_data_model.dart';
import 'package:tabzsnappro/models/chat_model.dart';
import 'package:tabzsnappro/models/messages_model.dart';
import 'package:tabzsnappro/models/user_data_models/other_user_data_model.dart';
import 'package:tabzsnappro/models/post_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/follower_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/following_data_model.dart';

class DatabaseService {

  final String? uid;
  final String? otherId;
  final String? chatId;
  final String? otherUserProfileId;
  final String? usernameToSearch;
  final List<dynamic>? followersList;
  final List<dynamic>? followingsList;
  final List<dynamic>? blockedList;

  DatabaseService(
      {this.uid,
      this.otherId,
      this.chatId,
      this.otherUserProfileId,
      this.usernameToSearch,
      this.followersList,
      this.followingsList,
      this.blockedList});

  //collection reference (users)
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  //collection reference (chats)
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("chats");

  //collection reference (posts)
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection("posts");

  //firebase storage profile pic reference
  Reference firebaseStorageProfilePic =
      FirebaseStorage.instance.ref().child("profile pictures");

  //firebase storage posts reference
  Reference firebaseStoragePostsImages =
      FirebaseStorage.instance.ref().child("posts images");

  //for creating user data
  Future createUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      'uid': uid!,
      'name': name,
      'email': email,
      'followers': [],
      'followings': [],
      'blocked': [],
      'blocked_by':[],
      'profilePicUri': "",
      'hasProfilePic': false
    });
  }

  //user data from snapshot
  UserDataModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserDataModel(
        snapshot['uid'],
        snapshot['name'],
        snapshot['email'],
        snapshot['followers'],
        snapshot['followings'],
        snapshot['blocked'],
        snapshot['blocked_by'],
        snapshot['profilePicUri'],
        snapshot['hasProfilePic']);
  }

  //other user data from snapshot
  OtherUserDataModel _otherUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return OtherUserDataModel(
        snapshot['uid'],
        snapshot['name'],
        snapshot['email'],
        snapshot['followers'],
        snapshot['followings'],
        snapshot['blocked'],
        snapshot['blocked_by'],
        snapshot['profilePicUri'],
        snapshot['hasProfilePic']);
  }

  //user list from snapshot

  List<UserDataModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return UserDataModel(
            doc.get("uid"),
            doc.get("name"),
            doc.get("email"),
            doc.get("followers"),
            doc.get("followings"),
            doc.get("blocked"),
            doc.get("blocked_by"),
            doc.get("profilePicUri"),
            doc.get("hasProfilePic"));
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //follower list from snapshot

  List<FollowerDataModel> _followerListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return FollowerDataModel(
            doc.get("uid"),
            doc.get("name"),
            doc.get("email"),
            doc.get("followers"),
            doc.get("followings"),
            doc.get("blocked"),
            doc.get("blocked_by"),
            doc.get("profilePicUri"),
            doc.get("hasProfilePic"));
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //following list from snapshot

  List<FollowingDataModel> _followingListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return FollowingDataModel(
            doc.get("uid"),
            doc.get("name"),
            doc.get("email"),
            doc.get("followers"),
            doc.get("followings"),
            doc.get("blocked"),
            doc.get("blocked_by"),
            doc.get("profilePicUri"),
            doc.get("hasProfilePic"));
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //blocked list from snapshot
  List<BlockedDataModel> _blockedListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return BlockedDataModel(
            doc.get("uid"),
            doc.get("name"),
            doc.get("email"),
            doc.get("followers"),
            doc.get("followings"),
            doc.get("blocked"),
            doc.get("blocked_by"),
            doc.get("profilePicUri"),
            doc.get("hasProfilePic"));
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //post list from snapshot

  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return PostModel(
            doc.get("postText"),
            doc.get("postImageUri"),
            doc.get("postVideoUri"),
            doc.get("owner"),
            doc.get("blockedBy"),
            doc.id);
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //message from snapshot

  List<MessageModel> _messageListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return MessageModel(
          doc.get("text"),
          doc.get("sender"),
          doc.get("timeStampMicro"),
        );
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //chat from snapshot

  List<ChatModel> _chatListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return ChatModel(doc.get("chat_id"), doc.get("recipients"));
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //create new chat
  Future<bool?> add_chat() async {
    await chatCollection.doc(chatId).set({
      'recipients': [uid, otherId],
      'chat_id': chatId
    });

    return true;
  }

  //for adding new message
  Future addMessage(String text, int timeStampMicro) async {
    await chatCollection
        .doc(chatId)
        .collection("messages")
        .add({'text': text, 'sender': uid, 'timeStampMicro': timeStampMicro});
  }

  //for finding username of provided id
  Future<String?> getUserName(String otherPersonId) async {
    dynamic result = await userCollection.doc(otherPersonId).get();

    return result["name"];
  }

  //for following a user
  Future follow(String userId, String userToFollowId) async {
    var newFollowerToAdd = [userId];
    await userCollection
        .doc(userToFollowId)
        .update({'followers': FieldValue.arrayUnion(newFollowerToAdd)});

    var newFollowingToAdd = [userToFollowId];
    await userCollection
        .doc(userId)
        .update({'followings': FieldValue.arrayUnion(newFollowingToAdd)});
  }

  //for unfollowing a user
  Future unfollow(String userId, String userToFollowId) async {
    var followerToRemove = [userId];
    await userCollection
        .doc(userToFollowId)
        .update({'followers': FieldValue.arrayRemove(followerToRemove)});

    var followingToRemove = [userToFollowId];
    await userCollection
        .doc(userId)
        .update({'followings': FieldValue.arrayRemove(followingToRemove)});
  }

  //for blocking a user
  Future addBlock(String userId, String userToBlockId) async {

    try{
       var followerToRemove = [userId];

        await userCollection
          .doc(userToBlockId)
          .update({'followers': FieldValue.arrayRemove(followerToRemove)});
    }catch(e)
    {

    }

    try{
      
      var followerToRemove = [userToBlockId];

        await userCollection
          .doc(userId)
          .update({'followers': FieldValue.arrayRemove(followerToRemove)});
    }catch(e)
    {

    }

    try{
       var followingToRemove = [userToBlockId];

       await userCollection
        .doc(userId)
        .update({'followings': FieldValue.arrayRemove(followingToRemove)});
    }catch(e)
    {

    }
    
    try{
      
      var followingToRemove = [userId];

       await userCollection
        .doc(userToBlockId)
        .update({'followings': FieldValue.arrayRemove(followingToRemove)});

    }catch(e)
    {
        print(e);
    }

    var userToBlock = [userToBlockId];

    await userCollection
          .doc(userId) 
          .update({'blocked': FieldValue.arrayUnion(userToBlock)});
    
    var userBlockedBy = [userId];

    await userCollection
          .doc(userToBlockId) 
          .update({'blocked_by': FieldValue.arrayUnion(userBlockedBy)});
  }

  //for unblocking a user
  Future unBlock(String userId, String userToUnBlockId) async {

    var userToUnBlock = [userToUnBlockId];

    await userCollection
          .doc(userId) 
          .update({'blocked': FieldValue.arrayRemove(userToUnBlock)});
    
    var userBlockedBy = [userId];

    await userCollection
          .doc(userToUnBlockId) 
          .update({'blocked_by': FieldValue.arrayRemove(userBlockedBy)});
  }

  //for blocking a post
  Future addPostBlock(String postId, String userId) async {
    
    var newBlockToAdd = [userId];

    await postCollection
        .doc(postId)
        .update({'blockedBy': FieldValue.arrayUnion(newBlockToAdd)});
  }

  //stream for getting user details
  Stream<UserDataModel?> get userDetails {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //stream for getting user details
  Stream<OtherUserDataModel?> get otherUserDetails {
    return userCollection
        .doc(otherUserProfileId)
        .snapshots()
        .map(_otherUserDataFromSnapshot);
  }

  //stream for getting users
  Stream<List<UserDataModel>> get getUsers {

    if(usernameToSearch!=null && usernameToSearch!.isEmpty)
    {
        return userCollection
        .where('uid',whereNotIn: blockedList)
        .snapshots()
        .map(_userListFromSnapshot);
    }
    else
    {
         return userCollection
        .where('uid',whereNotIn: blockedList)
        .where('name',isEqualTo: usernameToSearch)
        .snapshots()
        .map(_userListFromSnapshot);
    }
  }

  //stream for getting followers of a user
  Stream<List<FollowerDataModel>> get otherUserFollowers {
  
      return userCollection
        .where('uid', whereIn: followersList)
        .snapshots()
        .map(_followerListFromSnapshot);
    
  }

  //stream for getting followings of a user
  Stream<List<FollowingDataModel>> get otherUserFollowings {
    
      return userCollection
        .where('uid', whereIn: followingsList)
        .snapshots()
        .map(_followingListFromSnapshot);
    
  }

  //stream for getting blocked users of a user
  Stream<List<BlockedDataModel>> get myBlocked {
    
      return userCollection
        .where('uid', whereIn: blockedList)
        .snapshots()
        .map(_blockedListFromSnapshot);
    
  }

  //stream for getting messages in a single chat
  Stream<List<MessageModel>> get getMessages {
    return chatCollection
        .doc(chatId)
        .collection("messages")
        .orderBy("timeStampMicro")
        .snapshots()
        .map(_messageListFromSnapshot);
  }

  //stream for getting all the chats of current user
  Stream<List<ChatModel>> get getMyChats {
    return chatCollection
        .where('recipients', arrayContainsAny: [uid])
        .snapshots()
        .map(_chatListFromSnapshot);
  }

  //stream for getting posts of a user
  Stream<List<PostModel>> get otherUserPosts {
    return postCollection
        .where('owner', isEqualTo: otherUserProfileId)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  //stream for getting feed of a user
  Stream<List<PostModel>> get myFeed {
    return postCollection
        .where('owner', whereIn: followingsList)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  //for uploading profile picture

  Future uploadProfilePic(File imageFile) async {
    Reference userProfilePic = firebaseStorageProfilePic.child(uid!);
    UploadTask uploadTask = userProfilePic.putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      Future<String> url = userProfilePic.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });

    dynamic profilePicUri = await taskSnapshot.ref.getDownloadURL();

    await userCollection.doc(uid!).update({'hasProfilePic': true});

    await userCollection.doc(uid!).update({'profilePicUri': profilePicUri});
  }

  //for creating new post
  Future createNewPost(String text, File? imageFile) async {

    String postImageUri = "";
    String postVideoUri="";

    if (imageFile != null) {
      Reference userPostImage = firebaseStoragePostsImages.child(uid!+imageFile.toString());
      UploadTask uploadTask = userPostImage.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        //Future<String> url = .getDownloadURL();
      }).catchError((onError) {
        print(onError);
      });

      postImageUri = await taskSnapshot.ref.getDownloadURL();
    }

    await postCollection.add({
        'postText': text,
        'postImageUri':postImageUri,
        'postVideoUri':postVideoUri,
        'owner':uid,
        'blockedBy':[]
    });
  }
}
