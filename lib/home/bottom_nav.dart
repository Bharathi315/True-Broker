import 'package:flutter/material.dart';
import 'package:truebroker/categories/categories.dart';
import 'package:truebroker/home/homescreen.dart';
import 'package:truebroker/message/message1.dart';
import 'package:truebroker/sell_rent/add_basic_sell.dart';

class FrontScreen extends StatefulWidget {
  const FrontScreen({super.key});

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  int _currentIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavItemTapped,
          ),
          onNavigate: _onNavItemTapped,
        );
      case 1:
        return CategoriesScreen(
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavItemTapped,
          ),
          onBack: () => _onNavItemTapped(0),
        );
      case 3:
        return Add_Basic(
          onBack: () => _onNavItemTapped(0),
        );
      case 4:
        return MessageScreen(
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavItemTapped,
          ),
          onBack: () => _onNavItemTapped(0),
        );
      default:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: Text('Screen $_currentIndex Content')),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavItemTapped,
          ),
        );
    }
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 110,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(screenWidth, 60),
            painter: BNBCustomPainter(),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                _buildNavItem('assets/bottomnavbar/homelogo.png', 'Home', 0),
                _buildNavItem('assets/bottomnavbar/applogo.png', 'Categories', 1),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'TBshorts',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildNavItem('assets/bottomnavbar/Vector.png', 'Sell/Rent', 3),
                _buildNavItem('assets/bottomnavbar/message.png', 'Message', 4),
              ],
            ),
          ),
          Positioned(
            top: 12,
            left: (screenWidth - 66) / 2,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 66,
                height: 66,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  'assets/bottomnavbar/vidlogo.png',
                  width: 54,
                  height: 54,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String imagePath, String label, int index) {
    bool isActive = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isActive)
              Positioned.fill(
                child: Image.asset(
                  'assets/bottomnavbar/trianglelogo.png',
                  fit: BoxFit.fill,
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                SizedBox(
                  width: 25,
                  height: 24,
                  child: Image.asset(
                    imagePath,
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF742B88)
      ..style = PaintingStyle.fill;

    double width = size.width;
    double height = size.height;
    double itemWidth = width / 5;

    double curveStart = itemWidth * 1.6;
    double curveEnd = itemWidth * 3.4;
    double center = width / 2;
    double curveDepth = 28;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(curveStart, 0);

    path.cubicTo(
      curveStart + (center - curveStart) * 0.45, 0,
      center - (center - curveStart) * 0.3, curveDepth,
      center, curveDepth,
    );
    path.cubicTo(
      center + (center - curveStart) * 0.3, curveDepth,
      curveEnd - (center - curveStart) * 0.45, 0,
      curveEnd, 0,
    );

    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
