import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quick_chat/cubit/chat_history_cubit.dart';
import 'package:quick_chat/helper_files/custom_snack_bar.dart';

class PhoneUtils {
  static String cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  static bool isValidPhoneNumber(String phone) {
    final cleanedPhone = cleanPhoneNumber(phone);
    if (RegExp(r'[^0-9+]').hasMatch(cleanedPhone)) {
      return false; // Invalid characters found
    }
    if (cleanedPhone.length >= 8 && cleanedPhone.length <= 15) {
      return true;
    }
    return false;
  }

  static String addCountryCode(String phone, String countryCode) {
    final cleanedPhone = cleanPhoneNumber(phone);
    if (cleanedPhone.startsWith('+')) {
      return cleanedPhone;
    }
    if (cleanedPhone.startsWith('00')) {
      return '+${cleanedPhone.substring(2)}';
    }
    return '+$countryCode${cleanedPhone.replaceFirst(RegExp(r'^0+'), '')}';
  }

  static Future<String?> launchWhatsApp({
    required BuildContext context,
    required String phone,
    required String message,
    required String countryCode,
  }) async {
    try {
      final fullPhone = addCountryCode(phone, countryCode);

      final encodedMessage = Uri.encodeComponent(message);

      final url = 'https://wa.me/$fullPhone?text=$encodedMessage';
      final urlParsed = Uri.parse(url);

      await launchUrl(urlParsed);
      if (context.mounted) {
        CustomSnackBar.showSuccessSnackBar(context,message:  'Chat started with $fullPhone');

      }
      return urlParsed.toString();
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showErrorSnackBar(context,message:  'Failed to launch WhatsApp');

      }
      }
    return null;
  }
  static Future<void> chat({required BuildContext context, required String phoneNumber,String message='',required String countryCode}) async {
    final String? whatsappLink = await PhoneUtils.launchWhatsApp(
      context: context,
      phone: phoneNumber,
      message: message,
      countryCode: countryCode,
    );
    if (!context.mounted || whatsappLink == null || ! userSettings.saveRecentNumber) return;
    context.read<ChatHistoryCubit>().addChatEntry(
      phone: phoneNumber,
      message:message,
      whatsappLink: whatsappLink,
      countryCode: countryCode,
    );
  }
}
