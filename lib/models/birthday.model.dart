import 'package:uuid/uuid.dart';

class Birthday {
  final String id;
  final String name;
  final String sirname;
  final DateTime date;
  final String? phoneNumber;
  final String? emailAddress;
  final String? profileImage;
  final String? notes;
  final String? skills;
  final int? nextBirthday;
  final String zodiacSign; // Wird automatisch berechnet
  final DateTime nextBirthdayDate;
  final int age;

  Birthday({
    required this.id,
    required this.name,
    required this.sirname,
    required this.date,
    this.phoneNumber,
    this.emailAddress,
    this.profileImage,
    this.notes,
    this.skills,
    this.nextBirthday,
    required this.zodiacSign,
    required this.nextBirthdayDate,
    required this.age,
  });

  // Factory-Methode mit automatischer ID und Sternzeichenberechnung
  factory Birthday.withId({
    required String name,
    required String sirname,
    required DateTime date,
    String? phoneNumber,
    String? emailAddress,
    String? profileImage,
    String? notes,
    String? skills,
  }) {
    return Birthday(
      id: const Uuid().v4(), // Generiert eine eindeutige UUID
      name: name,
      sirname: sirname,
      date: date,
      phoneNumber: phoneNumber,
      emailAddress: emailAddress,
      profileImage: profileImage,
      notes: notes,
      skills: skills,
      age: _calcCurrentAge(date),
      nextBirthdayDate: _nextBirthdayDate(date),
      zodiacSign:
          _getZodiacSign(date), // Automatische Berechnung des Sternzeichens
      nextBirthday: _getDaysLeft(
          date), //automatische Berechnung der Tabe bis zum Geburztag
    );
  }

//ACHTUNG MUSS Dynamisch gemacht werden wenn seite aufgerufen wird
  static int _getDaysLeft(DateTime date) {
    var birthDate = date;
    final currentDate = DateTime.now();

    DateTime nextBirthday =
        DateTime(currentDate.year, birthDate.month, birthDate.day);
    int daysLeft = 0;

    if (nextBirthday.difference(currentDate).inDays >= 1) {
      //wenn nächster Birthday noch dieses Jahr kommt, dann:
      daysLeft = nextBirthday.difference(currentDate).inDays;
    } else {
      //wenn Birthday nicht schon war, dann:
      DateTime nextBirthday =
          DateTime(currentDate.year + 1, birthDate.month, birthDate.day);
      daysLeft = nextBirthday.difference(currentDate).inDays;
    }
    return daysLeft;
  }

  static DateTime _nextBirthdayDate(DateTime date) {
    var birthDate = date;
    final currentDate = DateTime.now();

    DateTime nextBirthdayDate =
        DateTime(currentDate.year, birthDate.month, birthDate.day);
    //int daysLeft = 0;

    if (nextBirthdayDate.difference(currentDate).inDays < 1) {
      nextBirthdayDate =
          DateTime(currentDate.year + 1, birthDate.month, birthDate.day);
    }
    return nextBirthdayDate;
  }

  static int _calcCurrentAge(DateTime date) {
    final int birthYear = date.year;
    final int nextBirthdayYear = _nextBirthdayDate(date).year;
    var currentAge = (nextBirthdayYear - birthYear) - 1;

    return currentAge;
  }

  //Methode zur Berechnung des Sternzeichens basierend auf dem Datum
  static String _getZodiacSign(DateTime date) {
    int day = date.day;
    int month = date.month;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return "Widder ♈";
    }
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return "Stier ♉";
    }
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return "Zwillinge ♊";
    }
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return "Krebs ♋";
    }
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return "Löwe ♌";
    }
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return "Jungfrau ♍";
    }
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return "Waage ♎";
    }
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return "Skorpion ♏";
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return "Schütze ♐";
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return "Steinbock ♑";
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return "Wassermann ♒";
    }
    return "Fische ♓";
  }
}
