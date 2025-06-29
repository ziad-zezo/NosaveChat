import 'package:hive/hive.dart';

part 'chat_history.g.dart'; // Needed for the generated file

@HiveType(typeId: 0)
class ChatHistory extends HiveObject {
  @HiveField(0)
  final String user;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final DateTime timestamp;

  ChatHistory({required this.user, required this.message, required this.timestamp});
}
