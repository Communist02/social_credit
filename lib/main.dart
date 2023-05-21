import 'package:flutter/material.dart';
import 'control_panel.dart';
import 'firebase.dart';
import 'global.dart';
import 'profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'social_credit.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) {
    AuthService().sign();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String initialRoute() {
      if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) {
        if (account.id == null) {
          return '/profile';
        } else {
          return '/social-credit';
        }
      } else {
        return '/control-panel';
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Социальный рейтинг',
      routes: {
        '/profile': (context) => const ProfilePage(),
        '/social-credit': (context) => const SocialCreditPage(),
        '/control-panel': (context) => const ControlPanelPage(),
      },
      initialRoute: initialRoute(),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'BalsamiqSans',
      ),
    );
  }
}
