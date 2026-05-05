//home_screen_filter///
import 'package:flutter/material.dart';

class HomeScreenFilter extends StatefulWidget {
  const HomeScreenFilter({super.key});

  @override
  State<HomeScreenFilter> createState() => _HomeScreenFilterState();
}

class _HomeScreenFilterState extends State<HomeScreenFilter> {
  String _selectedPropertyType = "All Types";
  String _selectedLocation = "All Location";
  String _selectedBhk = "Any BHK";

  final Map<String, bool> _amenities = {
    "24/7 Water Supply": true,
    "Power Backup": false,
    "Public Transport": false,
    "Near Schools": false,
    "Near Hospitals": false,
  };

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    double pw(double px) => sw * (px / 360);
    double ph(double px) => sh * (px / 800);

    const Color primaryColor = Color(0xFF7C348D);

    return Drawer(
      width: sw * 0.8,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: pw(16), vertical: ph(10)),
              child: Row(
                children: [
                  Icon(Icons.tune, color: primaryColor, size: pw(22)),
                  SizedBox(width: pw(8)),
                  Text(
                    "Filter Properties",
                    style: TextStyle(
                      fontSize: pw(14),
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Icon(Icons.close, size: pw(16), color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: pw(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ph(20)),

                    // Property Type
                    _buildSectionTitle("Property Type", pw, ph, primaryColor),
                    _buildDropdown(
                      value: _selectedPropertyType,
                      items: ["All Types", "Apartment", "Villa", "Plot", "Commercial"],
                      onChanged: (val) => setState(() => _selectedPropertyType = val!),
                      pw: pw,
                      ph: ph,
                    ),

                    SizedBox(height: ph(20)),

                    // Price Range
                    _buildSectionTitle("Price Range", pw, ph, primaryColor),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _minPriceController,
                            hint: "Min",
                            pw: pw,
                            ph: ph,
                          ),
                        ),
                        SizedBox(width: pw(12)),
                        Expanded(
                          child: _buildTextField(
                            controller: _maxPriceController,
                            hint: "Max",
                            pw: pw,
                            ph: ph,
                          ),
                        ),
                        SizedBox(width: pw(8)),
                        IconButton(
                          icon: Icon(Icons.refresh, color: primaryColor, size: pw(20)),
                          onPressed: () {
                            setState(() {
                              _minPriceController.clear();
                              _maxPriceController.clear();
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: ph(20)),

                    // Location
                    _buildSectionTitle("Location", pw, ph, primaryColor),
                    _buildDropdown(
                      value: _selectedLocation,
                      items: ["All Location", "Chennai", "Coimbatore", "Madurai"],
                      onChanged: (val) => setState(() => _selectedLocation = val!),
                      pw: pw,
                      ph: ph,
                    ),

                    SizedBox(height: ph(20)),

                    // Amenities
                    _buildSectionTitle("Amenities", pw, ph, primaryColor),
                    ..._amenities.keys.map((key) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: ph(10)),
                        child: Row(
                          children: [
                            SizedBox(
                              height: ph(18),
                              width: pw(18),
                              child: Checkbox(
                                value: _amenities[key],
                                activeColor: primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                side: const BorderSide(color: Colors.black45, width: 1.2),
                                onChanged: (val) => setState(() => _amenities[key] = val!),
                              ),
                            ),
                            SizedBox(width: pw(12)),
                            Text(
                              key,
                              style: TextStyle(
                                fontSize: pw(12),
                                color: Colors.black87,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    SizedBox(height: ph(10)),

                    // BHK
                    _buildSectionTitle("BHK (for Apartments/Houses)", pw, ph, primaryColor),
                    _buildDropdown(
                      value: _selectedBhk,
                      items: ["Any BHK", "1 BHK", "2 BHK", "3 BHK", "4+ BHK"],
                      onChanged: (val) => setState(() => _selectedBhk = val!),
                      pw: pw,
                      ph: ph,
                    ),

                    SizedBox(height: ph(30)),
                  ],
                ),
              ),
            ),

            // Footer Buttons
            Padding(
              padding: EdgeInsets.all(pw(16)),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedPropertyType = "All Types";
                          _selectedLocation = "All Location";
                          _selectedBhk = "Any BHK";
                          _amenities.updateAll((key, value) => false);
                          _minPriceController.clear();
                          _maxPriceController.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(vertical: ph(10)),
                      ),
                      child: Text("Clear All", style: TextStyle(color: primaryColor, fontSize: pw(13), fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(width: pw(12)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply filters logic
                        final filters = {
                          'propertyType': _selectedPropertyType,
                          'minPrice': _minPriceController.text,
                          'maxPrice': _maxPriceController.text,
                          'location': _selectedLocation,
                          'amenities': _amenities.entries.where((e) => e.value).map((e) => e.key).toList(),
                          'bhk': _selectedBhk,
                        };
                        Navigator.pop(context, filters);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(vertical: ph(10)),
                      ),
                      child: Text("Apply Filter", style: TextStyle(color: Colors.white, fontSize: pw(13), fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double Function(double) pw, double Function(double) ph, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: ph(8)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: pw(12),
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'Lato',
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required double Function(double) pw,
    required double Function(double) ph,
  }) {
    return Container(
      height: ph(36),
      padding: EdgeInsets.symmetric(horizontal: pw(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          style: TextStyle(fontSize: pw(12), color: Colors.black87),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: pw(12))))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required double Function(double) pw,
    required double Function(double) ph,
  }) {
    return Container(
      height: ph(36),
      padding: EdgeInsets.only(left: pw(8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: pw(12), color: Colors.grey),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(fontSize: pw(12)),
      ),
    );
  }
}