class Account {
  String? id;
  String? email;
  String nickname = '';
  String avatar = '';

  void clear() {
    id = null;
    email = null;
    nickname = '';
    avatar = '';
  }
}

class Act {
  DateTime dateTime;
  String name;
  int score;
  String idAccount;
  String id;

  Act({required this.dateTime, required this.name, required this.score, this.idAccount = '', this.id = ''});
}

class SocialCredit {
  List<Act> acts;

  SocialCredit(this.acts);

  int getCredit() {
    int sum = 500;
    for (Act act in acts) {
      sum += act.score;
    }
    return sum;
  }
}

class Student {
  String idAccount;
  String name;
  List<Act> acts = [];

  int getCredit() {
    int sum = 500;
    for (Act act in acts) {
      sum += act.score;
    }
    return sum;
  }

  Student({required this.idAccount, required this.name});
}

class Students {
  List<Student> students = [];

  Students({required this.students, required List<Act> acts}) {
    for (Act act in acts) {
      for (Student student in students) {
        if (student.idAccount == act.idAccount) {
          student.acts.add(act);
          break;
        }
      }
    }
  }
}
