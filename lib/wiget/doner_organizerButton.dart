import 'package:flutter/material.dart';

class DonerOrganizerbutton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const DonerOrganizerbutton({
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 210, 36, 24),
            minimumSize: Size(300, 60),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
          ),
          child: child, 
        ),
      ),
    );
  }
}
