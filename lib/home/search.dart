import 'package:flutter/material.dart';

class Search_Screen extends StatefulWidget {
  const Search_Screen({super.key});

  @override
  State<Search_Screen> createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  final TextEditingController _searchController = TextEditingController();

  // Location — editable or just display
  String _location = 'Sulur, Tamil Nadu';

  // Recent Searches list
  List<String> _recentSearches = ['Land', 'House', 'Rent', 'Apartment'];

  // Popular Properties chips (static)
  final List<String> _popularProperties = ['Land', 'House', 'Rent', 'Apartment'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable body ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.01),

                    // ── 1. Find Your Properties Search Bar ──
                    // Figma: w328 h40 radius100 bg:#FAECFE shadow:0 4 4 #00000040
                    Container(
                      width: 328,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAECFE),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40000000),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Find Your properties',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9C27B0),
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF742B88),
                            size: 20,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF742B88),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.015),

                    // ── 2. Location Container ──
                    // Figma: w328 h40 radius6 border:1px #9C9C9C shadow:0 4 4 #00000040
                    Container(
                      width: 328,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF9C9C9C), width: 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40000000),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: Color(0xFF742B88), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.025),

                    // ── 3. Recent Searches ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        // Clear All button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _recentSearches.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF742B88),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Clear All',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF032776),
                                decoration: TextDecoration.underline,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.012),

                    // Recent search chips
                    _recentSearches.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No recent searches',
                        style: TextStyle(fontSize: 13, color: Colors.black45),
                      ),
                    )
                        : Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: _recentSearches
                          .map((item) => _buildSearchChip(item, isRecent: true))
                          .toList(),
                    ),

                    SizedBox(height: h * 0.025),

                    // ── 4. Popular Properties ──
                    const Text(
                      'Popular Properties',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: h * 0.012),

                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: _popularProperties
                          .map((item) => _buildSearchChip(item, isRecent: false))
                          .toList(),
                    ),

                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search Chip Widget ──
  Widget _buildSearchChip(String label, {required bool isRecent}) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        // If popular property tapped, add to recent
        if (!isRecent && !_recentSearches.contains(label)) {
          setState(() => _recentSearches.insert(0, label));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: const Color(0xFF9C9C9C), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon inside chip
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_outlined,
                size: 11,
                color: Color(0xFF742B88),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}