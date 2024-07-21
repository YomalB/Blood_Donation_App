import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home/organizerForm.dart';
import 'package:flutter_application_1/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final String profileImageUrl;

  const CustomDrawer({required this.profileImageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userModel = authProvider.userModel;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : AssetImage('assets/images/signuUP_profile.png')
                          as ImageProvider,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          DrawerListItem(
            icon: Icons.send,
            text: 'Request',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          DrawerListItem(
            icon: Icons.location_on_rounded,
            text: 'Location',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          DrawerListItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          DrawerListItem(
            icon: Icons.event,
            text: 'Organize Blood Camp',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrganizerFormPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const DrawerListItem({
    required this.icon,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
