import 'package:flutter/material.dart';
import 'package:truebroker/login/login.dart';
import 'package:truebroker/profile/edit_profile.dart';
import 'package:truebroker/profile/help_center.dart';
import 'package:truebroker/profile/terms&condition.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  bool isSwitched = false;
  List<bool> switchValues = [false, false, false];
  int _selectedRating = 0;

  // Replace hardcoded strings with these state variables
  String _userName = 'Sowmiya';
  String _userEmail = 'sowmiyag@example.com';
  String _userPhone = '+91 9876543210';
  String _userLocation = 'Coimbatore';

  // ── Rate Us bottom sheet ─────────────────────────────────────────────────
  void _showRateUsBottomSheet() {
    int tempRating = 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── TOP PINK HEADER (360x82, top-radius 20, bg #E279FF) ──
                Container(
                  width: double.infinity,
                  height: 82,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE279FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0XFFD9D9D9),
                              )
                            ),
                            child: const Icon(Icons.close, size: 13, color: Color(0XFFD9D9D9)),
                          ),
                        ),
                      ),
                      // center icon (35x35) top:11
                      Positioned(
                        top: 11,
                        left: 0, right: 0,
                        child: Center(
                          child: SizedBox(
                            width: 35, height: 35,
                            child: Image.asset(
                              'assets/profile/rate.png',
                              fit: BoxFit.contain,

                            ),
                          ),
                        ),
                      ),
                      // title text bottom of header
                      const Positioned(
                        bottom: 10,
                        left: 0, right: 0,
                        child: Center(
                          child: Text(
                            'Helps Us Improve With Your Feedback !',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── BOTTOM WHITE SECTION ──────────────────────────────────
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: 16, right: 16, top: 16,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    RichText(text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Rate Your Experience On ',
                        ),
                        TextSpan(
                          text: 'True Broker',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff742B88),
                          )
                        )
                      ]
                    ),),
                      SizedBox(height: 16),

                      // Stars
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          return GestureDetector(
                            onTap: () => setSheetState(() => tempRating = i + 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Icon(
                                i < tempRating ? Icons.star : Icons.star_border,
                                color: i < tempRating
                                    ? const Color(0xFFFFD700)
                                    : Colors.grey[400],
                                size: 36,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: tempRating == 0
                              ? null
                              : () {
                            setState(() => _selectedRating = tempRating);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 14),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF7E3295), Color(0xFF5D0079)],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 35, height: 34,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset('assets/profile/tick.png',
                                        width: 10,
                                            height: 5,fit: BoxFit.cover),
                                      ),
                                      const SizedBox(width: 10),
                                      const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Thanks For  Sharing Your Feedback',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "We're Committed To Improve Things For You",
                                            style: TextStyle(
                                                color: Color(0XFFD2D2D2), fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tempRating == 0
                                ? Colors.grey[300]
                                : const Color(0xFF742B88),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Submit Feedback',
                            style: TextStyle(
                              color: tempRating == 0 ? Colors.grey : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Add this method to your _ProfileScreenState class
  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 320,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title text
                const Text(
                  'Are you sure, do you want\nto logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF742B88),
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // NO button (filled purple)
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF742B88),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen1()));
                      },
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFF742B88),
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Color(0xFF742B88),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP GRADIENT HEADER
            _buildHeader(w),
            // ── TAB BAR
            _buildTabBar(w),
            // ── TAB CONTENT
            Expanded(
              child: _selectedTab == 0
                  ? _buildProfileTab(w)
                  : _buildSettingsTab(w),
            ),
          ],
        ),
      ),
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader(double w) {
    return Container(
      width: 360,
      height: 175,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.7, -0.7),
          end: Alignment(0.7, 0.7),
          colors: [Color(0xFF7E3295), Color(0xFF5D0079)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // ── Back arrow ──
          Positioned(
            top: 10,
            left: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
          ),

          // ── Close icon ──
          Positioned(
            top: 10,
            right: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 20,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),

          // ── Avatar ──
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.person, size: 45, color: Color(0xffD9D9D9)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA450BE),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Image.asset(
                        'assets/profile/edit.png',
                        width: 20,
                        height: 12,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Name — variable use pannrom ──
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                _userName, // 👈 const podama variable
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ),

          // ── Premium Buyer badge ──
          Positioned(
            top: 119,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 120,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0x33D9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Premium Buyer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Star + 4.8 ──
          const Positioned(
            top: 145,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Color(0xFFFFD700), size: 18),
                  SizedBox(width: 4),
                  Text(
                    '4.8',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Edit button ──
          Positioned(
            bottom: 10,
            right: 18,
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(
                      name: _userName,
                      email: _userEmail,
                      phone: _userPhone,
                      location: _userLocation,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _userName = result['name'];
                    _userEmail = result['email'];
                    _userPhone = result['phone'];
                    _userLocation = result['location'];
                  });
                }
              },
              child: Row(
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Color(0XFF5F037B), size: 14),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lato',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // TAB BAR (width:328, height:38)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTabBar(double w) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      width: 328,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0XFFD9D9D9)
        )
      ),
      child: Row(
        children: [
          _tabItem('Profile', 0),
          _tabItem('Settings', 1),
        ],
      ),
    );
  }

  Widget _tabItem(String label, int index) {
    final isActive = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            ),

          child: Stack(
            children: [
              Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF7B3091)
                        : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Lato',
                  ),
                ),
              ),

              if (isActive)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 2,
                      width: 130,
                      color: const Color(0xFF7B3091),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROFILE TAB
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildProfileTab(double w) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 7),

          // ── Personal Information ─────────────────────────────────────────
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0XFF7B3091),
              fontFamily: 'Lato',

            ),
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.email_outlined,_userEmail ),
          Divider(
            color: Color(0XFFD1D1D1),
            thickness: 1,
          ),
          _infoRow(Icons.phone,_userPhone ),
          Divider(
            color: Color(0XFFD1D1D1),
            thickness: 1,
          ),
          _infoRow(Icons.location_on, _userLocation),
          Divider(
            color: Color(0XFFD1D1D1),
            thickness: 1,
          ),
          const SizedBox(height: 6),
          // ── Preference Locations ─────────────────────────────────────────
          const Text(
            'Preference  Locations:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0XFF7B3091),
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              _locationChip('Coimbatore'),
              _locationChip('Tirupur'),
            ],
          ),
          const SizedBox(height: 12),
          // ── My Activity ──────────────────────────────────────────────────
          const Text(
            'My Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0XFF7B3091),
            ),
          ),
          const SizedBox(height: 5),
          _activityRow(Icons.favorite, 'Wishlist', const Color(0xFF742B88)),
          Divider(
            color: Color(0XFFD1D1D1),
            height: 7,
            thickness: 1,
          ),
          _activityRow(Icons.star_border, 'Rate us', const Color(0xFF742B88), onTap: _showRateUsBottomSheet),
          Divider(
            color: Color(0XFFD1D1D1),
            height: 7,
            thickness: 1,
          ),
          _activityRow(Icons.share, 'Shared Properties', const Color(0xFF742B88)),
          Divider(
            color: Color(0XFFD1D1D1),
            height:7,
            thickness: 1,
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: const Color(0xFF742B88) ,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: const Color(0xFFFFFFFF)),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
  Widget _locationChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xCCF3E8F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF742B88),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
  Widget _activityRow(
      IconData icon,
      String label,
      Color color, {
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xFF742B88),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: Color(0xFFFFFFFF)),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // SETTINGS TAB
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSettingsTab(double w) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          const Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7E3295),
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 4),
          _settingsToggleRow('Push Notifications', 0, Icons.notifications_outlined),
          _divider(),
          _settingsToggleRow('Email Notifications', 1, Icons.email_outlined),
          _divider(),
          _settingsToggleRow('Dark Mode', 2, Icons.dark_mode_outlined),
          _divider(),
          _settingsNavRow('Payment Methods', Icons.payment_outlined),
          _divider(),
          _settingsNavRow('Language', Icons.language_outlined),
          const SizedBox(height: 10),
          const Text(
            'Support',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7E3295),
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 4),
          _settingsNavRow(
            'Help Center',
            Icons.help_outline,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HelpCentreScreen()),
            ),
          ),
          _divider(),
          _settingsNavRow(
            'Terms of Service',
            Icons.description_outlined,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsConditions())
            ),
          ),
          _divider(),
          _settingsVersionRow('App Version', '1.2.4'),
          _divider(),
          _settingsNavRow('Logout', Icons.logout, isLogout: true, onTap: _showLogoutDialog),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(
      color: Color(0xFFD1D1D1), thickness: 1, height: 1);

  Widget _settingsToggleRow(String label, int index, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF742B88),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: switchValues[index],
              onChanged: (val) {
                setState(() {
                  switchValues[index] = val;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Color(0XFF1E8540),
              inactiveThumbColor: Color(0xffD9D9D9),
              inactiveTrackColor: Colors.grey.shade100,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          )
        ],
      ),
    );
  }

  Widget _settingsNavRow(String label, IconData icon,
      {bool isLogout = false, VoidCallback? onTap}) {
    return GestureDetector(
        onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Color(0xFF742B88),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 15, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4444444),
                  fontWeight:FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsVersionRow(String label, String version) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF742B88),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          Text(
            version,
            style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
