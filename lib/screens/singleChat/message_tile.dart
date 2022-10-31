import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/messages_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_id_model.dart';

class MessageTile extends StatefulWidget {
  
  final MessageModel messageModel;
  MessageTile(this.messageModel);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserIdModel?>(context);

    bool isSender = widget.messageModel.sender==user!.uid;
      
    return isSender? Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 5,),
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            color: Colors.red[100]),
            child: Text(widget.messageModel.text)
          ),
        SizedBox(height: 5,),
      ],
    ) : 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            color: Colors.blue[100]),
            child: Text(widget.messageModel.text)
            
          ),
        SizedBox(height: 5,),
      ],
    );

  }
}