import 'package:flutter/material.dart';
import 'package:truebroker/sell_rent/step2_home.dart';
import 'package:truebroker/sell_rent/step2_plot.dart';


class AddBasicSell extends StatefulWidget {
  const AddBasicSell({super.key});

  @override
  State<AddBasicSell> createState() => _AddBasicSellState();
}

class _AddBasicSellState extends State<AddBasicSell> {
  bool showAllProperties = false;

  String selectedPurpose = "";
  String selectedPropertyType = "";
  String selectedPropertyOption = "";

  List<String> purposes = ["Sell", "Rent/Lease", "Paying Guest"];
  List<String> propertyTypes = ["Residential", "Commercial"];
  List<String> propertyOptions = [
    "Apartment",
    "Independent House/Villa",
    "Plot / Land",
    "1 RK/Studio Apartment",
    "Farm House",
    "Serviced Apartment",
    "Others",
  ];
  bool get _isNextEnabled =>
      selectedPurpose.isNotEmpty &&
          selectedPropertyType.isNotEmpty &&
          selectedPropertyOption.isNotEmpty;
  void _onNextTap() {
    if (!_isNextEnabled) return;

    if (selectedPropertyOption == "Plot / Land") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Step2Plot()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) =>Step2Home()),
      );
    }
  }
  Widget buildChip(
      String text,
      String selectedValue,
      Function(String) onTap,
      double width,
      ) {
    bool isSelected = text == selectedValue;

    return GestureDetector(
      onTap: () => onTap(text),
      child: Container(
        margin: EdgeInsets.only(right: width * 0.03, bottom: width * 0.03),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.024,
          vertical: width * 0.007,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF742B88) : Colors.white,
          borderRadius: BorderRadius.circular(width * 0.05),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: width * 0.035,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
  Widget buildPropertyChip(String text, double width) {
    final bool isSelected = text == selectedPropertyOption;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPropertyOption = isSelected ? "" : text;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: width * 0.03, bottom: width * 0.03),
        padding: EdgeInsets.only(
          left: width * 0.024,
          right: isSelected ? width * 0.01 : width * 0.024,
          top: width * 0.007,
          bottom: width * 0.007,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF742B88) : Colors.white,
          borderRadius: BorderRadius.circular(width * 0.05),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: width * 0.035,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: width * 0.01),
              GestureDetector(
                onTap: () {
                  setState(() => selectedPropertyOption = "");
                },
                child: Container(
                  width: width * 0.04,
                  height: width * 0.04,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.close,
                    size: width * 0.035,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final visibleOptions = showAllProperties
        ? propertyOptions
        : propertyOptions.take(4).toList();
    final hiddenCount = propertyOptions.length - 4;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.015,
              ),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, size: width * 0.06),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Basic Details",
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Step 1 Of 3",
                    style: TextStyle(
                      fontSize: width * 0.035,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.001),
                    Text(
                      "You're Looking To ?",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Wrap(
                      children: purposes.map((e) {
                        return buildChip(e, selectedPurpose, (val) {
                          setState(() => selectedPurpose = val);
                        }, width);
                      }).toList(),
                    ),

                    SizedBox(height: height * 0.015),
                    Text(
                      "What Kind Of Property?",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Wrap(
                      children: propertyTypes.map((e) {
                        return buildChip(e, selectedPropertyType, (val) {
                          setState(() => selectedPropertyType = val);
                        }, width);
                      }).toList(),
                    ),
                    SizedBox(height: height * 0.015),
                    Text(
                      "Select Property Type",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Wrap(
                      children: [
                        ...visibleOptions.map(
                              (e) => buildPropertyChip(e, width),
                        ),
                        if (!showAllProperties && hiddenCount > 0)
                          GestureDetector(
                            onTap: () =>
                                setState(() => showAllProperties = true),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: width * 0.03,
                                bottom: width * 0.03,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.024,
                                vertical: width * 0.007,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius:
                                BorderRadius.circular(width * 0.05),
                                border: Border.all(
                                    color: const Color(0xFFFFFFFF)),
                              ),
                              child: Text(
                                '+ $hiddenCount more',
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  color: const Color(0XFF1C2293),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: height * 0.26),
                    SizedBox(
                      width: 328,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _isNextEnabled ? _onNextTap : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isNextEnabled
                              ? const Color(0xFF742B88)
                              :Color(0xFF742B88),
                          disabledBackgroundColor: Color(0xFF742B88),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 0,
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _isNextEnabled
                                ? Colors.white
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}