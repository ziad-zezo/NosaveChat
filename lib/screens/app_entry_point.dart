import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quick_chat/screens/share_image_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'home_screen.dart';

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key, required this.toggleTheme});
  final VoidCallback toggleTheme;

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  StreamSubscription<List<SharedMediaFile>>? _mediaStreamSub;
  bool _navigated = false;
  @override
  void initState() {
    super.initState();

    // Live sharing while app is open
    _mediaStreamSub =
        ReceiveSharingIntent.instance.getMediaStream().listen((files) {
          if (!_navigated && files.isNotEmpty) {
            // _navigateToSharedScreen(files);
            _showShareDialog(files,"first");

          }
        });

    // Initial sharing if app launched via share
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (!_navigated && files.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // _navigateToSharedScreen(files);
          _showShareDialog(files,"second");


        });
      }
    });
  }

  void _showShareDialog(List<SharedMediaFile> files, String where) {

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Shared from: $where"),
          content: Image.file(File(files[0].path)),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _navigateToSharedScreen(List<SharedMediaFile> files) {
    _navigated = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ShareImageScreen(text: files[0].path),
      ),
    );
  }

  @override
  void dispose() {
    _mediaStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(toggleTheme:widget.toggleTheme);
  }
}
