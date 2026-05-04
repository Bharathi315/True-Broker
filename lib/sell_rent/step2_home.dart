import 'package:flutter/material.dart';
import 'step3_home.dart';
import 'add_basic_sell.dart';

class Step2Home extends StatefulWidget {
  const Step2Home({super.key});

  @override
  State<Step2Home> createState() => _Step2HomeState();
}

class _Step2HomeState extends State<Step2Home> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _cityController = TextEditingController();
  final _carpetAreaController = TextEditingController();
  final _totalFloorsController = TextEditingController();
  final _propertyOnFloorController = TextEditingController();
  final _priceController = TextEditingController();

  // Selections
  String? _selectedBedroom;
  String? _selectedBathroom;
  String? _selectedBalcony;
  String? _availabilityStatus;
  String? _ownership;

  // Error flags
  bool _showCityError = false;
  bool _showBedroomError = false;
  bool _showBathroomError = false;
  bool _showBalconyError = false;
  bool _showCarpetAreaError = false;
  bool _showTotalFloorsError = false;
  bool _showPropertyOnFloorError = false;
  bool _showAvailabilityError = false;
  bool _showOwnershipError = false;
  bool _showPriceError = false;

  final List<String> _countOptions = ['1', '2', '3', '4', '5+'];
  final List<String> _availabilityOptions = ['Ready to move', 'Under Construction'];
  final List<String> _ownershipOptions = [
    'Freehold',
    'Leasehold',
    'Co-operative society',
    'Power of Attorney',
  ];

  @override
  void dispose() {
    _cityController.dispose();
    _carpetAreaController.dispose();
    _totalFloorsController.dispose();
    _propertyOnFloorController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  bool _validateAll() {
    setState(() {
      _showCityError = _cityController.text.trim().isEmpty;
      _showBedroomError = _selectedBedroom == null;
      _showBathroomError = _selectedBathroom == null;
      _showBalconyError = _selectedBalcony == null;
      _showCarpetAreaError = _carpetAreaController.text.trim().isEmpty;
      _showTotalFloorsError = _totalFloorsController.text.trim().isEmpty;
      _showPropertyOnFloorError = _propertyOnFloorController.text.trim().isEmpty;
      _showAvailabilityError = _availabilityStatus == null;
      _showOwnershipError = _ownership == null;
      _showPriceError = _priceController.text.trim().isEmpty;
    });

    return !_showCityError &&
        !_showBedroomError &&
        !_showBathroomError &&
        !_showBalconyError &&
        !_showCarpetAreaError &&
        !_showTotalFloorsError &&
        !_showPropertyOnFloorError &&
        !_showAvailabilityError &&
        !_showOwnershipError &&
        !_showPriceError;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back Button ──
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),
            SizedBox(height: h * 0.03),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Header Row ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Property Details',
                            style: TextStyle(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Step 2 Of 3',
                            style: TextStyle(
                              fontSize: w * 0.035,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.025),

                      // ── Where is your property located? ──
                      _sectionLabel('Where is your property located ?', w),
                      SizedBox(height: h * 0.01),
                      _buildTextField(
                        controller: _cityController,
                        hint: 'City',
                        w: w,
                        hintColor: Colors.black,
                        showError: _showCityError,
                        errorText: 'Please enter city',
                        onChanged: (_) {
                          if (_showCityError) setState(() => _showCityError = false);
                        },
                      ),
                      SizedBox(height: h * 0.008),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Icon(Icons.my_location,
                                size: w * 0.04,
                                color: const Color(0xFF110F77)),
                            SizedBox(width: w * 0.02),
                            Text(
                              'Detect My Location',
                              style: TextStyle(
                                fontSize: w * 0.035,
                                color: const Color(0xFF110F77),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.025),

                      // ── Add Room Details ──
                      _sectionLabel('Add Room Details', w),
                      SizedBox(height: h * 0.018),

                      // ── No. Of Bedrooms ──
                      _sectionLabel('No. Of Bedrooms', w),
                      SizedBox(height: h * 0.01),
                      _buildCircleSelector(
                        selected: _selectedBedroom,
                        showError: _showBedroomError,
                        onTap: (v) => setState(() {
                          _selectedBedroom = v;
                          _showBedroomError = false;
                        }),
                        w: w,
                      ),
                      if (_showBedroomError)
                        _errorText('Please select no. of bedrooms'),
                      SizedBox(height: h * 0.022),

                      // ── No. Of Bathrooms ──
                      _sectionLabel('No. Of Bathrooms', w),
                      SizedBox(height: h * 0.01),
                      _buildCircleSelector(
                        selected: _selectedBathroom,
                        showError: _showBathroomError,
                        onTap: (v) => setState(() {
                          _selectedBathroom = v;
                          _showBathroomError = false;
                        }),
                        w: w,
                      ),
                      if (_showBathroomError)
                        _errorText('Please select no. of bathrooms'),
                      SizedBox(height: h * 0.022),

                      // ── Balconies ──
                      _sectionLabel('Balconies', w),
                      SizedBox(height: h * 0.01),
                      _buildCircleSelector(
                        selected: _selectedBalcony,
                        showError: _showBalconyError,
                        onTap: (v) => setState(() {
                          _selectedBalcony = v;
                          _showBalconyError = false;
                        }),
                        w: w,
                      ),
                      if (_showBalconyError)
                        _errorText('Please select no. of balconies'),
                      SizedBox(height: h * 0.025),

                      // ── Add Area Details ──
                      _sectionLabel('Add Area Details', w),
                      SizedBox(height: h * 0.01),
                      _buildTextFieldWithSuffix(
                        controller: _carpetAreaController,
                        hint: 'Carpet Area',
                        suffix: 'Sq.ft.',
                        w: w,
                        showError: _showCarpetAreaError,
                        errorText: 'Please enter carpet area',
                        onChanged: (_) {
                          if (_showCarpetAreaError) {
                            setState(() => _showCarpetAreaError = false);
                          }
                        },
                      ),
                      SizedBox(height: h * 0.025),

                      // ── Floor Details ──
                      _sectionLabel('Floor Details', w),
                      SizedBox(height: h * 0.005),
                      Text(
                        'Total no of floors and floor details',
                        style: TextStyle(
                          fontSize: w * 0.032,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      _buildTextField(
                        controller: _totalFloorsController,
                        hint: 'Total Floors',
                        w: w,
                        keyboardType: TextInputType.number,
                        hintColor: Colors.black,
                        showError: _showTotalFloorsError,
                        errorText: 'Please enter total floors',
                        onChanged: (_) {
                          if (_showTotalFloorsError) {
                            setState(() => _showTotalFloorsError = false);
                          }
                        },
                      ),
                      SizedBox(height: h * 0.01),
                      _buildTextField(
                        controller: _propertyOnFloorController,
                        hint: 'Property on floor',
                        w: w,
                        keyboardType: TextInputType.number,
                        hintColor: Colors.black,
                        showError: _showPropertyOnFloorError,
                        errorText: 'Please enter property on floor',
                        onChanged: (_) {
                          if (_showPropertyOnFloorError) {
                            setState(() => _showPropertyOnFloorError = false);
                          }
                        },
                      ),
                      SizedBox(height: h * 0.025),

                      // ── Availability Status ──
                      _sectionLabel('Availability Status', w),
                      SizedBox(height: h * 0.01),
                      Wrap(
                        spacing: w * 0.03,
                        runSpacing: 8,
                        children: _availabilityOptions.map((opt) {
                          final bool sel = _availabilityStatus == opt;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _availabilityStatus = opt;
                              _showAvailabilityError = false;
                            }),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.04,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: sel
                                    ? const Color(0xFF742B88)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _showAvailabilityError
                                      ? Colors.red
                                      : sel
                                      ? const Color(0xFF742B88)
                                      : Colors.grey.shade400,
                                ),
                              ),
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontSize: w * 0.033,
                                  // ── Grey when not selected ──
                                  color: sel ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (_showAvailabilityError)
                        _errorText('Please select availability status'),
                      SizedBox(height: h * 0.025),

                      // ── Ownership ──
                      _sectionLabel('Ownership', w),
                      SizedBox(height: h * 0.01),
                      Wrap(
                        spacing: w * 0.03,
                        runSpacing: 8,
                        children: _ownershipOptions.map((opt) {
                          final bool sel = _ownership == opt;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _ownership = opt;
                              _showOwnershipError = false;
                            }),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.035,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: sel
                                    ? const Color(0xFF742B88)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _showOwnershipError
                                      ? Colors.red
                                      : sel
                                      ? const Color(0xFF742B88)
                                      : Colors.grey.shade400,
                                ),
                              ),
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontSize: w * 0.033,
                                  // ── Grey when not selected ──
                                  color: sel ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (_showOwnershipError)
                        _errorText('Please select ownership type'),
                      SizedBox(height: h * 0.025),

                      // ── Price Details ──
                      _sectionLabel('Price Details', w),
                      SizedBox(height: h * 0.01),
                      SizedBox(
                        width: 328,
                        height: 40,
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            if (_showPriceError) {
                              setState(() => _showPriceError = false);
                            }
                          },
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: '₹ Expected Price',
                            // ── Blue hint text ──
                            hintStyle: const TextStyle(
                              color: Color(0XFF110F77),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                  color: _showPriceError
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                  color: Color(0xFF742B88), width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      if (_showPriceError)
                        _errorText('Please enter expected price'),

                      SizedBox(height: h * 0.16),
                      _buildNextButton(w, h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  HELPER WIDGETS
  // ─────────────────────────────────────────────

  Widget _errorText(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Text(
        msg,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, double w) {
    return Text(
      text,
      style: TextStyle(
        fontSize: w * 0.038,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCircleSelector({
    required String? selected,
    required bool showError,
    required ValueChanged<String> onTap,
    required double w,
  }) {
    return Row(
      children: _countOptions.map((opt) {
        final bool sel = selected == opt;
        return GestureDetector(
          onTap: () => onTap(opt),
          child: Container(
            margin: EdgeInsets.only(right: w * 0.025),
            width: w * 0.11,
            height: w * 0.11,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: sel ? const Color(0xFF742B88) : Colors.white,
              border: Border.all(
                color: showError
                    ? Colors.red
                    : sel
                    ? const Color(0xFF742B88)
                    : Colors.grey.shade400,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              opt,
              style: TextStyle(
                fontSize: w * 0.033,
                color: sel ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required double w,
    TextInputType keyboardType = TextInputType.text,
    Color hintColor = const Color(0xFF757575),
    bool showError = false,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 328,
          height: 40,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide:
                BorderSide(color: showError ? Colors.red : Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                    color: Color(0xFF742B88), width: 1.5),
              ),
            ),
          ),
        ),
        if (showError && errorText != null) _errorText(errorText),
      ],
    );
  }

  Widget _buildTextFieldWithSuffix({
    required TextEditingController controller,
    required String hint,
    required String suffix,
    required double w,
    bool showError = false,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 328,
          height: 48,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                onChanged: onChanged,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding:
                  const EdgeInsets.fromLTRB(12, 10, 70, 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                        color: showError ? Colors.red : Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                        color: Color(0xFF742B88), width: 1.5),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                child: Text(
                  suffix,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showError && errorText != null) _errorText(errorText),
      ],
    );
  }

  Widget _buildNextButton(double w, double h) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          w * 0.04, h * 0.015, w * 0.04, h * 0.025),
      decoration: const BoxDecoration(color: Colors.white),
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            if (_validateAll()) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Step3Home()),
              );
            }
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
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}