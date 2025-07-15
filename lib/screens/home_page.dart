import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_chat/helper_files/boxes.dart';
import 'package:quick_chat/cubit/chat_history_cubit.dart';
import 'package:quick_chat/helper_files/phone_utils.dart';
import 'package:quick_chat/widgets/message_text_field.dart';
import '../helper_files/default_values.dart';
import '../generated/l10n.dart';
import '../widgets/clipboard_container.dart';
import '../widgets/custom_button.dart';
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
  }

  @override
  void dispose() {
    _numberFocusNode.dispose();
    _messageFocusNode.dispose();
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
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("You can edit now")));
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
                  return CustomButton(
                    onPressed: () {
                      PhoneUtils.chat(
                        context: context,
                        phoneNumber: _phoneNumberController.text,
                        message: _messageController.text,
                        countryCode: selectedCountryCode.value,
                      );
                    },
                  );
                  //_chat);
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${S.of(context).clipboard_content}: $newClipboardText",
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      newClipboardText = S
          .of(context)
          .failed_to_read_clipboard; // Use localized string

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newClipboardText),
            backgroundColor: Colors.red,
          ),
        );
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

  Future<void> _chat({String? phoneNumber}) async {
    final String? whatsappLink = await PhoneUtils.launchWhatsApp(
      context: context,
      phone: phoneNumber ?? _phoneNumberController.text,
      message: _messageController.text,
      countryCode: selectedCountryCode.value,
    );

    if (!mounted || whatsappLink == null) return;
    context.read<ChatHistoryCubit>().addChatEntry(
      phone: phoneNumber ?? _phoneNumberController.text,
      message: _messageController.text,
      whatsappLink: whatsappLink,
    );
  }

  Future<void> _refresh() async {
    _checkClipboard();
  }
}
