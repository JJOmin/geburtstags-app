import 'package:flutter/material.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/screens/birthday_screen/birthday.screen.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_detail.screen.dart';
import 'package:geburtstags_app/screens/settings.screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:geburtstags_app/screens/home.screen.dart';
import 'package:geburtstags_app/screens/bottomnavbarstate.screen.dart';
//import 'package:geburtstags_app/screens/custom_app_bar.screens.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_form.screen.dart';
//import 'repository/birthdayrepo.dart';

void main() {
  runApp(const MyApp());
  initializeDateFormatting('de_DE', null);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geburtstags App',
      initialRoute: HomePage.routeName,
      onGenerateRoute: (settings) {
        if (settings.name == BirthdayDetailScreen.routeName) {
          final birthday = settings.arguments as Birthday;
          return MaterialPageRoute(
            builder: (context) => BirthdayDetailScreen(birthday: birthday),
          );
        }
        return null; // Falls keine Route passt
      },
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        BirthdayScreen.routeName: (context) => const BirthdayScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        BirthdayForm.routeName: (context) => const BirthdayForm(),
      },
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class HomePage extends StatefulWidget {
  static final routeName = (HomePage).toString();
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final Color backgroundColor = const Color.fromARGB(255, 255, 255, 255);
  final Color selectionColor = const Color.fromARGB(255, 93, 157, 242);

  //Pages for IndexedStack
  final List<Widget> pages = [
    const HomeScreen(),
    const BirthdayScreen(),
    const SettingsScreen(),
  ];

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CustomAppBar(
          headline: "Birthdays",
        ),
      ),

      //IndexedStack keeps pages alive when switching tabs
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      //Extracted BottomNavBar as a separate StatefulWidget
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected,
        backgroundColor: backgroundColor,
        selectionColor: selectionColor,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.headline,
  });

  final String headline;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 93, 158, 242),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(20, 0, 0, 0),
              blurRadius: 3.0,
              spreadRadius: 0.5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Change back button color
          ),
          backgroundColor: const Color.fromARGB(255, 93, 158, 242),
          title: Text(
            headline,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          centerTitle: true,
        ));
  }
}
