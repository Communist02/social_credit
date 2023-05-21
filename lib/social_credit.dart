import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'classes.dart';
import 'firebase.dart';

int lastCredit = 500;

class SocialCreditPage extends StatefulWidget {
  const SocialCreditPage({Key? key}) : super(key: key);

  @override
  State<SocialCreditPage> createState() => _SocialCreditPageState();
}

class _SocialCreditPageState extends State<SocialCreditPage> {
  final CloudStore _cloudStore = CloudStore();
  int credit = 500;

  Color setColor() {
    if (credit <= 200) {
      return Colors.red;
    } else if (credit <= 400) {
      return Colors.orange;
    } else if (credit < 600) {
      return Colors.black;
    } else if (credit < 800) {
      return Colors.green;
    } else {
      return Colors.deepPurple;
    }
  }

  Color setColorBackground() {
    if (credit <= 200) {
      return Colors.red.shade200;
    } else if (credit <= 400) {
      return Colors.orange.shade100;
    } else if (credit < 600) {
      return Colors.white;
    } else if (credit < 800) {
      return Colors.green.shade100;
    } else {
      return Colors.deepPurple.shade100;
    }
  }

  String setStatus() {
    if (credit <= 200) {
      return 'Ваше отчисление назначено на ${DateFormat('dd.MM.yyyy').format(DateTime.now().add(const Duration(days: 1)))}';
    } else if (credit <= 400) {
      return 'Вы расстраиваете ВУЗ';
    } else if (credit < 600) {
      return 'Обычный студент';
    } else if (credit < 800) {
      return 'Успевающий студент';
    } else {
      return 'Вы образцовый студент, ВУЗ гордится тобой!';
    }
  }

  List<Widget> history(List<Act> acts) {
    List<Widget> list = [];
    for (Act act in acts) {
      list.add(
        Card(
          child: ListTile(
            leading: Text(DateFormat('dd.MM.yy\nHH:mm').format(act.dateTime)),
            title: Text('${act.score >= 0 ? '+' : ''}${act.score} баллов',
                style: TextStyle(color: act.score < 0 ? Colors.red : Colors.green)),
            subtitle: Text(act.name),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    dialog() {
      if (credit != lastCredit) {
        if (credit <= 200 && lastCredit > 200) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.only(top: 22),
              children: [
                const Image(image: AssetImage('assets/images/social_credit_low.jpg')),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Спасибо'),
                ),
              ],
            ),
          );
        } else if ((credit >= 800 && lastCredit < 800)) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.only(top: 22),
              children: [
                const Image(image: AssetImage('assets/images/social_credit_high.jpg')),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Спасибо'),
                ),
              ],
            ),
          );
        }
        lastCredit = credit;
      }
    }

    return FutureBuilder(
      future: _cloudStore.getSocialCredit(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          SocialCredit socialCredit = snapshot.data as SocialCredit;
          credit = socialCredit.getCredit();
          Future.delayed(const Duration(seconds: 1), () => dialog());
          Future.delayed(const Duration(seconds: 10), () {
            if (!mounted) return;
            setState(() {});
          });
          return Scaffold(
            backgroundColor: setColorBackground(),
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                            child: Text(
                          'Ваш социальный рейтинг',
                          style: TextStyle(
                            fontSize: 30,
                            color: setColor(),
                          ),
                        )),
                      ),
                      Center(
                        child: AnimatedFlipCounter(
                          duration: const Duration(milliseconds: 500),
                          value: credit,
                          textStyle: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: setColor(),
                          ),
                        ),
                      ),
                      Center(child: Text(setStatus())),
                    ] +
                    history(socialCredit.acts),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Профиль',
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: const Icon(Icons.person_outlined),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Ошибка'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
