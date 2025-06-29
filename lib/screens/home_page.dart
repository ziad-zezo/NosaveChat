import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:quick_chat/hive/chat_history.dart';

import '../defalut_values.dart';
import '../widgets/clipboard_contact_list_tile.dart';
import '../widgets/custom_button.dart';
import '../widgets/gap.dart';
import '../widgets/recent_numbers_list_tile.dart';
import '../widgets/recent_numbers_section_header.dart';
import '../widgets/section_header.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
  final FocusNode _numberFocusNode = FocusNode();
  var chatHistoryBox=Hive.box<ChatHistory>('chat_history');
TextEditingController _phoneNumberController=TextEditingController();
TextEditingController _messageController=TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: () => _unfocus(),
     child: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
         child: Column(
           children: [
             //clipboard container
            SectionHeader(title: "Clipboard"),
VerticalGap(gap: 20),
             //contacts container
            ClipboardContactListTile(),
            VerticalGap(gap: 30),
             SectionHeader(title: "Enter Number"),
             VerticalGap(gap: 20),
             //TextField

                 IntlPhoneField(
controller: _phoneNumberController,
                   focusNode: _numberFocusNode,
                   //  controller: controller,
                   //  validator: validator,

                   decoration: InputDecoration(
                     suffixIcon: Icon(FontAwesomeIcons.solidFileImage),
                     contentPadding: const EdgeInsets.symmetric(
                       vertical: 16,
                       horizontal: 16,
                     ),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                       borderSide: const BorderSide(color: Colors.grey),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                       borderSide: const BorderSide(color: Colors.grey),
                     ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                       borderSide: BorderSide(color: Colors.green),
                     ),
                     filled: true,

                     fillColor: Color(0x0b008000),
                     hintText: 'Phone Number',
                     hintStyle: TextStyle(color: Colors.grey[500]),
                   ),
                   disableLengthCheck: true,
                   initialCountryCode: 'US',
                   dropdownIcon: const Icon(
                     Icons.arrow_drop_down,
                     color: Colors.grey,
                   ),
                   style: const TextStyle(fontSize: 16, ),
                   cursorColor: Colors.green,

                   dropdownTextStyle: const TextStyle(
                     fontSize: 16,
                     //color: Colors.black87,
                   ),
                   onChanged: (phone) {

                   },
                 ),


             //TextField
             // --------------------------
             VerticalGap(gap: 20),
             //*message TextField
             TextField(
               controller: _messageController,

               focusNode: _messageFocusNode,
               keyboardType: TextInputType.multiline,
               textInputAction: TextInputAction.newline,
               maxLines: 2,
               style: TextStyle(fontSize: 18),
               decoration: InputDecoration(
                 hint: Text("Enter your message (optional)",style: TextStyle(color: Colors.grey[500],fontSize: 17),),
                 hintStyle: TextStyle(color: Colors.grey[500]),
                 contentPadding: const EdgeInsets.symmetric(
                   vertical: 16,
                   horizontal: 16,
                 ),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                   borderSide: const BorderSide(color: Colors.grey),
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                   borderSide: const BorderSide(color: Colors.grey),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                   borderSide: BorderSide(color: Colors.green),
                 ),
                 filled: true,

                 fillColor: Color(0x0b008000),
               ),
             ),
             //*message TextField

             VerticalGap(gap: 20),
             //Chat Button
             CustomButton(onPressed: ()async{
               await chatHistoryBox.add(ChatHistory(message: _messageController.text,user: _phoneNumberController.text,timestamp: DateTime.now()));

             },),
             //Chat Button
             VerticalGap(gap: 20),
             RecentNumbersSectionHeader(),
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
}
