import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Lato',
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFD1D1D1), thickness: 1, height: 1),

            // ── CONTENT ─
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Section 1 ──
                    _sectionTitle('1. Acceptance of Terms'),
                    const SizedBox(height: 8),
                    _bodyText(
                      'By accessing or using the True Broker App, you agree to comply with and be bound by these Terms & Conditions. If you do not agree, please do not use the platform.',
                    ),
                    const SizedBox(height: 20),

                    // ── Section 2 ──
                    _sectionTitle('2. Platform Services'),
                    const SizedBox(height: 8),
                    _bodyText('True Broker provides a digital platform for:'),
                    const SizedBox(height: 6),
                    _bulletItem('Buying properties'),
                    _bulletItem('Selling properties'),
                    _bulletItem('Renting properties'),
                    const SizedBox(height: 8),
                    _bodyText('Including:'),
                    const SizedBox(height: 6),
                    _bulletItem('Houses'),
                    _bulletItem('Land / Plots'),
                    _bulletItem('Shops'),
                    _bulletItem('Villas'),
                    const SizedBox(height: 20),

                    // ── Section 3 ──
                    _sectionTitle('3. User Eligibility'),
                    const SizedBox(height: 8),
                    _bulletItem('Users must be 18 years or older'),
                    _bulletItem('Must provide accurate and complete information'),
                    _bulletItem('Responsible for maintaining account confidentiality'),
                    const SizedBox(height: 20),

                    // ── Section 4 ──
                    _sectionTitle('4. User Responsibilities'),
                    const SizedBox(height: 8),
                    _bodyText('Users agree:'),
                    const SizedBox(height: 6),
                    _bulletItem('To provide true and valid property details'),
                    _bulletItem('Not to post misleading, fake, or illegal listings'),
                    _bulletItem('Not to misuse the platform for fraudulent activities'),
                    _bulletItem('To comply with all applicable real estate laws'),
                    const SizedBox(height: 20),

                    // ── Section 5 ──
                    _sectionTitle('5. Intellectual Property'),
                    const SizedBox(height: 8),
                    _bodyText(
                      'All content, logos, and features on True Broker are the property of True Broker and are protected by applicable intellectual property laws.',
                    ),
                    const SizedBox(height: 20),

                    // ── Section 6 ──
                    _sectionTitle('6. Privacy Policy'),
                    const SizedBox(height: 8),
                    _bodyText(
                      'Your use of the app is also governed by our Privacy Policy, which is incorporated into these Terms by reference.',
                    ),
                    const SizedBox(height: 20),

                    // ── Section 7 ──
                    _sectionTitle('7. Limitation of Liability'),
                    const SizedBox(height: 8),
                    _bodyText(
                      'True Broker is not responsible for any disputes, damages, or losses arising from property transactions conducted through the platform.',
                    ),
                    const SizedBox(height: 20),

                    // ── Section 8 ──
                    _sectionTitle('8. Termination'),
                    const SizedBox(height: 8),
                    _bodyText(
                      'We reserve the right to suspend or terminate any account that violates these Terms without prior notice.',
                    ),
                    const SizedBox(height: 20),

                    // ── Section 9 ──
                    _sectionTitle('9. Changes to Terms'),
                    const SizedBox(height: 8),
                    _bodyText(
                      'True Broker may update these Terms at any time. Continued use of the app after changes implies acceptance of the revised Terms.',
                    ),
                    const SizedBox(height: 20),

                    // ── Section 10 ──
                    _sectionTitle('10. Contact Us'),
                    const SizedBox(height: 8),
                    _bodyText(
                      'For any questions regarding these Terms, please contact us at support@truebroker.com.',
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: 'Lato',
      ),
    );
  }

  Widget _bodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontFamily: 'Lato',
        height: 1.5,
      ),
    );
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 13, color: Colors.black87)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'Lato',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}