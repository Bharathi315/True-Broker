import 'package:flutter/material.dart';
import 'add_basic_sell.dart';
import 'step3_plot.dart';

class Step2Plot extends StatefulWidget {
  const Step2Plot({super.key});

  @override
  State<Step2Plot> createState() => _Step2PlotState();
}

class _Step2PlotState extends State<Step2Plot> {
  final _formKey = GlobalKey<FormState>();

  final _cityController = TextEditingController();
  final _plotAreaController = TextEditingController();
  final _lengthController = TextEditingController();
  final _breadthController = TextEditingController();
  final _floorsController = TextEditingController();

  String? _boundaryWall;
  String? _openSides;
  String? _constructionDone;
  String? _possessionBy;
  String? _selectMonth;
  bool _showCityError = false;
  bool _showPlotAreaError = false;
  bool _showFloorsError = false;
  bool _showBoundaryWallError = false;
  bool _showOpenSidesError = false;
  bool _showConstructionError = false;
  bool _showPossessionByError = false;
  bool _showSelectMonthError = false;

  final List<String> _yesNo = ['Yes', 'No'];
  final List<String> _openSideOptions = ['1', '2', '3', '4', '+5'];

  @override
  void dispose() {
    _cityController.dispose();
    _plotAreaController.dispose();
    _lengthController.dispose();
    _breadthController.dispose();
    _floorsController.dispose();
    super.dispose();
  }
  bool _validateAll() {
    setState(() {
      _showCityError = _cityController.text.trim().isEmpty;
      _showPlotAreaError = _plotAreaController.text.trim().isEmpty;
      _showFloorsError = _floorsController.text.trim().isEmpty;
      _showBoundaryWallError = _boundaryWall == null;
      _showOpenSidesError = _openSides == null;
      _showConstructionError = _constructionDone == null;
      _showPossessionByError = _possessionBy == null;
      _showSelectMonthError = _selectMonth == null;
    });
    return !_showCityError &&
        !_showPlotAreaError &&
        !_showFloorsError &&
        !_showBoundaryWallError &&
        !_showOpenSidesError &&
        !_showConstructionError &&
        !_showPossessionByError &&
        !_showSelectMonthError;
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
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 1),
            SizedBox(height: h*0.03,),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Property Details',
                            style: TextStyle(
                              fontSize: w * 0.039,
                              fontWeight: FontWeight.w600,),
                          ),
                          Text(
                            'Step 2 Of 3',
                            style: TextStyle(
                              fontSize: w * 0.033,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.02),

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
                            Icon(Icons.my_location, size: w * 0.04, color: const Color(0xFF742B88)),
                            SizedBox(width: w * 0.02),
                            Text(
                              'Detect My Location',
                              style: TextStyle(
                                fontSize: w * 0.035,
                                color: const Color(0xFF742B88),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      _sectionLabel('Add Area Details', w),
                      SizedBox(height: h * 0.01),
                      _buildTextFieldWithSuffix(
                        controller: _plotAreaController,
                        hint: 'Plot Area',
                        suffix: 'sq.ft.',
                        w: w,
                        showError: _showPlotAreaError,
                        errorText: 'Please enter plot area',
                        onChanged: (_) {
                          if (_showPlotAreaError) setState(() => _showPlotAreaError = false);
                        },
                      ),
                      SizedBox(height: h * 0.02),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Property Dimensions ',
                              style: TextStyle(
                                fontSize: w * 0.038,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: '(Optional)',
                              style: TextStyle(
                                color: Color(0xFF757575),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      _buildTextField(
                        controller: _lengthController,
                        hint: 'Length of plot (in ft.)',
                        w: w,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: h * 0.01),
                      _buildTextField(
                        controller: _breadthController,
                        hint: 'Breadth of plot (in ft.)',
                        w: w,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: h * 0.02),
                      _sectionLabel('Floors Allowed For Construction', w),
                      SizedBox(height: h * 0.01),
                      _buildTextField(
                        controller: _floorsController,
                        hint: 'No. of floors',
                        w: w,
                        keyboardType: TextInputType.number,
                        hintColor: Colors.black,
                        showError: _showFloorsError,
                        errorText: 'Please enter no. of floors',
                        onChanged: (_) {
                          if (_showFloorsError) setState(() => _showFloorsError = false);
                        },
                      ),
                      SizedBox(height: h * 0.02),
                      _sectionLabel('Is there a boundary wall around the property?', w),
                      SizedBox(height: h * 0.01),
                      _buildYesNoGroup(
                        selected: _boundaryWall,
                        onTap: (v) => setState(() {
                          _boundaryWall = v;
                          _showBoundaryWallError = false;
                        }),
                        w: w,
                      ),
                      if (_showBoundaryWallError) _errorText('Please select an option'),
                      SizedBox(height: h * 0.02),
                      _sectionLabel('No. Of open sides', w),
                      SizedBox(height: h * 0.01),
                      Wrap(
                        spacing: w * 0.03,
                        runSpacing: h * 0.01,
                        children: _openSideOptions.map((opt) {
                          final bool sel = _openSides == opt;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _openSides = opt;
                              _showOpenSidesError = false;
                            }),
                            child: Container(
                              width: w * 0.1,
                              height: w * 0.1,
                              decoration: BoxDecoration(
                                color: sel ? const Color(0xFF742B88) : Colors.white,
                                borderRadius: BorderRadius.circular(w * 0.02),
                                border: Border.all(
                                  color: _showOpenSidesError ? Colors.red : Colors.grey,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  color: sel ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (_showOpenSidesError) _errorText('Please select no. of open sides'),
                      SizedBox(height: h * 0.02),
                      _sectionLabel('Any construction done on this property', w),
                      SizedBox(height: h * 0.01),
                      _buildYesNoGroup(
                        selected: _constructionDone,
                        onTap: (v) => setState(() {
                          _constructionDone = v;
                          _showConstructionError = false;
                        }),
                        w: w,
                      ),
                      if (_showConstructionError) _errorText('Please select an option'),
                      SizedBox(height: h * 0.02),
                      _sectionLabel('Possession By', w),
                      SizedBox(height: h * 0.01),
                      _buildDropdown(
                        value: _possessionBy,
                        hint: 'Expected By',
                        items: [
                          'Immediate', 'Within 3 months', 'Within 6 months',
                          'BY 2026', 'by 2027', 'by 2028', 'by 2029', 'bY 2030',
                        ],
                        onChanged: (v) => setState(() {
                          _possessionBy = v;
                          _showPossessionByError = false;
                        }),
                        w: w,
                        showError: _showPossessionByError,
                      ),
                      if (_showPossessionByError) _errorText('Please select possession year'),
                      SizedBox(height: h * 0.01),
                      _buildDropdown(
                        value: _selectMonth,
                        hint: 'Select Month',
                        items: [
                          'January', 'February', 'March', 'April', 'May', 'June',
                          'July', 'August', 'September', 'October', 'November', 'December',
                        ],
                        onChanged: (v) => setState(() {
                          _selectMonth = v;
                          _showSelectMonthError = false;
                        }),
                        w: w,
                        showError: _showSelectMonthError,
                      ),
                      if (_showSelectMonthError) _errorText('Please select month'),
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
        fontSize: w * 0.039,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
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
            style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: hintColor, fontSize: 14, fontWeight: FontWeight.w400),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: showError ? Colors.red : Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF742B88), width: 1.5),
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
                  contentPadding: const EdgeInsets.fromLTRB(12, 10, 70, 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: showError ? Colors.red : Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFF742B88), width: 1.5),
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
  Widget _buildYesNoGroup({
    required String? selected,
    required ValueChanged<String> onTap,
    required double w,
  }) {
    return Row(
      children: _yesNo.map((opt) {
        final bool sel = selected == opt;
        return GestureDetector(
          onTap: () => onTap(opt),
          child: Container(
            margin: EdgeInsets.only(right: w * 0.03),
            width: 40,
            height: 22,
            decoration: BoxDecoration(
              color: sel ? const Color(0xFF742B88) : Colors.white,
              borderRadius: BorderRadius.circular(w * 0.05),
              border: Border.all(color: Colors.grey),
            ),
            alignment: Alignment.center,
            child: Text(
              opt,
              style: TextStyle(
                fontSize: w * 0.030,
                color: sel ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required double w,
    bool showError = false,
  }) {
    return GestureDetector(
      onTap: () => _showBottomSheetPicker(
        hint: hint,
        items: items,
        selected: value,
        onSelected: onChanged,
      ),
      child: Container(
        width: 328,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: showError ? Colors.red : Colors.grey, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? hint,
              style: TextStyle(fontSize: w * 0.035, color: Colors.black),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }
  void _showBottomSheetPicker({
    required String hint,
    required List<String> items,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(hint,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
              ),
            ),
            const Divider(height: 1),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ScrollConfiguration(
                  behavior: _NoGlowBehavior(),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final bool isSelected = item == selected;
                      return InkWell(
                        onTap: () {
                          onSelected(item);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          color: isSelected ? const Color(0xFF742B88).withOpacity(0.08) : Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? const Color(0xFF742B88) : Colors.black87,
                                ),
                              ),
                              if (isSelected) const Icon(Icons.check, size: 18, color: Color(0xFF742B88)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
          ],
        );
      },
    );
  }
  Widget _buildNextButton(double w, double h) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.015, w * 0.04, h * 0.025),
      decoration: const BoxDecoration(color: Colors.white),
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            if (_validateAll()) {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => Step3Plot(),
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF742B88),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text(
            'Next',
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
class _NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}