import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quick_chat/cubit/chat_history_cubit.dart';
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:quick_chat/helper_files/custom_snack_bar.dart';
import 'package:quick_chat/helper_files/default_values.dart';
import 'package:quick_chat/helper_files/phone_utils.dart';
import 'package:quick_chat/helper_files/scan_image.dart';
import 'package:quick_chat/widgets/clipboard_container.dart';
import 'package:quick_chat/widgets/custom_tooltip.dart';
import 'package:quick_chat/widgets/gap.dart';
import 'package:quick_chat/widgets/message_text_field.dart';
import 'package:quick_chat/widgets/phone_number_text_field.dart';
import 'package:quick_chat/widgets/recent_numbers_list_tile.dart';
import 'package:quick_chat/widgets/recent_numbers_section_header.dart';
import 'package:quick_chat/widgets/section_header.dart';
import 'package:quick_chat/widgets/start_chat_button.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

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
              const VerticalGap(gap: 20),
              //*Phone TextField
              ValueListenableBuilder<String>(
                valueListenable: selectedCountryCode,
                builder: (context, value, _) {
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: PhoneNumberTextField(
                      phoneNumberController: _phoneNumberController,
                      numberFocusNode: _numberFocusNode,
                      countryCode: userSettings.countryCode,
                      onCountryChanged: (newValue) {
                        selectedCountryCode.value = newValue;
                      },
                    ),
                  );
                },
              ),
              const VerticalGap(gap: 20),
              MessageTextField(
                messageController: _messageController,
                messageFocusNode: _messageFocusNode,
                suffixIcon: IconButton(
                  onPressed: () {
                    if (_messageController.text.isEmpty) {
                      _messageController.text = userSettings.savedMessage!;
                      if (userSettings.savedMessage!.isEmpty) {
                        CustomSnackBar.showErrorSnackBar(
                          context,
                          message: S.of(context).saved_message_empty,
                        );
                      } else {
                        CustomSnackBar.showSuccessSnackBar(
                          context,
                          message: S.of(context).message_added,
                        );
                      }
                    } else {
                      _messageController.clear();
                    }

                    setState(() {});
                  },
                  icon: buildIcon(),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const VerticalGap(gap: 20),
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
                          message: S.of(context).invalid_phone_number,
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
                    return const CircularProgressIndicator();
                  } else if (state is ChatHistoryLoaded) {
                    final displayedChats = state.chats.take(2).toList();
                    return Column(
                      children: [
                        const VerticalGap(gap: 30),
                        const Divider(),
                        const VerticalGap(gap: 20),
                        RecentNumbersSectionHeader(
                          onTap: () {
                            _unfocus();
                            widget.navigateToHistoryPage(1);
                          },
                        ),
                        ListView(
                          shrinkWrap: true, // Takes only the space it needs
                          physics:
                              const NeverScrollableScrollPhysics(), // Disables scrolling
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
                    return const SizedBox.shrink();
                  }
                },
              ),
              const VerticalGap(gap: 20),
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
          isAllDigits(clipboardText) &&
          PhoneUtils.isValidPhoneNumber(clipboardText)) {
        newClipboardText = PhoneUtils.cleanPhoneNumber(clipboardData.text!);
        foundPhone = true; // Set this based on actual validation
        if (mounted) {
          // Check if the widget is still in the tree
          CustomSnackBar.showSuccessSnackBar(
            context,
            icon: Icons.copy_rounded,
            message: S.of(context).clipboard_content,
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

  bool isAllDigits(String input) {
    return RegExp(r'^[\d\s\+]+$').hasMatch(input);
  }

  void _setCountryCode() {
    selectedCountryCode.value = CountryService()
        .findByCode(userSettings.countryCode)!
        .phoneCode;
  }

  Future<void> _refresh() async {
    _checkClipboard();
  }

  void _showDialog(String imagePath) async {
    final text = await scanImage(imagePath);
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
          title: Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 30),
              const SizedBox(width: 8),
              Text(
                S.of(context).no_phone_found,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(S.of(context).no_phone_found_desc),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).ok),
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
        title: FittedBox(
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 30),
              const SizedBox(width: 8),
              Text(
                S.of(context).detected_phone,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
            label: Text(
              S.of(context).edit,
              style: const TextStyle(color: Colors.blue),
            ),
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
            label: Text(S.of(context).chat),
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

  Widget buildIcon() {
    const clearIcon = Icon(Icons.clear);
    final messageIcon = CustomTooltip(
      message: S.of(context).saved_message,
      child: Icon(
        Icons.add_comment_sharp,
        color:
            userSettings.savedMessage != null &&
                userSettings.savedMessage!.isNotEmpty
            ? Colors.green
            : null,
      ),
    );
    return _messageController.text.isEmpty ? messageIcon : clearIcon;
  }
}
