import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

Future<String> scanImage(String imagePath) async {
  final recognizer = TextRecognizer();

  // Read the image file
  final fileBytes = await File(imagePath).readAsBytes();
  final image = img.decodeImage(fileBytes);

  // In case image decoding fails
  if (image == null) return '';

  // Dynamically calculate crop sizes

  // Crop the image
  final cropped = img.copyCrop(
    image,
    x: 0,
    y: 0, // cropTop,
    width: image.width,
    height: image.height, //croppedHeight,
  );

  // Convert cropped image to bytes
  final croppedBytes = Uint8List.fromList(img.encodeJpg(cropped));

  // Save to a temporary file
  final tempDir = Directory.systemTemp;
  final tempFile = await File('${tempDir.path}/cropped_image.jpg').create();
  await tempFile.writeAsBytes(croppedBytes);

  // Run text recognition
  final inputImage = InputImage.fromFile(tempFile);
  final recognizedText = await recognizer.processImage(inputImage);
  return recognizedText.text;
}

Future<List<String>> extractPhoneNumbers(String text) async {
  // Enhanced regular expression to match phone numbers more reliably
  final phoneRegex = RegExp(
    r'(\+?\d{1,3}[\s-]?)?(\d{3,4}[\s-]?\d{3,4}[\s-]?\d{3,4}|\d{8,14})',
    caseSensitive: false,
  );

  // Find all matches in the text
  final matches = phoneRegex.allMatches(text);

  // Extract and format the matched numbers
  final List<String> phoneNumbers = [];
  for (final match in matches) {
    String number = match.group(0)!;

    // Remove all non-digit characters except leading +
    number = number.replaceAll(RegExp(r'(?!^\+)[^\d]'), '');

    // Validate the number length (adjust according to your needs)
    if (number.length >= 8 && number.length <= 15) {
      phoneNumbers.add(number);
    }
  }

  return phoneNumbers;
}
