import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static final routeName = (HomeScreen).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_outlined),
            TextButton(
              onPressed: () {
                Share.share('Check out my website: https://example.com');
              },
              child: Text("Ich bin ein Button"),
            ),
          ],
        ),
      ),
    );
  }
}
