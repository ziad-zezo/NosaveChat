part of 'chat_history_cubit.dart';

@immutable
abstract class ChatHistoryState {}

class ChatHistoryLoaded extends ChatHistoryState {
  final List<ChatHistory> chats ;

  ChatHistoryLoaded({required this.chats});
}
class ChatHistoryEmpty extends ChatHistoryState {}
class ChatHistoryLoading extends ChatHistoryState {}


