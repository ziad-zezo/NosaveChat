import 'package:flutter/cupertino.dart';
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
  final pageController = PageController();
  final _homePageFocusNode=FocusNode();
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      Focus(
          focusNode: _homePageFocusNode,
          child: HomePage(key: UniqueKey(), navigateToHistoryPage: navigateToHistoryPage)),
      HistoryPage(key: UniqueKey()),
      SettingsPage(key: UniqueKey(), toggleTheme: widget.toggleTheme),
      Center(key: UniqueKey(), child: Text("Info")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text("Quick Chat"),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(onPressed: (){},icon: Icon(CupertinoIcons.info_circle_fill)),
          actions: [
            IconButton(
              onPressed: widget.toggleTheme,
              icon: brightness == Brightness.dark
                  ? Icon(CupertinoIcons.moon_fill)
                  : Icon(CupertinoIcons.sun_min_fill),
            ),
          ],
        ),
        body: PageView.builder(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) => _pages[index],
        ),
        // _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (page) {
            _selectedIndex = page;
            animateToPage(page: page);
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
      ),
    );
  }

  void navigateToHistoryPage(int pageIndex) {
    _selectedIndex = pageIndex;
    animateToPage(page: 1);
    setState(() {});
  }

  void animateToPage({required int page}) {
    _homePageFocusNode.unfocus();//to unfocus text fields
    pageController.animateToPage(
      page,
      curve: Curves.linear,
      duration: Duration(milliseconds: 250),
    );
  }
}
