import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:truebroker/login/notification.dart';

// ─────────────────────────────────────────────
//  OTP Verification Screen
// ─────────────────────────────────────────────
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const Color kPurple = Color(0xFF7C348D);

  static const Color kGreen = Color(0xFF079436);
  static const Color kTextGrey = Color(0xFF444444);
  static const Color kResendGrey = Color(0xFF686363);
  static const Color kVerifiedGreen = Color(0xFF2B882D);

  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 6;
  bool _canResend = false;
  bool _showSuccessGif = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 6;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpValue => _otpControllers.map((c) => c.text).join();
  bool get _isOtpComplete => _otpValue.length == 6;

  String get _formattedTime {
    final secs = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '0.$secs Sec';
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onOtpBackspace(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onVerifyPressed() {
    if (_isOtpComplete) {
      setState(() => _showSuccessGif = true);

      // ── After 3 seconds GIF plays, navigate to TurnOnNotificationScreen ──
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const TurnOnNotificationScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;

    double pw(double px) => sw * (px / 360);
    double ph(double px) => sh * (px / 800);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF444444),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // ══════════════════════════════════
            //  MAIN SCREEN CONTENT
            // ══════════════════════════════════
            SafeArea(
              child: Column(
                children: [
                  // ── PURPLE APP BAR ──
                  Container(
                    width: sw,
                    height: ph(50),
                    color: kPurple,
                    padding: EdgeInsets.symmetric(horizontal: pw(12)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: pw(24),
                          ),
                        ),
                        SizedBox(width: pw(12)),
                        Text(
                          'OTP Verification',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: pw(17),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── MAIN CONTENT ──
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: pw(20)),
                      child: Column(
                        children: [
                          SizedBox(height: ph(90)),

                          // ── OTP Image ──
                          Image.asset(
                            'assets/login/OTP Enter.png',
                            width: pw(220),
                            height: ph(220),
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: ph(15)),

                          // ── Title ──
                          Text(
                            'OTP Verification',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: pw(20),
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey,
                            ),
                          ),

                          SizedBox(height: ph(10)),

                          // ── Subtitle ──
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: pw(13),
                                fontWeight: FontWeight.w400,
                                color: kTextGrey,
                              ),
                              children: [
                                const TextSpan(text: 'Enter OTP Sent To '),
                                TextSpan(
                                  text: '+91 ${widget.phoneNumber}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kTextGrey,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: ph(30)),

                          // ── OTP Input Boxes (6 digits) ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Container(
                                width: pw(44),
                                height: ph(48),
                                margin:
                                EdgeInsets.symmetric(horizontal: pw(4)),
                                child: RawKeyboardListener(
                                  focusNode: FocusNode(),
                                  onKey: (event) {
                                    if (event is RawKeyDownEvent &&
                                        event.logicalKey ==
                                            LogicalKeyboardKey.backspace) {
                                      _onOtpBackspace(index);
                                    }
                                  },
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: pw(18),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder:
                                      const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kPurple,
                                          width: 2.5,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) =>
                                        _onOtpChanged(value, index),
                                  ),
                                ),
                              );
                            }),
                          ),

                          SizedBox(height: ph(14)),

                          // ── Timer ──
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: pw(20)),
                              child: Text(
                                _formattedTime,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: pw(13),
                                  fontWeight: FontWeight.w500,
                                  color: kGreen,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: ph(14)),

                          // ── Didn't Receive OTP? Resend ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Didn't Receive OTP?  ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: pw(13),
                                  fontWeight: FontWeight.w400,
                                  color: kResendGrey,
                                ),
                              ),
                              GestureDetector(
                                onTap: _canResend
                                    ? () {
                                  _startTimer();
                                  setState(() {});
                                }
                                    : null,
                                child: Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: pw(13),
                                    fontWeight: FontWeight.w600,
                                    color: _canResend ? kPurple : kResendGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // ── Verify & Proceed Button ──
                          GestureDetector(
                            onTap: _onVerifyPressed,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: pw(320),
                              height: ph(48),
                              decoration: BoxDecoration(
                                color: _isOtpComplete
                                    ? kPurple
                                    : kPurple.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Verify & Proceed',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.0,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: ph(30)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ══════════════════════════════════
            //  GIF + OTP Verified! OVERLAY
            // ══════════════════════════════════
            if (_showSuccessGif)
              Positioned.fill(
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Success GIF ──
                      Image.asset(
                        'assets/login/OTP.gif',
                        width: sw * (220 / 360),
                        height: sh * (220 / 800),
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: sh * (40 / 800)),

                      // ── OTP Verified! Text ──
                      Text(
                        'OTP Verified!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: kVerifiedGreen,
                          height: 1.0,
                          letterSpacing: 0,
                        ),
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