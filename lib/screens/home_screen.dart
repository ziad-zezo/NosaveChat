import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:quick_chat/generated/l10n.dart';
import 'package:quick_chat/helper_files/custom_snack_bar.dart';
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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('NoSave Chat'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _showAppOptionsBottomSheet(context);
          },
          icon: const Icon(Icons.star_outlined),
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
        items: [
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

  void _showAppOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black87,
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Bottom Sheet Container
            Padding(
              padding: const EdgeInsets.only(top: 36), // space for the icon
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  border: const Border(
                    top: BorderSide(color: Colors.green, width: 3),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 35, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).bottom_sheet_title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      S.of(context).bottom_sheet_description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 5),

                    /// Share Button
                    ListTile(
                      leading: const Icon(Icons.share, color: Colors.blue),
                      title: Text(S.of(context).share_app),
                      subtitle: Text(S.of(context).share_app_subtitle),

                      onTap: () async {
                        const appLink =
                            'https://play.google.com/store/apps/details?id=com.zoz.nosavechat';
                        try {
                          await Clipboard.setData(
                            const ClipboardData(text: appLink),
                          );
                          if (!context.mounted) return;
                          CustomSnackBar.showSuccessSnackBar(
                            context,
                            message: S.of(context).app_link_copied,
                            icon: Icons.copy,
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          CustomSnackBar.showErrorSnackBar(
                            context,
                            message: S.of(context).failed_to_copy_app_link,
                          );
                        }
                        Navigator.pop(context);
                      },
                    ),

                    /// Rate Button
                    ListTile(
                      leading: const Icon(
                        Icons.star_rate,
                        color: Colors.orange,
                      ),
                      title: Text(S.of(context).rate_app),
                      subtitle: Text(S.of(context).rate_app_subtitle),
                      onTap: () async {
                        Navigator.pop(context);
                        final review = InAppReview.instance;

                        try {
                          if (await review.isAvailable()) {
                            await review.requestReview();
                          } else {
                            await review.openStoreListing();
                          }
                        } catch (e) {
                          await review.openStoreListing();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Floating App Icon
            Positioned(
              top: 10,
              left:
                  MediaQuery.of(context).size.width / 2 -
                  30, // center horizontally
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset('assets/app_icons/app_icon.png'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
