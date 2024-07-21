import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/login/login.dart';

class WelcomeScreenPage extends StatefulWidget {
  const WelcomeScreenPage({Key? key}) : super(key: key);

  @override
  State<WelcomeScreenPage> createState() => _WelcomeScreenPageState();
}

class _WelcomeScreenPageState extends State<WelcomeScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF1A1A), Color(0xFFFF1A1A)],
            ),
          ),
          child: Column(
            children: const [
              SizedBox(height: 70),
              WelcomeText(),
              SizedBox(height: 90),
              WelcomeImage(),
              SizedBox(height: 60),
              DescriptionText(),
              SizedBox(height: 20),
              StartButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Blood Camp",
      style: TextStyle(
        fontSize: 55,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 240,
      width: 240,
      color: Colors.white,
      child: Image.asset(
        'assets/images/bda1.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Welcome to Blood donation camp",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        color: Colors.white,
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          minimumSize: MaterialStateProperty.all<Size>(Size(180, 60)),
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
        ),
        child: const Text("Let's Start"),
      ),
    );
  }
}
