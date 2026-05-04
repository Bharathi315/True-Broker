import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String location;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _locationController = TextEditingController(text: widget.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Return updated data back to profile screen
    Navigator.pop(context, {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'location': _locationController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── APP BAR ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
                  ),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lato',
                      color: Colors.black,
                    ),
                  ),
                  // ✅ tick icon to save
                  GestureDetector(
                    onTap: _saveProfile,
                    child: const Icon(Icons.check, color: Colors.black, size: 22),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFD1D1D1), thickness: 1, height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Avatar ──
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF742B88),
                                width: 2,
                              ),
                              color: const Color(0xFFD9D9D9),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF742B88),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Name ──
                    _fieldLabel('Name :'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _nameController,
                      hintText: 'Enter your name',
                    ),

                    const SizedBox(height: 16),

                    // ── Email ──
                    _fieldLabel('Email ID :'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    // ── Phone ──
                    _fieldLabel('Phone No :'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _phoneController,
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 16),

                    // ── Location ──
                    _fieldLabel('Location :'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _locationController,
                      hintText: 'Enter your location',
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
        fontFamily: 'Lato',
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
          fontFamily: 'Lato',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey[400],
            fontFamily: 'Lato',
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}