import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home/BloodShapePainter.dart';
import 'package:flutter_application_1/provider/auth_provider.dart';
import 'package:flutter_application_1/screens/requestScreen.dart';
import 'package:flutter_application_1/wiget/customdrawer.dart';
import 'package:flutter_application_1/wiget/doner_organizerButton.dart';
import 'package:provider/provider.dart';

class DonorScreenPage extends StatefulWidget {
  const DonorScreenPage({Key? key}) : super(key: key);

  @override
  State<DonorScreenPage> createState() => _DonorScreenPageState();
}

class _DonorScreenPageState extends State<DonorScreenPage> {
  final String profileImageUrl = "";

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userModel = authProvider.userModel;
    return Scaffold(
      drawer: CustomDrawer(profileImageUrl: userModel.profileImage ?? ''),
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
              HeaderSection(
                firstName: userModel?.firstName ?? '',
              ),
              SizedBox(height: 10),
              InfoRow(bloodGroup: userModel?.bloodType ?? 'Unknown'),
              SizedBox(height: 20),
              ParticipationCard(),
              DonerOrganizerbutton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestScreenPage()),
                  );
                },
                child: const Text(
                  'Find Blood Camp',
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

  const HeaderSection({required this.firstName});

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
            style: TextStyle(
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
                  icon: Icon(
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

class InfoRow extends StatelessWidget {
  final String bloodGroup;

  const InfoRow({required this.bloodGroup});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InfoCard(
          title: 'Your Blood Group',
          painter: BloodShapePainter(
            bgColor: Colors.red,
            text: bloodGroup,
          ),
        ),
        InfoCard(
          title: 'Donor status',
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 108, 217, 112),
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                size: 50,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final Widget? child;
  final CustomPainter? painter;

  const InfoCard({required this.title, this.child, this.painter});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
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
            Padding(
              padding: EdgeInsets.only(bottom: 140),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'MontserratBold',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              child: child ??
                  CustomPaint(
                    size: Size(100, 100),
                    painter: painter,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticipationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 120,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Center(
                child: Text(
                  'Total Participate\nBlood Camp',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                '20',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                  fontFamily: 'MontserratBold',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}