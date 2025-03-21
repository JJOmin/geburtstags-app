import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_detail.screen.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_form.screen.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  static final routeName = (BirthdayScreen).toString();

  @override
  BirthdayScreenState createState() => BirthdayScreenState();
}

class BirthdayScreenState extends State<BirthdayScreen> {
  List<Birthday> birthdays = [];
  double _fabBottomPadding = 0.0; // Default padding
  final dateTimeUtil = DateTimeUtil();

  @override
  void initState() {
    super.initState();
    loadBirthdays();
  }

  void loadBirthdays() {
    setState(() {
      birthdays = BirthdayRepo.instance.getBirthdays();
    });
  }

  void showSnackbar(BuildContext context, Birthday birthday) {
    setState(() {
      _fabBottomPadding = 48.0; // Move FAB up when Snackbar appears
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
        _fabBottomPadding = 0.0; // Reset FAB position after Snackbar closes
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView.builder(
          itemCount: birthdays.length,
          itemBuilder: (context, index) {
            final birthday = birthdays[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  BirthdayRepo.instance.delete(birthday);
                });
                if (!mounted) return;
                showSnackbar(context, birthday);
              },
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
                title: Container(
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Sonst Orange
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(78, 0, 0, 0),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
                    border: Border.all(
                      color: const Color.fromARGB(0, 0, 0, 0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(0, 0, 0, 0),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            width: 1,
                          ),
                        ),
                        child: (birthday.profileImage == null)
                            ? AvatarPlus(
                                birthday.id,
                                height: MediaQuery.of(context).size.width - 350,
                                width: MediaQuery.of(context).size.width - 350,
                              )
                            : Image.network(
                                birthday.profileImage!,
                                height: MediaQuery.of(context).size.width - 370,
                                width: MediaQuery.of(context).size.width - 370,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 15),
                      IntrinsicWidth(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                birthday.name,
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('EE, d. MMM yyyy', 'de_DE').format(
                                    dateTimeUtil
                                        .getNextBirthdayDate(birthday.date)),
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (dateTimeUtil.getDaysLeft(birthday.date)) < 5
                              ? const Color.fromARGB(
                                  255, 255, 165, 0) // Weniger als 10 Tage
                              : const Color.fromARGB(
                                  255, 129, 152, 221), // Sonst Orange
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 3, bottom: 4),
                          child: Text(
                            "${dateTimeUtil.getNextAge(birthday.date).toString()} \n Jahre",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    height: 1), // Reduziert Zeilenabstand
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (dateTimeUtil.getDaysLeft(birthday.date)) < 5
                              ? const Color.fromARGB(
                                  255, 255, 165, 0) // Weniger als 10 Tage
                              : const Color.fromARGB(
                                  255, 129, 152, 221), // Sonst Orange
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 3, bottom: 4),
                          child: Text(
                            "${dateTimeUtil.getDaysLeft(birthday.date).toString()} \n Tage",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    height: 1), // Reduziert Zeilenabstand
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          shareBirthdayAsCalendarEvent(birthday);
                        },
                        icon: Icon(Icons.adaptive.share),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.only(bottom: _fabBottomPadding),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => const BirthdayForm(),
              ),
            )
                .then((value) {
              // Refresh list when returning from BirthdayForm
              loadBirthdays();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

Future<void> shareBirthdayAsCalendarEvent(Birthday birthday) async {
  final String icsContent = '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//GeburtstagsApp//DE
BEGIN:VEVENT
SUMMARY:Geburtstag von ${birthday.name} ${birthday.sirname}
DTSTART:${DateFormat('yyyyMMdd').format(birthday.date)}
DTEND:${DateFormat('yyyyMMdd').format(birthday.date)}
DESCRIPTION:Vergiss nicht, ${birthday.name} ${birthday.sirname} zum Geburtstag zu gratulieren!
BEGIN:VALARM
TRIGGER:-P1D
ACTION:DISPLAY
DESCRIPTION:Erinnerung an den Geburtstag von ${birthday.name} ${birthday.sirname}
END:VALARM
END:VEVENT
END:VCALENDAR
''';

  final Directory tempDir = await getTemporaryDirectory();
  final File icsFile =
      File('${tempDir.path}/${birthday.name}_${birthday.sirname}_birthday.ics');

  await icsFile.writeAsString(icsContent);

  Share.shareXFiles([XFile(icsFile.path)],
      text: 'Speichere ${birthday.name}s Geburtstag in deinem Kalender!');
}
