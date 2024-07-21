import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home/BloodShapePainter.dart';
import 'package:flutter_application_1/Home/organizerForm.dart';
import 'package:flutter_application_1/provider/auth_provider.dart';
import 'package:flutter_application_1/provider/camp_provider.dart';
import 'package:flutter_application_1/wiget/customdrawer.dart';
import 'package:flutter_application_1/wiget/doner_organizerButton.dart';
import 'package:provider/provider.dart';

class OrganizerHomeScreenPage extends StatefulWidget {
  const OrganizerHomeScreenPage({super.key});

  @override
  State<OrganizerHomeScreenPage> createState() =>
      _OrganizerHomeScreenPageState();
}

class _OrganizerHomeScreenPageState extends State<OrganizerHomeScreenPage> {
  int emailCount = 0;

  @override
  void initState() {
    super.initState();
    fetchEmailCount();
  }

  Future<void> fetchEmailCount() async {
    final campProvider = Provider.of<CampProvider>(context, listen: false);
    int count = await campProvider.fetchEmailCount();
    setState(() {
      emailCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userModel = authProvider.userModel;
    return Scaffold(
      drawer: CustomDrawer(profileImageUrl: userModel.profileImage),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: Column(
            children: [
              HeaderSection(firstName: userModel.firstName),
              const SizedBox(height: 50),
              TotalBloodCampCard(emailCount: emailCount),
              const SizedBox(height: 20),
               DonerOrganizerbutton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrganizerFormPage()),
                  );
                },
                 child: const Text(
            'Organize\nBlood Camp',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontFamily: 'MontserratBold',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final String firstName;

  const HeaderSection({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        color: Color(0xFFFF1A1A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Hello $firstName',
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontFamily: 'MontserratBold',
            ),
          ),
          Positioned(
            top: 8,
            left: 10,
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TotalBloodCampCard extends StatelessWidget {
  final int emailCount;

  const TotalBloodCampCard({required this.emailCount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 140),
              child: Center(
                child: Text(
                  'Total Blood Camp',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontFamily: 'MontserratBold',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              child: CustomPaint(
                size: Size(100, 100),
                painter: BloodShapePainter(
                  bgColor: Colors.red,
                  text: '$emailCount',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
class OrganizeBloodCampButton extends StatelessWidget {
  const OrganizeBloodCampButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OrganizerFormPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 210, 36, 24),
            minimumSize: Size(250, 70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            'Organize\nBlood Camp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'MontserratBold',
            ),
          ),
        ),
      ),
    );
  }
}
*/