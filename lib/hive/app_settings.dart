import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 1)
class AppSettings extends HiveObject {

  AppSettings( {
    required this.languageCode,
    required this.isDarkMode,
    required this.countryCode,
    required this.saveRecentNumber,
    this.savedMessage,
  });
  @HiveField(0)
  final String languageCode; // 'en' or 'ar'

  @HiveField(1)
  final bool isDarkMode;

  @HiveField(2)
  final String countryCode; //  'EG', 'US'

  @HiveField(3)
  final bool saveRecentNumber;
@HiveField(4)
  final String? savedMessage;

  AppSettings copyWith({
    String? languageCode,
    bool? isDarkMode,
    String? countryCode,
    bool? saveRecentNumber,
    String? savedMessage,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      countryCode: countryCode ?? this.countryCode,
      saveRecentNumber: saveRecentNumber ?? this.saveRecentNumber,
      savedMessage: savedMessage ?? this.savedMessage,
    );
  }
}
