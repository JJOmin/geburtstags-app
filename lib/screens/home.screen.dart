import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:geburtstags_app/models/birthday.model.dart';

import 'package:geburtstags_app/utils/date_time.util.dart';
import 'package:avatar_plus/avatar_plus.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            // Damit der ListView innerhalb der Column funktioniert,
            // packen wir ihn in ein Expanded-Widget:
            Expanded(
              child: ListView.builder(
                itemCount: nextFiveBirthdays.length,
                itemBuilder: (context, index) {
                  final birthday = nextFiveBirthdays[index];
                  final daysUntilBirthday =
                      dateTimeUtil.getDaysLeft(birthday.date);
                  final nextAge = dateTimeUtil.getNextAge(birthday.date);

                  final formattedDate = DateFormat('EE, d. MMMM', 'de_DE')
                      .format(dateTimeUtil.getNextBirthdayDate(birthday.date));

                  return Card(
                    elevation: 4,
                    color: Color.fromARGB(255, 2555, 255, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        onTap: () {
                          // Hier könntest du z. B. in einen Detail-Screen navigieren
                        },
                        leading: (birthday.profileImage == null)
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
                              ), //const CircleAvatar(radius: 30, child: Icon(Icons.person)),
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
                                  color: Color.fromARGB(255, 105, 147, 36)),
                            ),
                          ],
                        ),
                        trailing: Text("wird $nextAge Jahre",
                            style: const TextStyle(
                              fontSize: 17,
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
