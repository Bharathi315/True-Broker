import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'step2_plot.dart';
import 'step4_plot.dart';

class Step3Plot extends StatefulWidget {
  const Step3Plot({super.key});

  @override
  State<Step3Plot> createState() => _Step3PlotState();
}

class _Step3PlotState extends State<Step3Plot> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? selectedVideo;
  List<File> selectedImages = [];

  bool _videoError = false;
  bool _imageError = false;
  bool _emailError = false;
  String _emailErrorText = '';

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        selectedVideo = File(video.path);
        _videoError = false;
      });
    }
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        selectedImages = images.map((e) => File(e.path)).toList();
        _imageError = false;
      });
    }
  }

  void _validateAndProceed() {
    bool hasError = false;

    // Video validation
    if (selectedVideo == null) {
      setState(() => _videoError = true);
      hasError = true;
    }

    // Image validation
    if (selectedImages.isEmpty) {
      setState(() => _imageError = true);
      hasError = true;
    }

    // Email validation
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailError = true;
        _emailErrorText = 'Email required';
      });
      hasError = true;
    } else {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        setState(() {
          _emailError = true;
          _emailErrorText = 'Enter valid email';
        });
        hasError = true;
      } else {
        setState(() {
          _emailError = false;
          _emailErrorText = '';
        });
      }
    }

    if (hasError) {
    } else {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>Step4Plot()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.01),
              child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
            ),
            Divider(height: screenHeight * 0.01),
            SizedBox(height: screenHeight * 0.01),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add Media & Pricing",
                            style: TextStyle(
                              fontSize: screenWidth * 0.043,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Step 3 of 3",
                            style: TextStyle(
                              fontSize: screenWidth * 0.032,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "Add one Property Video",
                        style: TextStyle(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Properties with videos get higher page views",
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color: const Color(0xff838080),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      GestureDetector(
                        onTap: pickVideo,
                        child: Container(
                          width: double.infinity,
                          height: 141,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _videoError
                                  ? Colors.red
                                  : Colors.grey,
                              width: _videoError ? 1.5 : 1.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.007),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.file_upload_outlined,
                                          size: screenWidth * 0.04,
                                          color: Colors.black),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Upload Video",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenWidth * 0.037,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Divider(
                                  height: 2,
                                  thickness: 0.9,
                                  color: const Color(0xff7C348D),
                                ),

                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: selectedVideo == null
                                        ? Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/add_sell/video.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Upload Video",
                                          style: TextStyle(
                                            color:
                                            const Color(0xff711886),
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.037,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Max size 200mb in formats mp4, avi, webm",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.027,
                                            fontWeight: FontWeight.w400,
                                            color:
                                            const Color(0xff787878),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "mov, wmv, h264",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.028,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                        : const Center(
                                      child: Text(
                                        "Video Selected ✅",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_videoError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(
                            'Please upload a video',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                        ),

                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        "Add Property Photos",
                        style: TextStyle(
                            fontSize: screenWidth * 0.037,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: pickImages,
                        child: Container(
                          width: double.infinity,
                          height: 141,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _imageError ? Colors.red : Colors.grey,
                              width: _imageError ? 1.5 : 1.0,
                            ),
                          ),
                          child: selectedImages.isEmpty
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/add_sell/photo.png',
                                width: 48,
                                height: 48,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "+",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.07,
                                      color: const Color(0xff711886),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Add atleast 5 Photos",
                                    style: TextStyle(
                                      color: const Color(0xff711886),
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenWidth * 0.037,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Click from camera or browse to upload",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.032,
                                  color: const Color(0xff777272),
                                ),
                              ),
                            ],
                          )
                              : Center(
                            child: Text(
                              "${selectedImages.length} Images Selected ✅",
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),

                      // Image error message below container
                      if (_imageError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(
                            'Please upload at least 5 photos',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                        ),

                      SizedBox(height: screenHeight * 0.025),

                      // Email Section
                      Text(
                        "Add Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.037),
                      ),
                      const SizedBox(height: 8),

                      // Email TextField — fixed height, no position shift
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            // Live clear error when user types valid email
                            if (_emailError) {
                              final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (emailRegex.hasMatch(value.trim())) {
                                setState(() {
                                  _emailError = false;
                                  _emailErrorText = '';
                                });
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: _emailError ? Colors.red : Colors.grey,
                                width: _emailError ? 1.5 : 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: _emailError ? Colors.red : Colors.grey,
                                width: _emailError ? 1.5 : 1.0,
                              ),
                            ),
                            // No error display inside TextField at all
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Email error message — fixed below, no layout shift
                      SizedBox(
                        height: 18,
                        child: _emailError
                            ? Padding(
                          padding:
                          const EdgeInsets.only(top: 3, left: 4),
                          child: Text(
                            _emailErrorText,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      // Next Button
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _validateAndProceed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF742B88),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),
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
}