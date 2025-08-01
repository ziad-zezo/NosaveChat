import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/helper_files/phone_utils.dart';

class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({
    super.key,
    required this.phoneNumberController,
    required this.numberFocusNode,
    required this.countryCode,
    required this.onCountryChanged,
  });

  final TextEditingController phoneNumberController;
  final FocusNode numberFocusNode;
  final String countryCode;
  final Function(String) onCountryChanged;
  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: IntlPhoneField(
        controller: widget.phoneNumberController,
        focusNode: widget.numberFocusNode,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              widget.phoneNumberController.clear();
            },
            icon: const Icon(Icons.clear),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          filled: true,
          fillColor: const Color(0x0b008000),
          hintText: S.of(context).hint_phone_number,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        disableLengthCheck: true,
        initialCountryCode: widget.countryCode,
        dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        style: const TextStyle(fontSize: 16),
        cursorColor: Colors.green,
        dropdownTextStyle: const TextStyle(fontSize: 16),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[\d+ ]'),
          ), // يسمح فقط بالأرقام والمسافات وعلامة +
        ],
        onChanged: (phone) {
          _formKey.currentState!.validate();
          setState(() {});
        },
        validator: (phone) {
          if (phone == null || phone.number.isEmpty) {
            return null;
          }
          if (!PhoneUtils.isValidPhoneNumber(phone.number)) {
            return S.of(context).error_invalid_phone;
          }

          return null;
        },
        onCountryChanged: (country) {
          widget.onCountryChanged('+${country.dialCode}');
        },
      ),
    );
  }
}
