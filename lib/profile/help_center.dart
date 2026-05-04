import 'package:flutter/material.dart';

class HelpCentreScreen extends StatelessWidget {
  const HelpCentreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── APP BAR ──
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
                    'Help Centre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFD1D1D1), thickness: 1, height: 1),

            // ── CONTENT ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _helpItem(
                      number: '1.',
                      heading: 'How to Search Properties',
                      body: 'Easily find houses, land, shops, and villas using filters like location, price, and type.',
                    ),

                    _helpItem(
                      number: '2.',
                      heading: 'How to Post a Listing',
                      body: 'Add your property with images, price, and details to sell or rent quickly.',
                    ),

                    _helpItem(
                      number: '3.',
                      heading: 'Contact Buyer/Seller',
                      body: 'Use chat or call options to directly connect with property owners or buyers.',
                    ),

                    _helpItem(
                      number: '4.',
                      heading: 'Account & Login Support',
                      body: 'Get help with login issues, OTP verification, or updating your profile.',
                    ),

                    _helpItem(
                      number: '5.',
                      heading: 'Report Issues / Fake Listings',
                      body: 'Report suspicious users or incorrect property details for quick action.',
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

  Widget _helpItem({
    required String number,
    required String heading,
    required String body,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number ',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  letterSpacing: 0,
                ),
              ),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Body text (indented to align with heading text)
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              body,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 25 / 14,
                letterSpacing: 0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}