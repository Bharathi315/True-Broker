import 'package:flutter/material.dart';

// ─────────────────────────────────────────
//  ENTRY: Credit Coin Plans Screen
// ─────────────────────────────────────────
class CreditCoinPlansScreen extends StatelessWidget {
  const CreditCoinPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> plans = [
      {
        'title': 'Starter Pack',
        'price': '₹ 1,000',
        'coins': '250 Credit Coins',
        'features': [
          'Great For Trying Out Features',
          'No Expiration',
        ],
        'badge': null,
        'coins_val': 250,
      },
      {
        'title': 'Plan 2000',
        'price': '₹ 2,000',
        'coins': '1000 Credit Coins',
        'features': [
          'Most Popular Choice',
          '40% More Coins Than Starter',
          'No Expiration',
          'Bonus: 50 Extra Coins',
        ],
        'badge': 'Best Value',
        'coins_val': 1000,
      },
      {
        'title': 'Mega Pack',
        'price': '₹ 3,000',
        'coins': '2500 Credit Coins',
        'features': [
          'Best For Power Users',
          '40% More Coins Than Starter',
          '100% More Coins Than Plan 1000',
          'No Expiration',
          'Bonus: 200 Extra Coins',
        ],
        'badge': null,
        'coins_val': 2500,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF742B88),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Credit Coin Plans',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top subtitle
            const Text(
              'Get More Coins For\nPremium Features',
              style: TextStyle(fontSize: 16, color: Colors.black,
              fontWeight: FontWeight.w400),
            ),
            SizedBox(height: h * 0.02),

            // Current Balance Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: h * 0.018,
                horizontal: w * 0.05,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF5F037B),
                    Color(0xFF7E3295),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Your Current Balance',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.4, // line-height 140%
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '2048 Credit Coins',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.025),

            const Text(
              'Coin Packages',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            SizedBox(height: h * 0.015),

            // Plan Cards — each with exact Figma height
            ...plans.asMap().entries.map(
                  (e) => _PlanCard(
                plan: e.value,
                currentBalance: 2048,
                cardIndex: e.key,
              ),
            ),

            SizedBox(height: h * 0.02),
            Center(
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Coins Never Expire. ',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    TextSpan(
                      text: 'Learn How To Use Your Coins',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF742B88),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: h * 0.04),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  Plan Card Widget
// ─────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final int currentBalance;
  final int cardIndex; // 0=Starter h224, 1=BestValue h299, 2=Mega h327
  const _PlanCard({required this.plan, required this.currentBalance, required this.cardIndex});

  @override
  Widget build(BuildContext context) {
    final hasBadge = plan['badge'] != null;
    final double cardHeight = cardIndex == 0 ? 224 : cardIndex == 1 ? 299 : 327;
    final BoxDecoration cardDecoration = hasBadge
        ? BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF1e8540), width: 1.5),
    )
        : BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x40000000),
        ),
      ],
    );

    return Container(
      width: 328,
      height: cardHeight,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: cardDecoration,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasBadge) const SizedBox(height: 14),
                Text(
                  plan['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff1E8540),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  plan['price'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0XFF742B88),
                  ),
                ),
                const SizedBox(height:7),
                Text(
                  plan['coins'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE67E22),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Lato'
                  ),
                ),

                const SizedBox(height: 13),

                ...(plan['features'] as List<String>).map(
                      (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: Color(0xFF1E8540),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            f,
                            style: const TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // ── Purchase Button ──
                Center(
                  child: GestureDetector(
                    onTap: () => _showConfirmPurchaseBottomSheet(
                      context: context,
                      plan: plan,
                      currentBalance: currentBalance,
                    ),
                    child: Container(
                      width: 148,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF742B88),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 6),
                      child: const Text(
                        'Purchase',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Best Value Badge — TOP RIGHT corner ──

          if (hasBadge)
            Positioned(
              top: -9,
              right: 25,
              child: Container(
                width: 76,
                height: 23,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(2), // follows card corner
                    bottomLeft: Radius.circular(2),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                alignment: Alignment.center,
                child: Text(
                  plan['badge'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  Confirm Purchase Bottom Sheet
// ─────────────────────────────────────────
void _showConfirmPurchaseBottomSheet({
  required BuildContext context,
  required Map<String, dynamic> plan,
  required int currentBalance,
}) {
  final newBalance = currentBalance + (plan['coins_val'] as int);

  showModalBottomSheet(
    context: context,
    // Dark backdrop like Figma
    barrierColor: Colors.black.withOpacity(0.6),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // White rounded card — Figma: radius 20, padding 12/13
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Question icon circle
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF742B88), width: 2),
                    ),
                    child: const Icon(
                      Icons.question_mark_rounded,
                      color: Color(0xFF742B88),
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Title — purple, bold
                  const Text(
                    'Confirm Purchase',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF742B88),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "You're about to purchase:",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),

                  // Details rows
                  _detailRow('Package', plan['title']),

                  _detailRow('Coin', '${plan['coins_val']} Coins'),

                  _detailRow('Price', plan['price']),
                  const SizedBox(height: 14),

                  // Balance info box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Text(
                      'Your new token balance will be: $newBalance',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons row
                  Row(
                    children: [
                      // Confirm — Green (Figma screenshot)
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PurchaseSuccessScreen(
                                    plan: plan,
                                    newBalance: newBalance,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Confirm Purchase',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,

                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Cancel — Red (Figma screenshot)
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F), // Red
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(ctx).padding.bottom + 20),
          ],
        ),
      );
    },
  );
}

Widget _detailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black)),
        Text(value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  Purchase Success Screen
// ─────────────────────────────────────────
class PurchaseSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> plan;
  final int newBalance;
  const PurchaseSuccessScreen({
    super.key,
    required this.plan,
    required this.newBalance,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/coin/tick.gif'),
                SizedBox(height: h * 0.02),
                Text(
                  'Purchased Successfully!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF742B88),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: h * 0.10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  Home Screen (placeholder)
// ─────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF742B88),
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_rounded, size: 64, color: Color(0xFF742B88)),
            const SizedBox(height: 16),
            const Text(
              'Welcome Home!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your purchase was successful.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreditCoinPlansScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF742B88),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                'Buy More Coins',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}