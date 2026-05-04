import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:truebroker/login/otp.dart';
import 'signup.dart';

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.50);

    path.cubicTo(
      size.width * 0.50, size.height * 1.05,
      size.width * 0.60, size.height * 1.05,
      size.width, size.height * 0.40,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_) => false;
}

class _FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.20);
    path.cubicTo(
      size.width * 0.35, size.height * 1.10,
      size.width * 0.75, size.height * 0.20,
      size.width, size.height * 0.55,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> _) => false;
}

class OtpScreen1 extends StatefulWidget {
  const OtpScreen1({super.key});

  @override
  State<OtpScreen1> createState() => _OtpScreen1State();
}

class _OtpScreen1State extends State<OtpScreen1> {
  static const Color kPurple      = Color(0xFF7C348D);
  static const Color kLightPurple = Color(0xFFE1B6FE);
  static const Color kInputBg     = Color(0xFFEEEEEE);

  final TextEditingController _phoneCtrl = TextEditingController();
  bool _hasInput  = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _phoneCtrl.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    final hasText = _phoneCtrl.text.isNotEmpty;
    if (hasText != _hasInput) setState(() => _hasInput = hasText);
  }

  @override
  void dispose() {
    _phoneCtrl.removeListener(_onPhoneChanged);
    _phoneCtrl.dispose();
    super.dispose();
  }

  Color get _otpColor => _hasInput ? kPurple : kLightPurple;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;

    double pw(double px) => sw * (px / 360);
    double ph(double px) => sh * (px / 800);

    final headerH = ph(160);
    final footerH = ph(80);

    final keyboardOpen = mq.viewInsets.bottom > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor:           Color(0xFF000000),
        statusBarIconBrightness:  Brightness.light,
        statusBarBrightness:      Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor:          Colors.white,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [

            Positioned(
              top: 0, left: 0, right: 0,
              child: SizedBox(
                width: sw,
                height: ph(220),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipPath(
                      clipper: _HeaderClipper(),
                      child: Container(
                        width: sw,
                        height: ph(250),
                        color: kPurple,
                      ),
                    ),
                    Positioned(
                      top:  ph(60),
                      left: pw(82),
                      child: Image.asset(
                        'assets/login/Truebroker.png',
                        width:  pw(195),
                        height: ph(43.97),
                        fit:    BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top:    headerH,
              left:   0,
              right:  0,
              bottom: keyboardOpen ? 0 : footerH,
              child: SingleChildScrollView(
                physics: keyboardOpen
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: pw(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Transform.translate(
                        offset: Offset(0, -ph(10)),
                        child: Image.asset(
                          'assets/login/Group.png',
                          width:  pw(200),
                          height: ph(180),
                          fit:    BoxFit.contain,
                        ),
                      ),

                      Transform.translate(
                        offset: Offset(0, -ph(33)),
                        child: Text(
                          'Enter Your Mobile Number',
                          style: TextStyle(
                            fontFamily:  'Poppins',
                            fontSize:    pw(16),
                            fontWeight:  FontWeight.w700,
                            color:       Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: ph(1)),

                      Transform.translate(
                        offset: Offset(0, -ph(25)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: ph(44),
                          decoration: BoxDecoration(
                            color:         kInputBg,
                            borderRadius:  BorderRadius.circular(pw(8)),
                            border: Border.all(
                              color: _hasInput ? kPurple : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: pw(14)),
                              Text(
                                '+ 91',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize:   pw(14),
                                  fontWeight: FontWeight.w600,
                                  color:      Colors.black87,
                                ),
                              ),
                              SizedBox(width: pw(8)),
                              Container(
                                width:  1.5,
                                height: ph(22),
                                color:  Colors.grey.shade400,
                              ),
                              SizedBox(width: pw(10)),
                              Expanded(
                                child: TextField(
                                  controller:     _phoneCtrl,
                                  keyboardType:   TextInputType.phone,
                                  maxLength:      10,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(
                                    fontFamily:    'Poppins',
                                    fontSize:      pw(14),
                                    color:         Colors.black87,
                                    letterSpacing: 1.5,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Your 10-Digit Mobile Number',
                                    hintStyle: TextStyle(
                                      fontFamily:    'Poppins',
                                      fontSize:      pw(12.5),
                                      color:         Colors.grey.shade500,
                                      letterSpacing: 0,
                                    ),
                                    counterText:    '',
                                    border:         InputBorder.none,
                                    isDense:        true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              if (_hasInput && _phoneCtrl.text.length == 10)
                                Padding(
                                  padding: EdgeInsets.only(right: pw(12)),
                                  child: Icon(
                                    Icons.check,
                                    color: const Color(0xFF079436),
                                    size:  pw(19),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTapDown:   (_) => setState(() => _isPressed = true),
                        onTapUp:     (_) => setState(() => _isPressed = false),
                        onTapCancel: ()  => setState(() => _isPressed = false),
                        onTap: () {
                          if (_phoneCtrl.text.length == 10) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) =>OtpVerificationScreen(
                                  phoneNumber: _phoneCtrl.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: AnimatedScale(
                          scale:    _isPressed ? 0.96 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width:  double.infinity,
                            height: ph(44),
                            decoration: BoxDecoration(
                              color:         _otpColor,
                              borderRadius:  BorderRadius.circular(50),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Get OTP',
                              style: TextStyle(
                                fontFamily:    'Poppins',
                                fontSize:      pw(15),
                                fontWeight:    FontWeight.w600,
                                color:         Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: ph(3)),

                      SizedBox(
                        height: ph(26),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Divider(color: Colors.grey.shade300, thickness: 1),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: pw(5),
                                vertical:   ph(1),
                              ),
                              decoration: BoxDecoration(
                                color:         const Color(0xFFEBEBEB),
                                borderRadius:  BorderRadius.circular(6),
                              ),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize:   pw(12),
                                  color:      Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: ph(4)),

                      Text(
                        'continue with',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize:   pw(12),
                          color:      Colors.grey.shade500,
                        ),
                      ),

                      SizedBox(height: ph(8)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialBtn(
                            asset: 'assets/login/Apple.png',
                            size:  pw(48),
                            onTap: () {},
                          ),
                          SizedBox(width: pw(18)),
                          _SocialBtn(
                            asset: 'assets/login/Google.png',
                            size:  pw(48),
                            onTap: () {},
                          ),
                        ],
                      ),

                      SizedBox(height: ph(14)),

                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize:   12,
                            fontWeight: FontWeight.w400,
                            color:      Colors.black,
                            height:     20 / 12,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By continuing you agree to our\n'
                                  'terms of service privacy policy content policy\n'
                                  'Already have an account? ',
                            ),
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color:      kPurple,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: ph(10)),

                      if (!_hasInput && !keyboardOpen) ...[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width:  pw(320),
                            height: ph(40),
                            decoration: BoxDecoration(
                              color:         Colors.white,
                              borderRadius:  BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0x807C348D),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Continue Without Account',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize:   pw(13.5),
                                fontWeight: FontWeight.w600,
                                color:      kPurple,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ph(10)),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            if (!keyboardOpen)
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: ClipPath(
                  clipper: _FooterWaveClipper(),
                  child: Container(
                    width:  sw,
                    height: ph(80),
                    color:  kPurple,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  const _SocialBtn({
    required this.asset,
    required this.size,
    required this.onTap,
  });

  final String       asset;
  final double       size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:  size,
        height: size,
        decoration: BoxDecoration(
          color:  Colors.white,
          shape:  BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withValues(alpha: 0.07),
              blurRadius: 6,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(size * 0.20),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}