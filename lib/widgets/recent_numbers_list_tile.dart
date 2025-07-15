import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quick_chat/hive/chat_history.dart';

import 'custom_tooltip.dart';

class RecentNumberListTile extends StatelessWidget {
  const RecentNumberListTile({
    super.key,
    required this.chatHistory,
    this.onTap,
  });
  final ChatHistory chatHistory;
  //final VoidCallback() onTap;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      message: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Your Chat With ", style: TextStyle(color: Colors.white)),
              Text(chatHistory.phone, style: TextStyle(color: Colors.green)),
            ],
          ),
          Text(
            "Was in ${DateFormat('MM/dd hh:mm a').format(chatHistory.timestamp)}",
            style: TextStyle(color: Colors.white),
          ),
          if (chatHistory.message.isNotEmpty)
            Text(
              "Your message was ${chatHistory.message}",
              style: TextStyle(color: Colors.white),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.green),
          ),
          leading: Icon(
            FontAwesomeIcons.whatsapp,
            size: 32,
            color: Colors.green,
          ),
          title: Text(chatHistory.phone),
          subtitle: chatHistory.message.isNotEmpty
              ? Text(
                  chatHistory.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  //style: TextStyle(color: Colors.white),
                )
              : Text(
                  'No Message',
                  style: TextStyle(color: Colors.orange.shade700.withAlpha(200)),
                ),
          trailing: Text(
            DateFormat('MM/dd hh:mm a').format(chatHistory.timestamp),
          ),
          // isThreeLine: true,
        ),
      ),
    );
  }
}
