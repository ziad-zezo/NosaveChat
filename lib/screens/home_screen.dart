import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:quick_chat/screens/home_page.dart';
import 'package:quick_chat/screens/settings_page.dart';

import 'history_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.toggleTheme});
final VoidCallback toggleTheme;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    HistoryPage(),
    SettingsPage(),
    Center(child: Text("Info")),
  ];
final PageController _pageViewController=PageController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        //forceMaterialTransparency: true,
scrolledUnderElevation: 0,
        title: Text("Quick Chat"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon( Icons.light_mode),
          ),
        ],
      ),
      body:_pages[_selectedIndex],

//       PageView.builder(
//         controller: _pageViewController,
//         onPageChanged: (pageIndex){
//           _selectedIndex = pageIndex;
// setState(() {
//
// });
//         },
//           itemCount: 3,
//           itemBuilder: (context, index){return _pages[index];}) ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (page) {
          _selectedIndex = page;
          setState(() {});
        },
enableFeedback: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(

            icon: Icon(FontAwesomeIcons.house),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clockRotateLeft),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.gear),
            label: "Settings",
          ),

        ],
      ),

    );
  }
}
