import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────────────────────

class ReviewModel {
  final String name;
  final String date;
  final int rating;
  final String text;
  ReviewModel({
    required this.name,
    required this.date,
    required this.rating,
    required this.text,
  });
}

// ─────────────────────────────────────────────────────────────
//  PROPERTY DETAIL PAGE
// ─────────────────────────────────────────────────────────────

class PropertyDetailPage extends StatefulWidget {
  const PropertyDetailPage({super.key});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  static const Color kPurple = Color(0xFF742B88);

  bool _isLiked = false;
  Set<int> expandedIndexes = {};

  final TextEditingController _reviewController = TextEditingController();
  final FocusNode _reviewFocus = FocusNode();

  final List<ReviewModel> _reviews = [
    ReviewModel(
      name: 'Jennifer Rose',
      date: '2 days ago',
      rating: 5,
      text:
      'Absolutely loved the property. The location is perfect and the amenities are top-notch. Highly recommend for families!',
    ),
    ReviewModel(
      name: 'Nalla Rhuva',
      date: '5 days ago',
      rating: 4,
      text:
      'Great value for money. The property has everything we need. Parking can sometimes be tight on weekends.',
    ),
  ];

  final String _propertyImage = 'assets/categories/luxury.png';

  final List<Map<String, dynamic>> _amenities = [
    {'icon': Icons.wifi, 'label': 'High-speed Internet'},
    {'icon': Icons.fitness_center, 'label': 'Gym'},
    {'icon': Icons.local_laundry_service, 'label': 'Washer/Dryer'},
    {'icon': Icons.fireplace, 'label': 'Fireplace'},
    {'icon': Icons.ac_unit, 'label': 'Air Conditioning'},
    {'icon': Icons.thermostat, 'label': 'Central Heating'},
    {'icon': Icons.garage, 'label': 'Garage'},
    {'icon': Icons.pool, 'label': 'Swimming Pool'},
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    _reviewFocus.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLiked ? '♥ Added to wishlist' : '♡ Removed from wishlist',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        backgroundColor: kPurple,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      ),
    );
  }

  void _submitReview() {
    final text = _reviewController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _reviews.insert(
        0,
        ReviewModel(name: 'You', date: 'Just now', rating: 5, text: text),
      );
    });
    _reviewController.clear();
    _reviewFocus.unfocus();
  }

  // ─────────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(w),
                  _buildImageSection(w, h),
                  Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.016, w * 0.04, 0),
                    child: _buildPriceRow(w),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.012),
                    child: _buildInfoGrid(w),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: _buildDescription(w),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.018, w * 0.04, 0),
                    child: _buildAmenities(w),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.018, w * 0.04, 0),
                    child: _buildFeatures(w),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.018, w * 0.04, 0),
                    child: _buildLocationSection(w, h),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.018, w * 0.04, 0),
                    child: _buildReviews(w),
                  ),
                  SizedBox(height: h * 0.13),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(w, h),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  TOP BAR
  // ─────────────────────────────────────────────────────────────

  Widget _buildTopBar(double w) {
    return Container(
      color: const Color(0xFF742B88), // violet background
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.03,
              vertical: w * 0.025,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Colors.white, // white icon
                  ),
                ),
                SizedBox(width: w * 0.03),
                Text(
                  'Commercial Lands',
                  style: TextStyle(
                    fontSize: w * 0.046,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // white text
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.white.withOpacity(0.2), // subtle divider
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  IMAGE SECTION
  // ─────────────────────────────────────────────────────────────

  Widget _buildImageSection(double w, double h) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: h * 0.28,
          child: Image.asset(
            _propertyImage,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFEDD9F6),
              child: const Icon(Icons.home_outlined, size: 60, color: kPurple),
            ),
          ),
        ),

        // Heart icon
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: _toggleLike,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isLiked
                    ? const Color(0xFFF5EAFC)
                    : Colors.white.withOpacity(0.92),
                border: Border.all(
                  color: _isLiked ? kPurple : Colors.grey.shade300,
                  width: 1.2,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(_isLiked),
                  size: 18,
                  color: kPurple,
                ),
              ),
            ),
          ),
        ),

        // Share icon
        Positioned(
          top: 56,
          right: 12,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.92),
                border: Border.all(color: Colors.grey.shade300, width: 1.2),
              ),
              child: const Icon(Icons.share_outlined, size: 18, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  PRICE ROW
  // ─────────────────────────────────────────────────────────────

  Widget _buildPriceRow(double w) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '₹4,50,000',
          style: TextStyle(
            fontSize: w * 0.055,
            fontWeight: FontWeight.w700,
            color: kPurple,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '₹4,90,000',
          style: TextStyle(
            fontSize: w * 0.036,
            color: Colors.black45,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '(Negotiable)',
          style: TextStyle(fontSize: w * 0.030, color: Colors.blue.shade700),
        ),
        const Spacer(),
        Text(
          '● Available',
          style: TextStyle(
            fontSize: w * 0.030,
            color: Colors.green.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  INFO GRID
  // ─────────────────────────────────────────────────────────────

  Widget _buildInfoGrid(double w) {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Property Type', 'value': 'House'},
      {'icon': Icons.bed_outlined, 'label': 'Bedrooms', 'value': '3'},
      {'icon': Icons.bathtub_outlined, 'label': 'Bathrooms', 'value': '2'},
      {'icon': Icons.straighten, 'label': 'Area', 'value': '1,850 sq.ft.'},
      {'icon': Icons.calendar_today_outlined, 'label': 'Year Built', 'value': '2015'},
      {'icon': Icons.local_parking_outlined, 'label': 'Parking', 'value': '2 Garage'},
    ];

    Widget cell(Map<String, dynamic> item) => Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item['icon'] as IconData, size: 20, color: const Color(0xFF7C348D)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['value'] as String,
                    style: TextStyle(
                      fontSize: w * 0.032,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['label'] as String,
                    style: TextStyle(fontSize: w * 0.025, color: Colors.black45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        Row(children: [cell(items[0]), cell(items[1]), cell(items[2])]),
        Row(children: [cell(items[3]), cell(items[4]), cell(items[5])]),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  DESCRIPTION
  // ─────────────────────────────────────────────────────────────

  Widget _buildDescription(double w) {
    const fullText =
        'This stunning modern house in the heart of Manhattan offers the perfect blend of luxury and comfort. Recently renovated with high-end finishes, this property features an open floor plan that\'s perfect for entertaining.\n\n'
        'The gourmet kitchen boasts stainless steel appliances, quartz countertops, and custom cabinetry. The spacious master suite includes a walk-in closet and spa-like bathroom with dual vanities and a soaking tub.\n\n'
        'Located in one of New York\'s most desirable neighborhoods, this home is just steps from Central Park, top-rated schools, and world-class shopping and dining.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Description', w),
        const SizedBox(height: 8),
        Text(
          fullText,
          style: TextStyle(fontSize: w * 0.034, color: Colors.black54, height: 1.65),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  AMENITIES
  // ─────────────────────────────────────────────────────────────

  Widget _buildAmenities(double w) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Amenities', w),
        const SizedBox(height: 10),
        Column(
          children: List.generate(
            (_amenities.length / 2).ceil(),
                (rowIdx) {
              final left = _amenities[rowIdx * 2];
              final rightIdx = rowIdx * 2 + 1;
              final hasRight = rightIdx < _amenities.length;
              return Row(
                children: [
                  _amenityCell(left, w),
                  hasRight
                      ? _amenityCell(_amenities[rightIdx], w)
                      : const Expanded(child: SizedBox()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _amenityCell(Map<String, dynamic> item, double w) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            Icon(item['icon'] as IconData, size: 16, color: kPurple),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item['label'] as String,
                style: TextStyle(fontSize: w * 0.031, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  FEATURES
  // ─────────────────────────────────────────────────────────────

  Widget _buildFeatures(double w) {
    final features = [
      'Recently renovated with high-end finishes',
      'Open floor plan perfect for entertaining',
      'Gourmet kitchen with stainless steel appliances',
      'Hardwood floors throughout',
      'Spacious master suite with walk-in closet',
      'Private backyard oasis',
      'Energy efficient windows and appliances',
      'Smart home technology',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Features', w),
        const SizedBox(height: 10),
        ...features.map(
              (f) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(Icons.circle, size: 6, color: Colors.black),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: w * 0.033,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  LOCATION
  // ─────────────────────────────────────────────────────────────

  Widget _buildLocationSection(double w, double h) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Location', w),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Container(
            width: 328,
            height: 180,
            child: Image.asset(
              'assets/categories/location.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.map_outlined, size: 50, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _sectionLabel('Video', w),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: SizedBox(
            width: 328,
            height: 180,
            child: Stack(
              children: [
                Image.asset(
                  'assets/categories/video.png',
                  width: 328,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                  ),
                ),
                Container(
                  width: 328,
                  height: 180,
                  color: Colors.grey.withOpacity(0.3),
                ),
                Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  REVIEWS
  // ─────────────────────────────────────────────────────────────

  Widget _buildReviews(double w) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Reviews', w),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  controller: _reviewController,
                  focusNode: _reviewFocus,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Write a review...',
                    hintStyle: const TextStyle(color: Colors.black45, fontSize: 13),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: kPurple, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 38,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurple,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // ── FIX: pass index correctly using asMap().entries ──
        ..._reviews.asMap().entries.map(
              (entry) => _reviewCard(entry.value, w, entry.key),
        ),
      ],
    );
  }

  // ── Review Card — 3 params: model, w, index ──
  Widget _reviewCard(ReviewModel r, double w, int index) {
    final initials = r.name.length >= 2
        ? r.name.substring(0, 2).toUpperCase()
        : r.name.toUpperCase();

    final isExpanded = expandedIndexes.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isExpanded) {
            expandedIndexes.remove(index);
          } else {
            expandedIndexes.add(index);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF5EAFC),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kPurple,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Name + Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.name,
                      style: TextStyle(
                          fontSize: w * 0.034, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      r.date,
                      style: TextStyle(fontSize: w * 0.028, color: Colors.black45),
                    ),
                  ],
                ),
                const Spacer(),
                // Expand / collapse arrow
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Stars
            Row(
              children: List.generate(
                5,
                    (i) => Icon(
                  i < r.rating ? Icons.star : Icons.star_border,
                  size: 14,
                  color: const Color(0xFFF5A623),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Review text — expand / collapse
            Text(
              r.text,
              maxLines: isExpanded ? null : 2,
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: w * 0.032,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  BOTTOM BAR
  // ─────────────────────────────────────────────────────────────

  Widget _buildBottomBar(double w, double h) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
      ),
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.014, w * 0.04, h * 0.03),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xffA4A3A3)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                        color: kPurple, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call, color: Colors.white, size: 16),
                  label: const Text(
                    'Call Now',
                    style: TextStyle(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E8540),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  HELPER
  // ─────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text, double w) {
    return Text(
      text,
      style: TextStyle(
        fontSize: w * 0.042,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF742B88),
      ),
    );
  }
}