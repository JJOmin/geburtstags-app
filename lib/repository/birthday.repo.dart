import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';

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

  //Neue Logic hinzugefügt: abzüglich der Geburtstage die heute sind!!!
  List<Birthday> getNextFiveBirthdays() {
    final dateTimeUtil = DateTimeUtil();
    final todaysBirthdays = getTodaysBirthdays();
    var listLength = 5;
    List<Birthday> nextFiveBirthdays = _birthdays
        .where((birthday) =>
            !todaysBirthdays.any((excluded) => excluded.id == birthday.id))
        .toList();

    nextFiveBirthdays.sort((a, b) => dateTimeUtil
        .getDaysLeft(a.date)
        .compareTo(dateTimeUtil.getDaysLeft(b.date)));
    if (todaysBirthdays.isNotEmpty && todaysBirthdays.length < listLength) {
      listLength - todaysBirthdays.length;
    }

    if (nextFiveBirthdays.length > listLength) {
      return nextFiveBirthdays.sublist(0, listLength);
    }
    return nextFiveBirthdays;
  }

  List<Birthday> getTodaysBirthdays() {
    List<Birthday> list = [];

    for (var i = 0; i < _birthdays.length; i++) {
      if (_birthdays[i].date.day == DateTime.now().day &&
          _birthdays[i].date.month == DateTime.now().month) {
        list.add(_birthdays[i]);
      }
    }
    return list;
  }
}
