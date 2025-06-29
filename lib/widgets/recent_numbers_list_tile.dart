import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quick_chat/hive/chat_history.dart';

class RecentNumberListTile extends StatelessWidget {
  const RecentNumberListTile({super.key, required this.chatHistory,});
// final String title ;
// final String subtitle ;
final ChatHistory chatHistory ;

  @override
  Widget build(BuildContext context) {
   return ListTile(
      onTap: () {},

      leading: Icon(FontAwesomeIcons.whatsapp,size: 32,color: Colors.green,),
      title: Text(chatHistory.user),
      subtitle: Text(chatHistory.message,style: TextStyle(
        color: Colors.green.shade300
      ),),
      trailing:Text(chatHistory.timestamp.toString()) ,
      // isThreeLine: true,
    );
  }
}

//DateFormat('MM/dd hh:mm a').format( DateTime.now())