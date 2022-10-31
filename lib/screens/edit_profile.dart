import 'dart:io';   // for File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/user_data_models/user_data_model.dart';
import 'package:tabzsnappro/services/database_service.dart';
import 'package:tabzsnappro/shared/colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  File? imageFile=null;
  final picker = ImagePicker();

   Future imgFromGallery() async{
       
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
        });
      }
   }

   Future imgFromCamera() async{
       
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
        });
      }
   }

  @override
  Widget build(BuildContext context) {

    final userDetails = Provider.of<UserDataModel?>(context);

    final DatabaseService _databaseService = DatabaseService(uid: userDetails!.uid);
    
      return SafeArea( 
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(  
              backgroundColor: red_main,
              title: Text('Edit Profile'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(  
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                child: Column(  
                  children: [
                    SizedBox(height: 30,),
                    !userDetails.hasProfilePic && imageFile==null? 
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/images/usericon.png'),
                      backgroundColor:red_main
                    ):
                    imageFile!=null?
                    CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(imageFile!)
                      ):
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(userDetails.profilePicUri)
                      ),
                    
                    SizedBox(height: 40,),
                    Row(
                      children: [
                        Flexible(child: SizedBox(),flex: 1,fit:FlexFit.tight,),
                        GestureDetector(
                          onTap: () async{
                            await imgFromGallery();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.image,color: Colors.white,),
                                SizedBox(width: 5,),
                                Text('Choose from gallery',style: TextStyle(color: Colors.white,fontSize: 16)),
                              ],
                            ),
                            decoration: BoxDecoration(  
                              color: red_main,
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                        ),
                        Flexible(child: SizedBox(),flex: 1,fit:FlexFit.tight,),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        Flexible(child: SizedBox(),flex: 1,fit:FlexFit.tight,),
                        GestureDetector(
                          onTap: () async{
                            await imgFromCamera();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.camera,color: Colors.white,),
                                SizedBox(width: 5,),
                                Text('Choose from camera',style: TextStyle(color: Colors.white,fontSize: 16)),
                              ],
                            ),
                            decoration: BoxDecoration(  
                              color: red_main,
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                        ),
                        Flexible(child: SizedBox(),flex: 1,fit:FlexFit.tight,),
                      ],
                    ),
                    imageFile==null? SizedBox(height: 40,):
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                               imageFile = null;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(  
                              borderRadius: BorderRadius.circular(20),
                              color: red_main,
                            ),
                            
                            child: Text('Remove',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                    GestureDetector(
                      onTap:() async{
                         imageFile!=null? await _databaseService.uploadProfilePic(imageFile!)
                         :print("pressed");
                      },
                      child: Container(
                        child: Text('Submit',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(   
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.yellow[600]
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
          ),
      );

  }
}