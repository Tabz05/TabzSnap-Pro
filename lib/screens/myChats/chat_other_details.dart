import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/chat_model.dart';
import 'package:tabzsnappro/models/user_data_models/other_user_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';
import 'package:tabzsnappro/screens/myChats/chat_tile.dart';
import 'package:tabzsnappro/screens/singleChat/single_chat.dart';
import 'package:tabzsnappro/services/database_service.dart';

class ChatOtherDetails extends StatefulWidget {
  
  final ChatModel chatModel;
  ChatOtherDetails(this.chatModel);

  @override
  State<ChatOtherDetails> createState() => _ChatOtherDetailsState();
}

class _ChatOtherDetailsState extends State<ChatOtherDetails> {

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserIdModel?>(context);

    var recipient1 = widget.chatModel.recipients[0];
    var recipient2 = widget.chatModel.recipients[1];

    String otherPersonId ="";
    final String otherPersonName;

    if(recipient1==user!.uid)
    {
      otherPersonId = recipient2;
    }
    else
    {
      otherPersonId = recipient1;
    }

    return StreamProvider<OtherUserDataModel?>.value(
      catchError:(_,__)=>null,
      initialData: null,
      value: DatabaseService(otherUserProfileId: otherPersonId).otherUserDetails,
      child: ChatTile()
    );
  }
}