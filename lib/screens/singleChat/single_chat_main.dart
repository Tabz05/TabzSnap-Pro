import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/messages_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';
import 'package:tabzsnappro/screens/singleChat/single_chat_fin.dart';
import 'package:tabzsnappro/services/database_service.dart';
import 'package:tabzsnappro/shared/colors.dart';

class SingleChatMain extends StatefulWidget {
  
  final String chatId;
  final String otherName;
  SingleChatMain(this.chatId,this.otherName);

  @override
  State<SingleChatMain> createState() => _SingleChatMainState();
}

class _SingleChatMainState extends State<SingleChatMain> {

  TextEditingController messageToSend = TextEditingController();

  @override
  Widget build(BuildContext context) {
 
    final user = Provider.of<UserIdModel?>(context);
    final DatabaseService _databaseService = DatabaseService(uid:user!.uid,chatId: widget.chatId);
      
    return StreamProvider<List<MessageModel>?>.value(
      catchError:(_,__)=>null,
      initialData: null,
      value: DatabaseService(chatId: widget.chatId).getMessages,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Row(
              children: [
                Text(widget.otherName.toString()),
              ],
            ),
            backgroundColor: red_main,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(children: [
                SingleChatFin(),
                Row(children: [
                  Flexible(
                    flex:3,
                    fit:FlexFit.tight,
                    child: TextField(
                      controller: messageToSend,
                      decoration: InputDecoration(
                        hintText: "Enter message here..."
                      ),
                    )),
                  Flexible(
                    flex:1,
                    fit:FlexFit.tight,
                    child: GestureDetector(
                      onTap: () async{
                         if(!messageToSend.text.isEmpty)
                         {
                            await _databaseService.addMessage(messageToSend.text.toString(),DateTime.now().microsecondsSinceEpoch);
                            messageToSend.clear();
                         }
                      },
                      child: Icon(Icons.send,color: Colors.red,size: 32,)
                    ),
                  )
                ],)
            ],
            
            ),
            
          ),
        )
        )

    );

  }
}