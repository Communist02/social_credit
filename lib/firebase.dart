import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'classes.dart';
import 'global.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> signEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (_) {}
    if (_auth.currentUser == null) return false;
    account.id = _auth.currentUser?.uid;
    account.email = _auth.currentUser?.email;
    final CollectionReference accounts = _firestore.collection('accounts');
    final acc = await accounts.doc(account.id).get();
    account.nickname = acc['nickname'];
    return true;
  }

  Future<bool> registerEmailPassword(String email, String password, String nickname) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (_) {}
    if (_auth.currentUser == null) return false;
    account.id = _auth.currentUser?.uid;
    account.email = _auth.currentUser?.email;
    final CollectionReference accounts = _firestore.collection('accounts');
    accounts.doc(account.id).set({'nickname': nickname});
    account.nickname = nickname;
    return true;
  }

  Future<bool> resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
    return true;
  }

  void sign() async {
    if (_auth.currentUser != null) {
      account.id = _auth.currentUser!.uid;
      account.email = _auth.currentUser!.email;
      final CollectionReference accounts = _firestore.collection('accounts');
      final acc = await accounts.doc(account.id).get();
      account.nickname = acc['nickname'];
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

  bool checkSign() {
    return _auth.currentUser != null;
  }

  String? getId() {
    return _auth.currentUser?.uid;
  }
}

class CloudStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<SocialCredit> getSocialCredit({all = false}) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) {
      final CollectionReference socialCreditBase = _firestore.collection('socialCredit');
      final result = await socialCreditBase.where('idAccount', isEqualTo: account.id).get();
      List<Act> acts = [];
      for (var act in result.docs) {
        if (act['idAccount'] == account.id) {
          acts.add(
            Act(
              dateTime: DateTime.fromMillisecondsSinceEpoch(act['dateTime'].seconds * 1000),
              name: act['name'],
              score: act['score'],
            ),
          );
        }
      }
      acts.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return SocialCredit(acts);
    } else {
      final Firestore firestore = Firestore('unified-database');
      final socialCreditBase = firestore.collection('socialCredit');
      final result = await socialCreditBase.where('idAccount', isEqualTo: account.id).get();
      List<Act> acts = [];
      for (var act in result) {
        if (act['idAccount'] == account.id) {
          acts.add(
            Act(
              dateTime: act['dateTime'],
              name: act['name'],
              score: act['score'],
            ),
          );
        }
      }
      acts.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return SocialCredit(acts);
    }
  }

  Future<Students> getSocialCreditAll() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) {
      final CollectionReference socialCreditBase = _firestore.collection('socialCredit');
      final CollectionReference accountsBase = _firestore.collection('accounts');
      final resultSocialCredit = await socialCreditBase.get();
      final resultAccounts = await accountsBase.get();
      List<Act> acts = [];
      for (var act in resultSocialCredit.docs) {
        if (true) {
          acts.add(
            Act(
              dateTime: DateTime.fromMillisecondsSinceEpoch(act['dateTime'].seconds * 1000),
              name: act['name'],
              score: act['score'],
              idAccount: act['idAccount'],
              id: act.id,
            ),
          );
        }
      }
      acts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      List<Student> students = [];
      for (var student in resultAccounts.docs) {
        students.add(Student(idAccount: student.id, name: student['nickname']));
      }
      return Students(students: students, acts: acts);
    } else {
      final Firestore firestore = Firestore('unified-database');
      final socialCreditBase = firestore.collection('socialCredit');
      final accountsBase = firestore.collection('accounts');
      final resultSocialCredit = await socialCreditBase.get();
      final resultAccounts = await accountsBase.get();
      List<Act> acts = [];
      for (var act in resultSocialCredit) {
        if (true) {
          acts.add(
            Act(
              dateTime: act['dateTime'],
              name: act['name'],
              score: act['score'],
              idAccount: act['idAccount'],
              id: act.id,
            ),
          );
        }
      }
      acts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      List<Student> students = [];
      for (var student in resultAccounts) {
        students.add(Student(idAccount: student.id, name: student['nickname']));
      }
      return Students(students: students, acts: acts);
    }
  }

  Future<bool> addAct(Act act) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) {
      final CollectionReference actsBase = _firestore.collection('socialCredit');
      await actsBase.add({
        'dateTime': act.dateTime,
        'idAccount': act.idAccount,
        'name': act.name,
        'score': act.score,
      });
      return true;
    } else {
      final Firestore firestore = Firestore('unified-database');
      final socialCreditBase = firestore.collection('socialCredit');
      await socialCreditBase.add({
        'dateTime': act.dateTime,
        'idAccount': act.idAccount,
        'name': act.name,
        'score': act.score,
      });
      return true;
    }
  }

  Future<bool> removeAct(String id) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) {
      final CollectionReference socialCredit = _firestore.collection('socialCredit');
      socialCredit.doc(id).delete();
      return true;
    } else {
      final Firestore firestore = Firestore('unified-database');
      final socialCredit = firestore.collection('socialCredit');
      socialCredit.document(id).delete();
      return true;
    }
  }
}
