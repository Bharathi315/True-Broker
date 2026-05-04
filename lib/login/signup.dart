import 'package:flutter/material.dart';
import 'login.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: _buildLayout(context, 0),
    );
  }

  // ================= MAIN LAYOUT =================

  Widget _buildLayout(BuildContext context, double imageSize) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
          left: w * 0.06,
          right: w * 0.06,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            SizedBox(height: h * 0.06),

            Image.asset(
              'assets/login/signup.png',
              height: h * 0.23,
              fit: BoxFit.contain,
            ),

            SizedBox(height: h * 0.022),

            const Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: h * 0.015),

            // 🔹 FORM
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Name"),
                  _textField(
                    controller: nameController,
                    hint: "Enter your name",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z ]")),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      if (value.length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: h * 0.02),

                  _label("Mobile Number"),
                  _textField(
                    controller: numberController,
                    hint: "Enter mobile number",
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Mobile number is required";
                      }
                      if (value.length != 10) {
                        return "Mobile number must be 10 digits";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: h * 0.02),

                  _label("Email"),
                  _textField(
                    controller: emailController,
                    hint: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      if (!emailRegex.hasMatch(value)) {
                        return 'Enter valid email address';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: h * 0.02),

                  // 🔹 SIGN UP BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.050,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C348D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      onPressed: _onSignUpPressed,
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.02),

            // 🔹 OR
            SizedBox(
              height: h * 0.0325,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'or',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.015),
            const Text(
              "continue with",
              style: TextStyle(fontSize: 14),
            ),

            SizedBox(height: h * 0.02),

            // 🔹 Social Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon('assets/login/Apple.png'),
                SizedBox(width: w * 0.05),
                _socialIcon('assets/login/Google.png'),
              ],
            ),

            SizedBox(height: h * 0.025),

            // 🔹 LOGIN LINK
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color(0xFF6A0DAD),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.04),
          ],
        ),
      ),
    );
  }

  // ================= ACTION =================

  void _onSignUpPressed() {
    if (_formKey.currentState!.validate()) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OtpScreen1()),
        );
      });
    }
  }

  // ================= WIDGETS =================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    Iterable<String>? autofillHints,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Builder(
      builder: (context) {
        double w = MediaQuery.of(context).size.width;
        double h = MediaQuery.of(context).size.height;

        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          validator: validator,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),

            filled: true,
            fillColor: Colors.white,

            contentPadding: EdgeInsets.symmetric(
              horizontal: w * 0.05,
              vertical: h * 0.015,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: w * 0.003,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: w * 0.004,
              ),
            ),

            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(
                color: Colors.red,
                width: 0.003,
              ),
            ),

            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(
                color: Colors.red,
                width: 0.004,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _socialIcon(String assetPath) {
    return Builder(
      builder: (context) {
        double w = MediaQuery.of(context).size.width;

        return Container(
          height: w * 0.12,
          width: w * 0.12,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              assetPath,
              width: w * 0.06,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
