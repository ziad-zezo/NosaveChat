part of 'chat_history_cubit.dart';

@immutable
abstract class ChatHistoryState {}

class ChatHistoryLoaded extends ChatHistoryState {

  ChatHistoryLoaded({required this.chats});
  final List<ChatHistory> chats ;
}
class ChatHistoryEmpty extends ChatHistoryState {}
class ChatHistoryLoading extends ChatHistoryState {}


