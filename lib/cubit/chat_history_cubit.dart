import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:quick_chat/hive/chat_history.dart';

part 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  ChatHistoryCubit() : super(ChatHistoryEmpty());
  final _chatHistoryBox = Hive.box<ChatHistory>('chat_history');

  void loadChatHistory() {
    emit(ChatHistoryLoading());
    //if the box is empty
    if (chatBox.isEmpty) {
      emit(ChatHistoryEmpty());
      return;
    }
    List<ChatHistory> chats = [];

    //load chats from box
    for (var chat in _chatHistoryBox.values) {
      chats.add(chat);
    }
// Sort chats by timestamp in descending order (newest first)
    chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    emit(ChatHistoryLoaded(chats: chats));

  }
  Future<void> addChatEntry({required String phone,required String message,required String whatsappLink}) async {
    try {
      final newEntry = ChatHistory(
        message: message,
        phone: phone,
        timestamp: DateTime.now(),
        whatsappLink:whatsappLink ,
      );
      await _chatHistoryBox.add(newEntry);
      // Reload or update the state
      loadChatHistory(); // Or a more optimized update
    } catch (e) {
      emit(ChatHistoryEmpty());
    }
  }

}
