import 'package:flutter/material.dart';
import 'package:truebroker/categories/detail_screen.dart';

class Step4Plot extends StatefulWidget {
  const Step4Plot({super.key});

  @override
  State<Step4Plot> createState() => _Step4PlotState();
}

class _Step4PlotState extends State<Step4Plot> {
  // ── Selected amenities (shown as chips with ✕) ──────────────────────────
  List<String> _selectedAmenities = [
    'Maintenance Staff',
    'Water Storage',
  ];

  // ── Suggested amenities (shown with + prefix) ───────────────────────────
  List<String> _allSuggestedCategories = [
    'Pool',
    'Parking /Garder',
    'Main Road',
    'Club',
  ];

  // ── Property Facing ──────────────────────────────────────────────────────
  List<String> _allFacingOptions = [
    'North',
    'South',
    'East',
    'West',
    'North-west',
    'North-East',
    'South-East',
    'South-West',
  ];


  final TextEditingController _newAmenityController = TextEditingController();

  @override
  void dispose() {
    _newAmenityController.dispose();
    super.dispose();
  }

  // ── Add from suggested / facing ─────────────────────────────────────────
  void _addAmenity(String item) {
    if (!_selectedAmenities.contains(item)) {
      setState(() => _selectedAmenities.add(item));
    }
  }

  // ── Remove amenity chip ──────────────────────────────────────────────────
  void _removeAmenity(String item) {
    setState(() => _selectedAmenities.remove(item));
  }

  // ── Remove from suggested / facing list ─────────────────────────────────
  void _removeFromSuggested(String item) {
    setState(() {
      _allSuggestedCategories.remove(item);
      _allFacingOptions.remove(item);
    });
  }

  // ── Reset all ────────────────────────────────────────────────────────────
  void _reset() {
    setState(() {
      _selectedAmenities.clear();
    });
  }

  // ── Bottom sheet for custom amenity ─────────────────────────────────────
  void _showAddNewBottomSheet() {
    _newAmenityController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '+ Add New Amenity',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A26B2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _newAmenityController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Type amenity name...',
                    hintStyle: const TextStyle(
                        color: Color(0xFF757575), fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Color(0xFF742B88), width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      final text = _newAmenityController.text.trim();
                      if (text.isNotEmpty) {
                        setState(() {
                          if (!_selectedAmenities.contains(text)) {
                            _selectedAmenities.add(text);
                          }
                        });
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF742B88),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Add',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Suggested amenities not yet selected
    final unselectedSuggested = _allSuggestedCategories
        .where((item) => !_selectedAmenities.contains(item))
        .toList();

    // All facing options shown as + chips (adds to selectedAmenities)
    final unselectedFacing = _allFacingOptions.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back arrow ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04, vertical: h * 0.015),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, size: w * 0.06),
              ),
            ),
            const Divider(height: 1),

            // ── Title ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04, vertical: h * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Amenities',
                        style: TextStyle(
                            fontSize: w * 0.044,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: h * 0.004),
                      Text(
                        'Amenities, Features and USPs of your property',
                        style: TextStyle(
                            fontSize: w * 0.033,
                            color: const Color(0xFF838080),
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Scrollable body ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04, vertical: h * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Select Amenities label + Reset ───────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Amenities',
                            style: TextStyle(
                                fontSize: w * 0.033,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        GestureDetector(
                          onTap: _reset,
                          child: Text('Reset',
                              style: TextStyle(
                                  fontSize: w * 0.033,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.015),

                    // ── Selected amenity chips + Add New ─────────────────
                    Wrap(
                      spacing: w * 0.025,
                      runSpacing: h * 0.01,
                      children: [
                        ..._selectedAmenities
                            .map((item) => _selectedChip(item, w)),

                        // + Add New Amenities link
                        GestureDetector(
                          onTap: _showAddNewBottomSheet,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.03,
                              vertical: h * 0.007,
                            ),
                            child: IntrinsicWidth(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '+ Add New Amenities',
                                    style: TextStyle(
                                      fontSize: w * 0.033,
                                      color: const Color(0xFF0A26B2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Container(
                                    height: 1,
                                    color: const Color(0xFF0A26B2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.03),

                    // ── Suggested Categories ─────────────────────────────
                    if (unselectedSuggested.isNotEmpty) ...[
                      Text('Suggested Categories',
                          style: TextStyle(
                              fontSize: w * 0.033,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      SizedBox(height: h * 0.015),
                      Wrap(
                        spacing: w * 0.025,
                        runSpacing: h * 0.012,
                        children: unselectedSuggested
                            .map((item) => _plusChip(
                          label: item,
                          w: w,
                          onAdd: () => _addAmenity(item),
                        ))
                            .toList(),
                      ),
                      SizedBox(height: h * 0.03),
                    ],

                    // ── Property Facing ──────────────────────────────────
                    Text('Property Facing',
                        style: TextStyle(
                            fontSize: w * 0.033,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(height: h * 0.015),

                    // Facing chips with + → adds to selectedAmenities
                    Wrap(
                      spacing: w * 0.025,
                      runSpacing: h * 0.012,
                      children: unselectedFacing
                          .map((item) => _plusChip(
                        label: item,
                        w: w,
                        onAdd: () => _addAmenity(item),
                      ))
                          .toList(),
                    ),
                    SizedBox(height: h * 0.16),
                    Padding(
                      padding: EdgeInsets.only(
                        left: w * 0.04,
                        right: w * 0.04,
                        bottom: h * 0.010,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PropertyDetailPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF742B88),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
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

  // ── Selected amenity chip (purple bg + ✕ circle on right) ───────────────
  Widget _selectedChip(String label, double w) {
    return Container(
      padding:
      EdgeInsets.only(left: w * 0.03, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF742B88),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: w * 0.033,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          // ✕ circle suffix
          GestureDetector(
            onTap: () => _removeAmenity(label),
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.close, size: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Selected facing chip (same style as amenity) ─────────────────────────

  // ── Suggested / Facing chip (+ icon tap = add, ✕ icon tap = remove) ──────
  Widget _plusChip({
    required String label,
    required double w,
    required VoidCallback onAdd,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF834394),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // + icon — tap to add
          GestureDetector(
            onTap: onAdd,
            child: const Icon(Icons.add, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: w * 0.033,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          // ✕ circle — tap to remove from list
          GestureDetector(
            onTap: () => _removeFromSuggested(label),
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.close, size: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}