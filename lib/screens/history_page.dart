import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_chat/cubit/chat_history_cubit.dart';
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:quick_chat/hive/chat_history.dart';
import 'package:quick_chat/widgets/gap.dart';
import 'package:quick_chat/widgets/recent_numbers_list_tile.dart';
import 'package:quick_chat/widgets/section_header.dart';
import '../helper_files/default_values.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatHistoryCubit>().loadChatHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
      builder: (context, state) {
        if (state is ChatHistoryLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ChatHistoryLoaded) {
          final List<ChatHistory> recentNumbers = state.chats;
          //   recentNumbers.addAll(state.chats);

          return Container(
           // width: MediaQuery.of(context).size.width * 0.95,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ), //defaultPadding),

            child: ListView.builder(
              //shrinkWrap: true,
             physics:BouncingScrollPhysics(),
              itemCount: recentNumbers.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding / 2,
                    ),
                    child: SectionHeader(
                      title: "Chat History",
                      trailing: InkWell(
                        onTap: _deleteChatHistory,
                        child: Icon(
                          Icons.delete_sweep_sharp,
                          color: Colors.red.shade500,
                          size: 28,
                        ),
                      ),
                    ),
                  );
                }
                return Dismissible(
                  key: ValueKey(recentNumbers[index - 1].key),
                  direction: DismissDirection.endToStart,
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      HorizontalGap(gap: 5),
                      Text("Delete", style: TextStyle(color: Colors.red)),
                      HorizontalGap(gap: 8),
                    ],
                  ),
                  onDismissed: (direction) {
                    chatBox.delete(recentNumbers[index - 1].key);
                    context.read<ChatHistoryCubit>().loadChatHistory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Chat history deleted")),
                    );
                    HapticFeedback.lightImpact();
                  },

                  child: RecentNumberListTile(
                    chatHistory: recentNumbers[index - 1],
                  ),
                );
              },
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding * 2),
            child: Center(
              child: Text(
                "No Chat History",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
          );
        }
      },
    );
  }

  void _deleteChatHistory() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text("Confirm Deletion"),
            ],
          ),
          content: Text(
            "Are you sure you want to delete all chat history? This action cannot be undone.",
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color?.withAlpha(200),
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Yes, Delete"),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await chatBox.clear();
      if (!mounted) return;
      context.read<ChatHistoryCubit>().loadChatHistory();
    }
  }
}
