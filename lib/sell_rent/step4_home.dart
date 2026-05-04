import 'package:flutter/material.dart';

class Step4Home extends StatefulWidget {
  const Step4Home({super.key});

  @override
  State<Step4Home> createState() => _Step4HomeState();
}

class _Step4HomeState extends State<Step4Home> {

  List<String> _selectedAmenities = ['Rainwater Harvesting', 'Water Storage'];

  final List<String> _suggestedCategories = [
    'Visitor Parking',
    'Maintenance Staff',
    'Rainwater Harvesting',
    'Water Storage',
  ];
  final TextEditingController _newAmenityController = TextEditingController();

  @override
  void dispose() {
    _newAmenityController.dispose();
    super.dispose();
  }

  void _removeAmenity(String item) {
    setState(() {
      _selectedAmenities.remove(item);
      _suggestedCategories.remove(item);
    });
  }

  void _addFromSuggested(String item) {
    if (!_selectedAmenities.contains(item)) {
      setState(() => _selectedAmenities.add(item));
    }
  }

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
            bottom: MediaQuery
                .of(ctx)
                .viewInsets
                .bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag handle ──
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '+ Add New Amenity',
                  style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lato',
                      color: Color(0xff0A26B2)),
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
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      const BorderSide(color: Color(0xFF742B88), width: 1.5),
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

  void _reset() {
    setState(() => _selectedAmenities.clear());
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery
        .of(context)
        .size
        .width;
    final h = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04, vertical: h * 0.015),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, size: w * 0.06),
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04, vertical: h * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Amenities',
                          style: TextStyle(
                              fontSize: w * 0.044,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lato')),
                      SizedBox(height: h * 0.004),
                      Text(
                        'Amenities, Features and USPs of your property',
                        style: TextStyle(
                            fontSize: w * 0.033,
                            color: Color(0XFF838080),
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04, vertical: h * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  color: const Color(0xFF000000),
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.015),
                    Wrap(
                      spacing: w * 0.025,
                      runSpacing: h * 0.01,
                      children: [
                        ..._selectedAmenities.map((item) {
                          return _selectedChip(item, w);
                        }),
                        GestureDetector(
                          onTap: _showAddNewBottomSheet,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: IntrinsicWidth(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '+ Add New Amenities',
                                    style: TextStyle(
                                      fontSize: w * 0.033,
                                      color: const Color(0xFF0A26B2),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Container(
                                    height: 1,
                                    color: Color(0xFF0A26B2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.03),
                    Text('Suggested Categories',
                        style: TextStyle(
                            fontSize: w * 0.033,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(height: h * 0.015),
                    Wrap(
                      spacing: w * 0.025,
                      runSpacing: h * 0.012,
                      children: _suggestedCategories
                          .where((item) =>
                      !_selectedAmenities.contains(item))
                          .map((item) {
                        return _suggestedChip(item, w);
                      }).toList(),
                    ),
                    SizedBox(height: h * 0.05),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: w * 0.04,
                right: w * 0.04,
                bottom: h * 0.02,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF742B88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedChip(String label, double w) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: w * 0.03, vertical: 6),
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
          SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeAmenity(label),
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white70,
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

  Widget _suggestedChip(String label, double w) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0XFF834394),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _addFromSuggested(label),
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: w * 0.033,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeAmenity(label),
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white70,
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