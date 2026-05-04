import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:truebroker/login/user_reg.dart';

class TurnOnNotificationScreen extends StatefulWidget {
  const TurnOnNotificationScreen({super.key});

  @override
  State<TurnOnNotificationScreen> createState() =>
      _TurnOnNotificationScreenState();
}

class _TurnOnNotificationScreenState extends State<TurnOnNotificationScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // ✅ Real Notification Permission
  Future<void> _onNotificationPressed() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        await Permission.notification.request();
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
    _goToLocationPage();
  }

  // ✅ Real Location Permission
  Future<void> _onLocationPressed() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final status = await Permission.location.status;
      if (status.isDenied) {
        // ✅ Phone-ல real GPS dialog வரும்
        await Permission.location.request();
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    if (mounted) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => const UserRegistrationScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    }
  }

  void _goToLocationPage() {
    _fadeController.reset();
    _slideController.reset();
    _pageController
        .animateToPage(
      1,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    )
        .then((_) {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF444444),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _NotificationPage(
                fadeAnim: _fadeAnim,
                slideAnim: _slideAnim,
                onPressed: _onNotificationPressed,
              ),
              _LocationPage(
                fadeAnim: _fadeAnim,
                slideAnim: _slideAnim,
                onPressed: _onLocationPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PAGE 1 — Notification
// ─────────────────────────────────────────────
class _NotificationPage extends StatelessWidget {
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final VoidCallback onPressed;

  const _NotificationPage({
    required this.fadeAnim,
    required this.slideAnim,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: slideAnim,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),

            const Text(
              'Find. Rent. Own. Lease\n— All in One Place.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '"True Broker"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF742B88),
                height: 1.2,
              ),
            ),

            const SizedBox(height: 60),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '"Don\'t miss your dream property –\nEnable notifications now!"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 5),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Image.asset(
                  'assets/login/Notification.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _PrimaryButton(
                label: 'Turn On Notification',
                onPressed: onPressed,
              ),
            ),

            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PAGE 2 — Location
// ─────────────────────────────────────────────
class _LocationPage extends StatelessWidget {
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final VoidCallback onPressed;

  const _LocationPage({
    required this.fadeAnim,
    required this.slideAnim,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: slideAnim,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),

            // Title
            const Text(
              'Find. Rent. Own. Lease\n— All in One Place.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '"True Broker"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF742B88),
                height: 1.2,
              ),
            ),

            const SizedBox(height: 70),

            // Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                '"Don\'t miss your dream property –\nEnable Location Now!"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(
                  'assets/login/Location.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 1),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _PrimaryButton(
                label: 'Turn On Location',
                onPressed: onPressed,
              ),
            ),

            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared Primary Button
// ─────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C348D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}