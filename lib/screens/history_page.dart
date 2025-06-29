import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:quick_chat/hive/chat_history.dart';
import 'package:quick_chat/widgets/recent_numbers_list_tile.dart';
import 'package:quick_chat/widgets/section_header.dart';

import '../defalut_values.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<RecentNumberListTile> recentNumbers = [


    RecentNumberListTile(chatHistory: ChatHistory(user: "015540", message: "message", timestamp:( DateTime.now()),)),
  ];
  var box = Hive.box<ChatHistory>('chat_history');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        children: [
          SectionHeader(
            title: "Chat History",
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.solidTrashCan),
              color: Colors.red,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return RecentNumberListTile(chatHistory: box.getAt(index)!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
