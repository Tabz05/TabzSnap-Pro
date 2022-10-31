import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';
import 'package:tabzsnappro/screens/singleChat/single_chat_main.dart';
import 'package:tabzsnappro/services/database_service.dart';
import 'package:tabzsnappro/shared/loading.dart';

class SingleChat extends StatefulWidget {
  
  final String otherId;
  final String otherName;
  SingleChat(this.otherId,this.otherName);

  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {

  @override
  Widget build(BuildContext context) {
      
    final user = Provider.of<UserIdModel?>(context);

    List<String>ids = [user!.uid,widget.otherId];
    ids.sort();

    String chatId = ids[0]+ids[1];

    final DatabaseService _databaseService = DatabaseService(uid: user.uid,otherId: widget.otherId,chatId: chatId);

    return FutureBuilder(
    future: _databaseService.add_chat(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        // Future hasn't finished yet, return a placeholder
        return Loading();
      }
      return snapshot.data==true? SingleChatMain(chatId,widget.otherName) : Loading();
    }
   );
  }
}