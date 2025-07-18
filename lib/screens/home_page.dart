import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:quick_chat/cubit/chat_history_cubit.dart';
import 'package:quick_chat/helper_files/custom_snack_bar.dart';
import 'package:quick_chat/helper_files/phone_utils.dart';
import 'package:quick_chat/widgets/message_text_field.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../helper_files/default_values.dart';
import '../generated/l10n.dart';
import '../widgets/clipboard_container.dart';
import '../widgets/start_chat_button.dart';
import '../widgets/gap.dart';
import '../widgets/phone_number_text_field.dart';
import '../widgets/recent_numbers_list_tile.dart';
import '../widgets/recent_numbers_section_header.dart';
import '../widgets/section_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigateToHistoryPage});
  final Function(int) navigateToHistoryPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FocusNode _numberFocusNode = FocusNode();
  bool _isClipboardPhoneFound = false;
  String? _clipboardText;
  StreamSubscription<List<SharedMediaFile>>? _mediaStreamSub;

  final selectedCountryCode = ValueNotifier<String>(userSettings.countryCode);
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<ChatHistoryCubit>().loadChatHistory();
    _checkClipboard();
    _setCountryCode();
    _mediaStreamSub = ReceiveSharingIntent.instance.getMediaStream().listen((
      files,
    ) {
      if (files.isNotEmpty) {
        _showDialog(files[0].path);
      }
    });
    // Initial sharing if app launched via share
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showDialog(files[0].path);
        });
      }
    });
    //!test
  }

  @override
  void dispose() {
    _numberFocusNode.dispose();
    _messageFocusNode.dispose();
    _phoneNumberController.dispose();
    _messageController.dispose();
    _mediaStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => _unfocus(),
      child: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.green,
        displacement: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: ListView(
            children: [
              //clipboard container
              if (_isClipboardPhoneFound)
                ClipboardContainer(
                  onTap: () {
                    PhoneUtils.chat(
                      context: context,
                      phoneNumber: _clipboardText!,
                      countryCode: selectedCountryCode.value,
                    );
                    //   _chat(phoneNumber: _clipboardText!);
                  },
                  onLongPress: () {
                    _phoneNumberController.text = _clipboardText!;
                    _numberFocusNode.requestFocus();
                  },
                  phoneNumber: _clipboardText!,
                  trailing: InkWell(
                    onTap: () => setState(() => _isClipboardPhoneFound = false),
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red.shade500,
                    ),
                  ),
                ),
              SectionHeader(title: S.of(context).enter_phone_number),
              VerticalGap(gap: 20),
              //*Phone TextField
              ValueListenableBuilder<String>(
                valueListenable: selectedCountryCode,
                builder: (context, value, _) {
                  return PhoneNumberTextField(
                    phoneNumberController: _phoneNumberController,
                    numberFocusNode: _numberFocusNode,
                    countryCode: userSettings.countryCode,
                    onCountryChanged: (newValue) {
                      selectedCountryCode.value = newValue;
                    },
                  );
                },
              ),
              VerticalGap(gap: 20),
              MessageTextField(
                messageController: _messageController,
                messageFocusNode: _messageFocusNode,
                suffixIcon: IconButton(
                  onPressed: () => _messageController.clear(),
                  icon: Icon(Icons.clear),
                ),
              ),
              VerticalGap(gap: 20),
              //*Chat Button
              ValueListenableBuilder(
                valueListenable: selectedCountryCode,
                builder: (context, value, child) {
                  return StartChatButton(
                    onPressed: () {
                      if (!PhoneUtils.isValidPhoneNumber(
                        _phoneNumberController.text,
                      )) {
                        CustomSnackBar.showErrorSnackBar(
                          context,
                          message: "Invalid Phone Number",
                        );
                        return;
                      }
                      PhoneUtils.chat(
                        context: context,
                        phoneNumber: _phoneNumberController.text,
                        message: _messageController.text,
                        countryCode: selectedCountryCode.value,
                      );
                    },
                  );
                },
              ),
              BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
                builder: (context, state) {
                  if (state is ChatHistoryLoading) {
                    return CircularProgressIndicator();
                  } else if (state is ChatHistoryLoaded) {
                    final displayedChats = state.chats.take(2).toList();
                    return Column(
                      children: [
                        VerticalGap(gap: 30),
                        Divider(),
                        VerticalGap(gap: 20),
                        RecentNumbersSectionHeader(
                          onTap: () {
                            _unfocus();
                            widget.navigateToHistoryPage(1);
                          },
                        ),
                        ListView(
                          shrinkWrap: true, // Takes only the space it needs
                          physics:
                              NeverScrollableScrollPhysics(), // Disables scrolling
                          children: displayedChats
                              .map(
                                (chat) =>
                                    RecentNumberListTile(chatHistory: chat),
                              )
                              .toList(),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              VerticalGap(gap: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _unfocus() {
    _numberFocusNode.unfocus();
    _messageFocusNode.unfocus();
  }

  //!load clipboard
  Future<void> _checkClipboard() async {
    String? newClipboardText;
    bool foundPhone = false;
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final clipboardText = clipboardData?.text;
      if (clipboardData != null &&
          clipboardText != null &&
          clipboardText.isNotEmpty &&
          PhoneUtils.isValidPhoneNumber(clipboardText)) {
        // Check for non-empty
        newClipboardText = clipboardData.text;
        foundPhone = true; // Set this based on actual validation
        if (mounted) {
          // Check if the widget is still in the tree
          CustomSnackBar.showSuccessSnackBar(
            context,
            icon: Icons.copy_rounded,
            message:
                "${S.of(context).clipboard_content}: ${PhoneUtils.cleanPhoneNumber(newClipboardText!)}",
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      newClipboardText = S
          .of(context)
          .failed_to_read_clipboard; // Use localized string

      if (mounted) {
        CustomSnackBar.showErrorSnackBar(context, message: newClipboardText);
      }
    } finally {
      if (mounted) {
        setState(() {
          _clipboardText = newClipboardText;
          _isClipboardPhoneFound = foundPhone;
        });
      }
    }
  }

  void _setCountryCode() {
    selectedCountryCode.value = CountryService()
        .findByCode(userSettings.countryCode)!
        .phoneCode;
  }

  Future<void> _refresh() async {
    _checkClipboard();
  }


  Future<List<String>> extractPhoneNumbers(String text) async {
    // Enhanced regular expression to match phone numbers more reliably
    final phoneRegex = RegExp(
      r'(\+?\d{1,3}[\s-]?)?(\d{3,4}[\s-]?\d{3,4}[\s-]?\d{3,4}|\d{8,14})',
      caseSensitive: false,
      multiLine: false,
    );

    // Find all matches in the text
    final matches = phoneRegex.allMatches(text);

    // Extract and format the matched numbers
    List<String> phoneNumbers = [];
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
  Future<String> _scanImage(String imagePath) async {
    //  RecognizedTex
    final recognizer = TextRecognizer();
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText = await recognizer.processImage(
      inputImage,
    );
    return recognizedText.text;
  }

  void _showDialog(String imagePath) async {
    final text = await _scanImage(imagePath);
    final numbers = await extractPhoneNumbers(text);

    if (!mounted) return;
    if (numbers.isEmpty) {
      // Dialog in case no phone number is found
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.red, width: 0.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 30),
              SizedBox(width: 8),
              Text(
                "No Phone Found",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            "No valid phone number was detected in the image.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Dialog if a phone number is found
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.green, width: 0.5),
        ),
        title: const FittedBox(
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 8),
              Text(
                "Detected Phone",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  numbers.first,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _phoneNumberController.text = numbers.first;
              _numberFocusNode.requestFocus();
              },
            icon: const Icon(Icons.edit, color: Colors.blue),
            label: const Text("Edit", style: TextStyle(color: Colors.blue)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              PhoneUtils.chat(
                context: context,
                phoneNumber: numbers.first,
                countryCode: CountryService()
                    .findByCode(userSettings.countryCode)!
                    .phoneCode,
              );
            },
            icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
            label: const Text("Chat"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
