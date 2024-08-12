import 'package:client/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignoutWidget extends StatelessWidget {
  const SignoutWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 42,
      left: 24,
      child: GestureDetector(
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
            );
          });
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.white,
            shadows: [
              BoxShadow(
                color: Color.fromARGB(64, 0, 0, 0),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '<',
              style: GoogleFonts.poppins(color: const Color(0xFF0A5C36), fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
