import 'package:flutter/material.dart';
import 'package:truebroker/home/bottom_nav.dart';


class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final TextEditingController _nameController    = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController    = TextEditingController();
  final TextEditingController _stateController   = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  bool get _allFilled =>
      _nameController.text.trim().isNotEmpty &&
          _addressController.text.trim().isNotEmpty &&
          _cityController.text.trim().isNotEmpty &&
          _stateController.text.trim().isNotEmpty &&
          _pincodeController.text.trim().isNotEmpty;

  void _onNext() {
    if (!_allFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => FrontScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;

    double pw(double px) => sw * (px / 360);
    double ph(double px) => sh * (px / 800);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: sw,
              height: ph(56),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
            ),

            SizedBox(height: ph(10)),
            Container(
              width: pw(186),
              height: ph(5),
              decoration: BoxDecoration(
                color: const Color(0xFF7C348D),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: pw(26)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ph(25)),

                    Text(
                      "Complete your\nAddress...!",
                      style: TextStyle(
                        fontSize: pw(28),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1D2E),
                        height: 1.1,
                      ),
                    ),

                    SizedBox(height: ph(4)),

                    Text(
                      "Let's get to know you better!",
                      style: TextStyle(
                        fontSize: pw(14),
                        color: const Color(0xFF7D848D),
                      ),
                    ),

                    SizedBox(height: ph(24)),

                    _buildField(pw, ph,
                      label:      "Full Name",
                      hint:       "Eg: Sowmiya",
                      assetPath:  "assets/Profile.png",
                      controller: _nameController,
                    ),
                    SizedBox(height: ph(16)),

                    _buildField(pw, ph,
                      label:      "Address",
                      hint:       "Eg: 12A, Sunrise Apartments, MG Road",
                      assetPath:  "assets/Address.png",
                      controller: _addressController,
                      isMulti:    true,
                    ),
                    SizedBox(height: ph(16)),

                    _buildField(pw, ph,
                      label:      "City",
                      hint:       "Eg : Coimbatore",
                      assetPath:  "assets/City.png",
                      controller: _cityController,
                    ),
                    SizedBox(height: ph(16)),

                    _buildField(pw, ph,
                      label:      "State",
                      hint:       "Eg: Tamil Nadu",
                      assetPath:  "assets/Sate.png",
                      controller: _stateController,
                    ),
                    SizedBox(height: ph(16)),

                    _buildField(pw, ph,
                      label:        "PinCode",
                      hint:         "Eg: 641001",
                      assetPath:    "assets/Sate.png",
                      controller:   _pincodeController,
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: ph(30)),

                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _nameController,
                        _addressController,
                        _cityController,
                        _stateController,
                        _pincodeController,
                      ]),
                      builder: (context, _) {
                        final filled = _allFilled;
                        return GestureDetector(
                          onTap: _onNext,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            height: ph(56),
                            decoration: BoxDecoration(
                              color:Color(0XFF742B88),
                              borderRadius: BorderRadius.circular(pw(10)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color:Color(0xffFFFFFF),
                                fontSize: pw(18),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: ph(20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      double Function(double) pw,
      double Function(double) ph, {
        required String label,
        required String hint,
        required String assetPath,
        required TextEditingController controller,
        bool isMulti = false,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: pw(15),
            color: const Color(0xFF1A1D2E),
          ),
        ),
        SizedBox(height: ph(8)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F9),
            borderRadius: BorderRadius.circular(pw(25)),
            border: Border.all(color: Colors.white, width: 1),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: pw(12),
            vertical: isMulti ? ph(10) : ph(6),
          ),
          child: Row(
            crossAxisAlignment:
            isMulti ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Container(
                width: pw(28),
                height: pw(28),
                decoration: const BoxDecoration(
                  color: Color(0xFF7C348D),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  assetPath,
                  width: pw(18),
                  height: pw(18),
                  color: Colors.white,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.edit_location,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: pw(12)),
              Expanded(
                child: TextField(
                  controller:   controller,
                  maxLines:     isMulti ? 4 : 1,
                  keyboardType: keyboardType,
                  style: TextStyle(fontSize: pw(14), color: Colors.black87),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    isDense:  true,
                    border:   InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize:   pw(13),
                      color: const Color(0xFF7D848D).withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}