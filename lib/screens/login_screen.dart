import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:lascade_demo_app/providers/product_providers.dart";
import '../navigator/main_tab_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  double wp(BuildContext context, double width) =>
      MediaQuery.of(context).size.width * (width / 430);
  double hp(BuildContext context, double height) =>
      MediaQuery.of(context).size.height * (height / 932);

  @override
  void initState() {
    super.initState();
    // Prefetch product data as soon as login screen loads
    _prefetchProductData();
  }

  Future<void> _prefetchProductData() async {
    // Use Future.wait to fetch multiple resources in parallel
    await Future.wait([
      ref.read(featuredProductsProvider.future),
      ref.read(categoryProductProvider('electronics').future),
      ref.read(allProductsProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromRGBO(112, 185, 190, 1),
          ),

          // Curves
          Positioned(
            top: hp(context, 41),
            left: wp(context, -2.32),
            child: SvgPicture.asset(
              'assets/images/curve1.svg',
              width: wp(context, 30),
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

          Positioned(
            top: hp(context, 300),
            left: wp(context, 110),
            child: SvgPicture.asset(
              'assets/images/dot.svg',
              width: wp(context, 8),
            ),
          ),

          Positioned(
            top: hp(context, 275),
            left: wp(context, 200),
            child: SvgPicture.asset(
              'assets/images/dot.svg',
              width: wp(context, 4),
            ),
          ),

          Positioned(
            top: hp(context, 230),
            left: wp(context, 225),
            child: SvgPicture.asset(
              'assets/images/dot.svg',
              width: wp(context, 7),
            ),
          ),

          Positioned(
            top: hp(context, 175),
            left: wp(context, 305),
            child: SvgPicture.asset(
              'assets/images/dot.svg',
              width: wp(context, 8),
            ),
          ),

          Positioned(
            top: hp(context, 315),
            left: wp(context, 295),
            child: SvgPicture.asset(
              'assets/images/dot.svg',
              width: wp(context, 5),
            ),
          ),

          Positioned(
            top: hp(context, 435),
            left: wp(context, 300),
            child: SvgPicture.asset(
              'assets/images/dot.svg',
              width: wp(context, 9),
            ),
          ),

          Positioned(
            top: hp(context, 400),
            left: wp(context, 390),
            child: SvgPicture.asset(
              'assets/images/dot.svg',
              width: wp(context, 8),
            ),
          ),

          Positioned(
            top: hp(context, 490),
            left: wp(context, 240),
            child: SvgPicture.asset(
              'assets/images/dot.svg',
              width: wp(context, 3),
            ),
          ),

          Positioned(
            top: hp(context, 417),
            left: wp(context, 116),
            child: SvgPicture.asset(
              'assets/images/dot.svg',
              width: wp(context, 8),
            ),
          ),

          Positioned(
            top: hp(context, 267),
            left: wp(context, 76),
            child: SvgPicture.asset(
              'assets/images/leaf1.svg',
              width: wp(context, 12),
            ),
          ),

          Positioned(
            top: hp(context, 414),
            left: wp(context, 355),
            child: SvgPicture.asset(
              'assets/images/leaf1.svg',
              width: wp(context, 22),
            ),
          ),

          Positioned(
            top: hp(context, 220),
            left: wp(context, 385),
            child: SvgPicture.asset(
              'assets/images/leaf2.svg',
              width: wp(context, 12),
            ),
          ),

          Positioned(
            top: hp(context, 545),
            left: wp(context, 50),
            child: SvgPicture.asset(
              'assets/images/leaf3.svg',
              width: wp(context, 12),
            ),
          ),

          Positioned(
            top: hp(context, 530),
            left: wp(context, 345),
            child: SvgPicture.asset(
              'assets/images/particle1.svg',
              width: wp(context, 8),
            ),
          ),

          Positioned(
            top: hp(context, 485),
            left: wp(context, 50),
            child: SvgPicture.asset(
              'assets/images/particle2.svg',
              width: wp(context, 10),
            ),
          ),

          Positioned(
            top: hp(context, 395),
            left: wp(context, 210),
            child: SvgPicture.asset(
              'assets/images/particle3.svg',
              width: wp(context, 8),
            ),
          ),

          Positioned(
            top: hp(context, 185),
            left: wp(context, 210),
            child: SvgPicture.asset(
              'assets/images/particle4.svg',
              width: wp(context, 5),
            ),
          ),

          // Decorative Images
          Positioned(
            top: hp(context, 195),
            left: wp(context, 90),
            child: SvgPicture.asset(
              'assets/images/egg.svg',
              width: wp(context, 85),
            ),
          ),
          Positioned(
            top: hp(context, 197),
            right: wp(context, 60),
            child: SvgPicture.asset(
              'assets/images/salmon.svg',
              width: wp(context, 92),
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
              width: wp(context, 60),
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
                      onPressed: () {
                        // Navigate to MainTabScreen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MainTabScreen(),
                          ),
                        );
                      },
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
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainTabScreen(),
                        ),
                      );
                    },
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
            right: wp(context, 15),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainTabScreen(),
                  ),
                );
              },
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
