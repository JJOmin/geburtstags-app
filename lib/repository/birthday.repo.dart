import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/util/date_time.util.dart';

class BirthdayRepo {
  // Private Constructor
  BirthdayRepo._privateConstructor() {
    _birthdays.addAll([
      Birthday.withId(
          date: DateTime(1995, 3, 22),
          name: "Anna",
          sirname: "Schmidt",
          emailAddress: "1@mail.com",
          phoneNumber: "0151-1234567"),
      Birthday.withId(
          date: DateTime(2000, 6, 21),
          name: "Lisa",
          sirname: "Koch",
          emailAddress: "1@mail.com",
          phoneNumber: "0151-1234567",
          skills: "Zeichnen"),
      Birthday.withId(
          date: DateTime(1992, 7, 5),
          name: "Lukas",
          sirname: "Müller",
          notes: "Mag Kaffee",
          emailAddress: "1@mail.com",
          phoneNumber: "0151-1234567"),
    ]);
  }

  static final BirthdayRepo _instance = BirthdayRepo._privateConstructor();
  static BirthdayRepo get instance => _instance;

  //final dateTimeUtil = DateTimeUtil();

  final List<Birthday> _birthdays = [];
  List<Birthday> getBirthdays() => _birthdays;

  Birthday insert(Birthday birthday) {
    _birthdays.add(birthday);
    return birthday;
  }

  void update({required Birthday oldBirthday, required Birthday newBirhtday}) {
    _birthdays.remove(oldBirthday);
    _birthdays.add(newBirhtday);
  }

  void delete(Birthday birthday) {
    _birthdays.remove(birthday);
  }

  List<Birthday> getNextFiveBirthdays() {
    final dateTimeUtil = DateTimeUtil();
    List<Birthday> nextFiveBirthdays =
        List.from(_birthdays); //neuerstellen der liste

    nextFiveBirthdays.sort((a, b) => dateTimeUtil
        .getDaysLeft(a.date)
        .compareTo(dateTimeUtil.getDaysLeft(b.date)));

    //sicherheitsabfrage damit wirklich nur 5 elemente rturnt werden
    if (nextFiveBirthdays.length > 5) {
      return nextFiveBirthdays.sublist(0, 5);
    }
    return nextFiveBirthdays;
  }
}
