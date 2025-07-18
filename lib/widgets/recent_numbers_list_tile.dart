import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quick_chat/helper_files/phone_utils.dart';
import 'package:quick_chat/hive/chat_history.dart';
import 'package:quick_chat/widgets/custom_tooltip.dart';

class RecentNumberListTile extends StatelessWidget {
  const RecentNumberListTile({
    super.key,
    required this.chatHistory,
  });
  final ChatHistory chatHistory;
  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      message: chatHistory.message.isEmpty?'No Message':'Message: ${chatHistory.message}',

      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListTile(
          onTap: ()async{
            await PhoneUtils.launchWhatsApp(context: context, phone: chatHistory.phone, message: chatHistory.message,countryCode:chatHistory.countryCode!);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.green),
          ),
          leading: const Icon(
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
