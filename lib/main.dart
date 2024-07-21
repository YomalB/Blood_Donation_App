import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home/organizerForm.dart';
import 'package:flutter_application_1/provider/camp_provider.dart';
import 'package:flutter_application_1/screens/donorScreen.dart';
import 'package:flutter_application_1/screens/requestScreen.dart';
import 'package:flutter_application_1/screens/signUp_screen.dart';
import 'package:flutter_application_1/provider/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CampProvider()),
      ],
      child: MaterialApp(
        title: 'Blood Donation Champ',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SignUpScreenPage(),
      ),
    );
  }
}
