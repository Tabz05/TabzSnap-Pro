import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tabzsnappro/models/user_data_models/blocked_data_model.dart';
import 'package:tabzsnappro/models/user_data_models/user_data_model.dart';
import 'package:tabzsnappro/screens/blocked%20list/blocked_list_fin.dart';
import 'package:tabzsnappro/services/database_service.dart';
import 'package:tabzsnappro/shared/loading.dart';

class BlockedList extends StatefulWidget {
  const BlockedList({super.key});

  @override
  State<BlockedList> createState() => _BlockedListState();
}

class _BlockedListState extends State<BlockedList> {
  @override
  Widget build(BuildContext context) {
       
    final userDetails = Provider.of<UserDataModel?>(context);

    List<dynamic> blockedList = [];

    if(userDetails!=null)
    {
      blockedList = userDetails.blocked.toList();
      blockedList.add('#');
    }

    return userDetails==null? Loading() : StreamProvider<List<BlockedDataModel>?>.value(
                catchError:(_,__)=>null,
                initialData: null,
                value: DatabaseService(uid:userDetails.uid,blockedList: blockedList).myBlocked,
                child: BlockedListFin()
                  );
    
  }
}