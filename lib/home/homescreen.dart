import 'package:flutter/material.dart';
import 'dart:async';

import 'package:truebroker/profile/edit_profile.dart';
import 'package:truebroker/profile/profile.dart';


class HomeScreen extends StatefulWidget {
  final Widget? bottomNavigationBar;
  final Function(int)? onNavigate;
  const HomeScreen({super.key, this.bottomNavigationBar, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentHeroIndex = 0;
  int _currentBannerIndex = 0;
  int _selectedNavIndex = 0;
  String _selectedAction = "Buy";

  // Search animation
  int _searchIndex = 0;
  final List<String> _searchKeywords = ["Properties", "Sell", "Buy", "Rent"];
  Timer? _searchTimer;
  final TextEditingController _searchController = TextEditingController();

  late PageController _heroController;
  late PageController _bannerController;
  Timer? _heroTimer;
  Timer? _bannerTimer;

  final List<String> _heroImages = [
    'assets/Home screen/Image1.png',
    'assets/Home screen/Image2.png',
    'assets/Home screen/Image3.png',
  ];

  final List<String> _bannerImages = [
    'assets/Home screen/Banner1.png',
    'assets/Home screen/Banner2.png',
    'assets/Home screen/Banner3.png',
  ];

  @override
  void initState() {
    super.initState();
    _heroController = PageController(initialPage: 0);
    _bannerController = PageController(initialPage: 0);

    _heroTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentHeroIndex < _heroImages.length - 1) {
        _currentHeroIndex++;
      } else {
        _currentHeroIndex = 0;
      }
      if (_heroController.hasClients) {
        _heroController.animateToPage(
          _currentHeroIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });

    _bannerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentBannerIndex = (_currentBannerIndex + 1) % _bannerImages.length;
        });
      }
    });

    _searchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _searchIndex = (_searchIndex + 1) % _searchKeywords.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _bannerTimer?.cancel();
    _searchTimer?.cancel();
    _heroController.dispose();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // --- Helper Methods (Moved inside the State class to fix scoping) ---

  Widget _buildSectionHeader(double Function(double) pw, String title, {double? fontSize}) {
    double fs = fontSize ?? pw(16);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pw(16)),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: fs,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lato',
            height: 12 / fs,
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(double Function(double) pw, double Function(double) ph, String label, String imgPath) {
    final isSelected = _selectedAction == label;

    // Determine the icon to show
    String effectiveImgPath = imgPath;
    if (isSelected) {
      if (label == "Buy") {
        effectiveImgPath = "assets/Home screen/buy.png";
      } else if (label == "Rent") {
        effectiveImgPath = "assets/Home screen/rent.png";
      } else if (label == "Lease" || label == "Plot/Land") {
        effectiveImgPath = "assets/Home screen/leaseandplot.png";
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() => _selectedAction = label);
        if (widget.onNavigate != null) {
          widget.onNavigate!(1); // Navigate to Categories (index 1)
        }
      },
      child: Container(
        width: pw(70),
        height: ph(83),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C348D) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isSelected ? pw(36) : pw(42),
              height: isSelected ? pw(36) : pw(42),
              decoration: isSelected
                  ? const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              )
                  : null,
              child: Center(
                child: Image.asset(
                  effectiveImgPath,
                  width: isSelected ? pw(19) : pw(42),
                  height: isSelected ? pw(19) : pw(42),
                  color: isSelected ? const Color(0xFF742B88) : null,
                ),
              ),
            ),
            SizedBox(height: ph(6)),
            Text(
              label,
              style: TextStyle(
                fontSize: pw(11),
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityItem(double Function(double) pw, double Function(double) ph, String name, String imgPath) {
    return Padding(
      padding: EdgeInsets.only(right: pw(16)),
      child: Column(
        children: [
          CircleAvatar(radius: pw(35), backgroundImage: AssetImage(imgPath)),
          SizedBox(height: ph(4)),
          Text(name, style: TextStyle(fontSize: pw(12))),
        ],
      ),
    );
  }

  Widget _buildFeedbackEmoji(double Function(double) pw, IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF7C348D), size: pw(28)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: pw(11), color: const Color(0xFF7C348D)),
        ),
      ],
    );
  }

  Widget _buildNavItem(int idx, IconData icon, String label) {
    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = idx),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotlight(double sw, double Function(double) pw, double Function(double) ph) {
    double itemWidth = sw / 5;
    double leftOffset = _selectedNavIndex * itemWidth;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      left: leftOffset,
      bottom: ph(10), // Positioned above the icon
      child: SizedBox(
        width: itemWidth,
        height: ph(55),
        child: CustomPaint(painter: SpotlightBeamPainter()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;

    double pw(double px) => sw * (px / 360);
    double ph(double px) => sh * (px / 800);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // --- TOP HERO SECTION ---
                  SizedBox(height: ph(55)),
                  Stack(
                    children: [
                      SizedBox(
                        width: pw(360),
                        height: ph(200),
                        child: PageView.builder(
                          controller: _heroController,
                          onPageChanged: (idx) => setState(() => _currentHeroIndex = idx),
                          itemCount: _heroImages.length,
                          itemBuilder: (context, index) {
                            return Image.asset(_heroImages[index], width: pw(360), height: ph(200), fit: BoxFit.cover);
                          },
                        ),
                      ),
                      // Filter Icon (Corrected to 3-line filter as shown in UI)
                      Positioned(
                        top: ph(20),
                        right: pw(20),
                        child: Container(
                          width: pw(36),
                          height: pw(36),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.filter_list, color: Colors.black, size: pw(22)),
                        ),
                      ),
                    ],
                  ),

                  // --- SEARCH BOX ---
                  Transform.translate(
                    offset: Offset(0, ph(-22)),
                    child: Container(
                      width: pw(290),
                      height: ph(44),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFD889ED), width: 1),
                        boxShadow: const [BoxShadow(color: Color(0x80742B88), blurRadius: 6)],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: pw(10)),
                          Icon(
                            Icons.search,
                            color: const Color(0xFF333333),
                            size: pw(22),
                          ),
                          SizedBox(width: pw(10)),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _searchController,
                                  builder: (context, value, child) {
                                    if (value.text.isNotEmpty) return const SizedBox.shrink();
                                    return child!;
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Search',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: pw(14),
                                          height: 1.0,
                                          color: const Color(0xFF676767),
                                        ),
                                      ),
                                      SizedBox(width: pw(10)),
                                      Text(
                                        '"${_searchKeywords[_searchIndex]}"',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: pw(14),
                                          height: 1.0,
                                          color: const Color(0xFF742B88),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextField(
                                  controller: _searchController,
                                  textAlignVertical: TextAlignVertical.center,
                                  cursorColor: const Color(0xFF742B88),
                                  cursorWidth: 1.2,
                                  cursorHeight: pw(16),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: pw(14),
                                    height: 1.0,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- ACTION CARDS ---
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: pw(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionCard(pw, ph, "Buy", "assets/Home screen/Card1.png"),
                        _buildActionCard(pw, ph, "Rent", "assets/Home screen/Card2.png"),
                        _buildActionCard(pw, ph, "Lease", "assets/Home screen/Card3.png"),
                        _buildActionCard(pw, ph, "Plot/Land", "assets/Home screen/Card3.png"),
                      ],
                    ),
                  ),

                  SizedBox(height: ph(20)),

                  // --- BANNER CAROUSEL ---
                  SizedBox(
                    width: pw(328),
                    height: ph(145),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: Image.asset(
                          _bannerImages[_currentBannerIndex],
                          key: ValueKey<int>(_currentBannerIndex),
                          width: pw(328),
                          height: ph(145),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ph(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: pw(2)),
                      width: pw(16),
                      height: ph(6),
                      decoration: BoxDecoration(
                        color: _currentBannerIndex == index ? const Color(0xFF004304) : const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(ph(3)),
                      ),
                    )),
                  ),

                  SizedBox(height: ph(15)),
                  _buildSectionHeader(pw, "On going Projects for Sale", fontSize: pw(14)),
                  SizedBox(height: ph(8)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: pw(16)),
                    child: Image.asset('assets/Home screen/Projects.png', width: sw - pw(32), fit: BoxFit.contain),
                  ),

                  SizedBox(height: ph(25)),
                  _buildSectionHeader(pw, "Explore Popular Cities"),
                  SizedBox(height: ph(12)),
                  SizedBox(
                    height: ph(120),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: pw(16)),
                      children: [
                        _buildCityItem(pw, ph, "Chennai", "assets/Home screen/Chennai.png"),
                        _buildCityItem(pw, ph, "Madurai", "assets/Home screen/Madurai.png"),
                        _buildCityItem(pw, ph, "Thanjavur", "assets/Home screen/Thanjavur.png"),
                        _buildCityItem(pw, ph, "Salem", "assets/Home screen/Salem.png"),
                      ],
                    ),
                  ),

                  SizedBox(height: ph(25)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: pw(16)),
                    child: Image.asset('assets/Home screen/Projects.png', width: sw - pw(32), fit: BoxFit.contain),
                  ),

                  SizedBox(height: ph(30)),
                  // --- FEEDBACK SECTION ---
                  Container(
                    width: pw(328),
                    padding: EdgeInsets.all(pw(16)),
                    decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Text("Are you finding us helpful?", style: TextStyle(fontSize: pw(15), fontWeight: FontWeight.bold)),
                        SizedBox(height: ph(4)),
                        Text("Your Feedback will help us to make\nTRUE BROKER the best", textAlign: TextAlign.center, style: TextStyle(fontSize: pw(12), color: Colors.grey[700])),
                        SizedBox(height: ph(16)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFeedbackEmoji(pw, Icons.sentiment_very_dissatisfied, "Poor"),
                            _buildFeedbackEmoji(pw, Icons.sentiment_neutral, "Okay"),
                            _buildFeedbackEmoji(pw, Icons.sentiment_satisfied, "Average"),
                            _buildFeedbackEmoji(pw, Icons.sentiment_very_satisfied, "Excellent"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ph(30)), // Adjusted to remove 100px bottom spacing
                ],
              ),
            ),

            // --- APP BAR ---
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: ph(60), color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: pw(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>ProfileScreen ()),
                            );
                          },
                          child: Image.asset('assets/Home screen/Appbar1.png', width: pw(38), height: pw(38)),
                        ),
                        SizedBox(width: pw(8)),
                        Image.asset('assets/Home screen/Appbar2.png', width: pw(127), height: ph(50), fit: BoxFit.contain),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset('assets/Home screen/Appbar3.png', width: pw(24), height: ph(24)),
                        SizedBox(width: pw(12)),
                        Image.asset('assets/Home screen/Appbar4.png', width: pw(24), height: ph(24)),
                      ],
                    ),
                  ],
                ),
              ),
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
    Paint paint = Paint()..color = const Color(0xFF7C348D)..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20);
    path.lineTo(size.width * 0.35, 20);
    // Deep center curve overhaul
    path.quadraticBezierTo(size.width * 0.40, 20, size.width * 0.40, 45);
    path.arcToPoint(Offset(size.width * 0.60, 45), radius: const Radius.circular(25), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 20, size.width * 0.65, 20);
    path.lineTo(size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SpotlightBeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Colors.white.withAlpha((0.4 * 255).toInt()), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path path = Path();
    // Trapezoid shape: Narrow at top, wider at bottom (or vice versa depending on "rotate")
    // Let's make it wider at top for a beam look
    path.moveTo(size.width * 0.1, size.height);
    path.lineTo(size.width * 0.9, size.height);
    path.lineTo(size.width * 0.7, 0);
    path.lineTo(size.width * 0.3, 0);
    path.close();

    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}
