import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/screens/about_screen.dart';
import 'package:quick_chat/screens/history_page.dart';
import 'package:quick_chat/screens/home_page.dart';
import 'package:quick_chat/screens/settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.toggleTheme});
  final VoidCallback toggleTheme;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final pageController = PageController();
  final _homePageFocusNode = FocusNode();
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      Focus(
        focusNode: _homePageFocusNode,
        child: HomePage(
          key: UniqueKey(),
          navigateToHistoryPage: navigateToHistoryPage,
        ),
      ),
      HistoryPage(key: UniqueKey()),
      SettingsPage(key: UniqueKey(), toggleTheme: widget.toggleTheme),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('NoSave Chat'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AboutScreen()),
          ),
          icon: const Icon(CupertinoIcons.info_circle_fill),
        ),
        actions: [
          IconButton(
            onPressed: widget.toggleTheme,
            icon: brightness == Brightness.dark
                ? const Icon(CupertinoIcons.moon_fill)
                : const Icon(CupertinoIcons.sun_min_fill),
          ),
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
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
        items:  [
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.house),
            label: 'Home',
            tooltip: S.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.clockRotateLeft),
            label: 'History',
            tooltip: S.of(context).history,
          ),
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.gear),
            label: 'Settings',
            tooltip: S.of(context).settings,
          ),
        ],
      ),
    );
  }

  void navigateToHistoryPage(int pageIndex) {
    _selectedIndex = pageIndex;
    animateToPage(page: 1);
    setState(() {});
  }

  void animateToPage({required int page}) {
    _homePageFocusNode.unfocus(); //to unfocus text fields
    pageController.animateToPage(
      page,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 250),
    );
  }
}
