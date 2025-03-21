import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:geburtstags_app/models/birthday.model.dart';

import 'package:geburtstags_app/utils/date_time.util.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'dart:math' as math;

import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_detail.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static final routeName = (HomeScreen).toString();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Birthday> nextFiveBirthdays = [];
  final dateTimeUtil = DateTimeUtil();

  @override
  void initState() {
    super.initState();
    loadBirthdays();
  }

  void loadBirthdays() {
    setState(() {
      nextFiveBirthdays = BirthdayRepo.instance.getNextFiveBirthdays();
    });
  }

  void showSnackbar(BuildContext context, Birthday birthday) {
    setState(() {
      // Move FAB up when Snackbar appears
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text('${birthday.name} gelöscht.'),
            duration: const Duration(seconds: 3),
            animation: CurvedAnimation(
              parent: AnimationController(
                duration:
                    const Duration(milliseconds: 250), // Custom animation speed
                vsync: Scaffold.of(context),
              ),
              curve: Curves.easeInOut, // Custom animation curve
            ),
            action: SnackBarAction(
              label: 'Rückgängig',
              textColor: const Color.fromARGB(255, 126, 126, 240),
              onPressed: () {
                setState(() {
                  BirthdayRepo.instance.insert(birthday);
                  loadBirthdays(); // Liste neu laden
                });
              },
            ),
          ),
        )
        .closed
        .then((_) {
      setState(() {
        // Reset FAB position after Snackbar closes
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Expanded(
              child: CustomMaterialIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  loadBirthdays();
                },
                backgroundColor: Colors.white,
                indicatorBuilder: (context, controller) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CircularProgressIndicator(
                      color: Colors.redAccent,
                      value: controller.state.isLoading
                          ? null
                          : math.min(controller.value, 1.0),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: ListView.builder(
                    itemCount: nextFiveBirthdays.length,
                    itemBuilder: (context, index) {
                      final birthday = nextFiveBirthdays[index];
                      final daysUntilBirthday =
                          dateTimeUtil.getDaysLeft(birthday.date);
                      final nextAge = dateTimeUtil.getNextAge(birthday.date);

                      final formattedDate = DateFormat('EE, d. MMMM', 'de_DE')
                          .format(
                              dateTimeUtil.getNextBirthdayDate(birthday.date));

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          elevation: 4,
                          color: Color.fromARGB(255, 2555, 255, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  BirthdayDetailScreen.routeName,
                                  arguments: birthday,
                                ).then((result) {
                                  loadBirthdays(); // Aktualisiert die Liste nach Rückkehr
                                  if (result == true && mounted) {
                                    showSnackbar(context, birthday);
                                  } else {
                                    return;
                                  }
                                });
                              },
                              leading: (birthday.profileImage == null)
                                  ? AvatarPlus(
                                      birthday.id,
                                      height:
                                          MediaQuery.of(context).size.width -
                                              360,
                                      width: MediaQuery.of(context).size.width -
                                          360,
                                    )
                                  : Image.network(
                                      birthday.profileImage!,
                                      height:
                                          MediaQuery.of(context).size.width -
                                              370,
                                      width: MediaQuery.of(context).size.width -
                                          370,
                                      fit: BoxFit.cover,
                                    ),
                              title: Text(birthday.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Color.fromARGB(115, 0, 0, 0)),
                                  ),
                                  Text(
                                    "In $daysUntilBirthday Tagen",
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 105, 147, 36),
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                              trailing: Text("wird $nextAge Jahre",
                                  style: const TextStyle(
                                    fontSize: 17,
                                  )),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
