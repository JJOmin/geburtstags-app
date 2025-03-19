import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:geburtstags_app/repository/birthdayrepo.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_detail.screen.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_form.screen.dart';
import 'package:avatar_plus/avatar_plus.dart';

//import 'package:flutter_tilt/flutter_tilt.dart';
class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  static final routeName = (BirthdayScreen).toString();

  @override
  BirthdayScreenState createState() => BirthdayScreenState();
}

class BirthdayScreenState extends State<BirthdayScreen> {
  List<Birthday> birthdays = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: ListView.builder(
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
            },
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  BirthdayDetailScreen.routeName,
                  arguments: birthday,
                ).then((_) {
                  loadBirthdays(); //Aktualisiert die Liste nach Rückkehr
                });
              },
              title: Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 73, 219, 224), // Sonst Orange
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
                    color: Colors.black,
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
                              "wird ${DateFormat('EE, d. MMMM', 'de_DE').format(birthday.nextBirthdayDate)} ${birthday.age + 1} Jahre alt",
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
                          color: (birthday.nextBirthday ?? 999) < 5
                              ? const Color.fromARGB(
                                  255, 255, 165, 0) // Weniger als 10 Tage
                              : const Color.fromARGB(
                                  255, 129, 152, 221), // Sonst Orange
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 3, bottom: 4),
                          child: Text(
                            "${birthday.nextBirthday.toString()} \n Tage",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    height: 1), // Reduziert Zeilenabstand
                            textAlign: TextAlign.center,
                            //extAlign: TextAlign.right
                          ),
                        )),
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
      floatingActionButton: FloatingActionButton(
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
