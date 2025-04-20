import 'package:flutter/material.dart';
import 'package:lascade_demo_app/screens/home_screen.dart';
import 'package:lascade_demo_app/screens/account_screen.dart';
import 'package:lascade_demo_app/screens/search_screen.dart';
import 'package:lascade_demo_app/screens/alert_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeScreen(),
    SearchScreen(),
    AlertScreen(),
    ProfileScreen(),
  ];

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // First try a standard BottomNavigationBar to verify navigation works
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changeTab,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: Icon(Icons.search),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Icon(Icons.notifications),
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 4, 38, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {},
        child: Icon(Icons.restaurant_menu, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Custom Curved Bottom Navigation Bar
class CurvedBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CurvedBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: BottomBarClipper(),
          child: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: BottomAppBar(
              color: Colors.white,
              elevation: 10,
              shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildNavItem("Home", 0)),
                  Expanded(child: _buildNavItem("Search", 1)),
                  SizedBox(width: 60), // Space for FAB
                  Expanded(child: _buildNavItem("bell", 2)),
                  Expanded(child: _buildNavItem("profile", 3)),
                ],
              ),
            ),
          ),
        ),

        // Curve border outline - draws just the border of the curve
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 60, // Adjust based on the curve height
            child: CustomPaint(
              painter: CurveBorderPainter(),
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(String icon, int index) {
    bool isSelected = index == currentIndex;

    // Map icon names to Flutter Icons
    IconData iconData;
    switch (icon) {
      case "Home":
        iconData = Icons.home;
        break;
      case "Search":
        iconData = Icons.search;
        break;
      case "bell":
        iconData = Icons.notifications;
        break;
      case "profile":
        iconData = Icons.person;
        break;
      default:
        iconData = Icons.circle;
    }

    return IconButton(
      icon: Icon(
        iconData,
        color: isSelected ? Colors.teal : Colors.grey,
        size: 28,
      ),
      onPressed: () {
        onTap(index);
      },
    );
  }
}

// Custom painter that draws only the shadow for the curve
class CurveBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double fabRadius = 38;

    // Create path for the shadow
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(width * 0.40, 0);
    path.quadraticBezierTo(width * 0.49, fabRadius * 2, width * 0.61, 0);
    path.lineTo(width, 0);

    // Create shadow paint
    Paint shadowPaint =
        Paint()
          ..color = const Color.fromARGB(255, 242, 239, 239)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.0);

    // Draw shadow
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double fabRadius = 38;

    Path path = Path();

    // Start from left
    path.moveTo(0, 0);

    // Line to the start of curve
    path.lineTo(width * 0.49, 0);

    // Curve down and up for FAB
    path.quadraticBezierTo(
      width * 0.5,
      fabRadius * 2, // depth of the curve
      width * 0.60,
      0,
    );

    // Continue straight to right
    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
