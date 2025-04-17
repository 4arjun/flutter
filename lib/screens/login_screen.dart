import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  double wp(BuildContext context, double width) =>
      MediaQuery.of(context).size.width * (width / 430);
  double hp(BuildContext context, double height) =>
      MediaQuery.of(context).size.height * (height / 932);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF9ED2C6),
          ),

          // Curves
          Positioned(
            top: hp(context, 121),
            left: wp(context, -12.32),
            child: SvgPicture.asset(
              'assets/images/curve1.svg',
              width: wp(context, 42),
            ),
          ),
          Positioned(
            top: 0,
            right: wp(context, -20),
            width: wp(context, 290),
            height: hp(context, 246),
            child: SvgPicture.asset('assets/images/curve2.svg'),
          ),
          Positioned(
            top: hp(context, 360),
            right: 0,
            child: SvgPicture.asset(
              'assets/images/curve3.svg',
              width: wp(context, 430),
            ),
          ),

          // Decorative Images
          Positioned(
            top: hp(context, 240),
            left: wp(context, 100),
            child: SvgPicture.asset(
              'assets/images/egg.svg',
              width: wp(context, 79),
            ),
          ),
          Positioned(
            top: hp(context, 197),
            right: wp(context, 60),
            child: SvgPicture.asset(
              'assets/images/salmon.svg',
              width: wp(context, 88),
            ),
          ),
          Positioned(
            top: hp(context, 435),
            right: wp(context, 35),
            child: SvgPicture.asset(
              'assets/images/chicken.svg',
              width: wp(context, 135),
            ),
          ),
          Positioned(
            top: hp(context, 464),
            left: wp(context, 88),
            child: SvgPicture.asset(
              'assets/images/cheese.svg',
              width: wp(context, 95),
            ),
          ),
          Positioned(
            top: hp(context, 380),
            left: wp(context, 125),
            child: SvgPicture.asset(
              'assets/images/lettuce1.svg',
              width: wp(context, 53),
            ),
          ),
          Positioned(
            top: hp(context, 350),
            left: wp(context, 136),
            child: SvgPicture.asset(
              'assets/images/lettuce1.svg',
              width: wp(context, 53),
            ),
          ),
          Positioned(
            top: hp(context, 360),
            left: wp(context, 250),
            child: SvgPicture.asset(
              'assets/images/lemon.svg',
              width: wp(context, 55),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: wp(context, 30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Help your path to health\ngoals with happiness",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: wp(context, 28),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: hp(context, 28)),
                  SizedBox(
                    width: double.infinity,
                    height: hp(context, 50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(4, 38, 40, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(wp(context, 12)),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: wp(context, 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: hp(context, 12)),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Create New Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: wp(context, 16),
                      ),
                    ),
                  ),
                  SizedBox(height: hp(context, 40)),
                ],
              ),
            ),
          ),

          // Later Button
          Positioned(
            top: hp(context, 50),
            right: wp(context, 20),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Later",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: wp(context, 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
