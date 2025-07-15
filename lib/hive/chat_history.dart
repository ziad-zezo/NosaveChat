import 'package:hive/hive.dart';

part 'chat_history.g.dart'; // Needed for the generated file

@HiveType(typeId: 0)
class ChatHistory extends HiveObject {
  @HiveField(0)
  final String phone;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final DateTime timestamp;
  @HiveField(3)
  final String whatsappLink;

  ChatHistory( {required this.phone, required this.message, required this.timestamp,required this.whatsappLink});
}
