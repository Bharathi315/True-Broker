import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truebroker/shorts/shorts.dart';

// ════════════════════════════════════════════════════════════════════════════
//  INLINE ERROR TEXT FIELD
//  Error message shown INSIDE the container (right side), no layout shift
// ════════════════════════════════════════════════════════════════════════════
class _InlineErrorField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? prefix;
  final String? suffix;
  final IconData? prefixIcon;
  final Color borderGrey;

  const _InlineErrorField({
    required this.controller,
    required this.hint,
    required this.borderGrey,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.prefix,
    this.suffix,
    this.prefixIcon,
  });

  @override
  State<_InlineErrorField> createState() => _InlineErrorFieldState();
}

class _InlineErrorFieldState extends State<_InlineErrorField> {
  String? _error;

  // Called by the Form's validate()
  String? _validate(String? v) {
    final result = widget.validator?.call(v);
    // Schedule after build to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _error = result);
    });
    return result; // still return for Form to track validity
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _error != null && _error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? Colors.red : widget.borderGrey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
      controller: widget.controller,
      validator: widget.validator != null ? _validate : null,

      textAlignVertical: TextAlignVertical.center,

      style: const TextStyle(
        fontSize: 13,
        color: Colors.black87,
      ),

      decoration: const InputDecoration(
        border: InputBorder.none,

        isDense: true,

        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),

        hintText: '',
        errorStyle: TextStyle(fontSize: 0),
      ),
    ),
        ),

        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  ADD POST SCREEN
// ════════════════════════════════════════════════════════════════════════════
class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  static const Color _purple     = Color(0xFF7C348D);
  static const Color _borderGrey = Color(0xFF7D7D7D);

  bool   _videoSelected = false;
  String _listingType   = '';

  final _titleCtrl    = TextEditingController();
  final _priceCtrl    = TextEditingController();
  final _areaCtrl     = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl     = TextEditingController();

  String _propertyType = '';
  String _bhkConfig    = '';

  bool _showVideoError   = false;
  bool _showListingError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _areaCtrl.dispose();
    _locationCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  int get _stepDone {
    final uploadDone = _videoSelected && _listingType.isNotEmpty;
    final detailDone = uploadDone &&
        _titleCtrl.text.isNotEmpty &&
        _priceCtrl.text.isNotEmpty &&
        _propertyType.isNotEmpty &&
        _bhkConfig.isNotEmpty &&
        _locationCtrl.text.isNotEmpty;
    if (detailDone) return 2;
    if (uploadDone) return 1;
    return 0;
  }

  void _showPicker({
    required String title,
    required List<String> items,
    required String selected,
    required ValueChanged<String> onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            const Divider(height: 1),
            ...items.map((item) {
              final isSel = item == selected;
              return ListTile(
                title: Text(item,
                    style: TextStyle(
                        fontSize: 14,
                        color: isSel ? _purple : Colors.black87,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal)),
                trailing: isSel ? const Icon(Icons.check, color: _purple, size: 18) : null,
                onTap: () { onSelect(item); Navigator.pop(context); },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }


  void _handlePublish() {
    bool uploadOk = true;

    if (!_videoSelected) {
      setState(() => _showVideoError = true);
      uploadOk = false;
    }
    if (_listingType.isEmpty) {
      setState(() => _showListingError = true);
      uploadOk = false;
    }

    if (_propertyType.isEmpty || _bhkConfig.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select Property Type and BHK Configuration'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final formOk = _formKey.currentState!.validate();
    if (!uploadOk || !formOk) return;


    Navigator.push(context, MaterialPageRoute(builder: (context)=>ShortsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Add Post',
          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: _buildFormPage(),
    );
  }

  Widget _buildFormPage() {
    return Column(
      children: [
        _buildStepper(),
        const Divider(height: 1),
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _buildVideoUpload()),
                  const SizedBox(height: 20),

                  _label('Listing Type'),
                  const SizedBox(height: 8),
                  _buildListingType(),
                  const SizedBox(height: 16),

                  _label('Property Title'),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _titleCtrl,
                    hint: 'Enter property title',
                    validator: (v) => (v == null || v.isEmpty) ? 'Title required' : null,
                  ),
                  const SizedBox(height: 16),

                  _label('Price / Rent Amount'),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _priceCtrl,
                    hint: 'Enter amount',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => (v == null || v.isEmpty) ? 'Price required' : null,
                    prefix: '₹  ',
                  ),
                  const SizedBox(height: 16),

                  _label('Property Type'),
                  const SizedBox(height: 8),
                  _dropdownBox(
                    value: _propertyType,
                    hint: 'Select property type',
                    onTap: () => _showPicker(
                      title: 'Property Type',
                      items: ['Apartment / Flat', 'Villa', 'Plot', 'Commercial', 'Independent House', 'Penthouse'],
                      selected: _propertyType,
                      onSelect: (v) => setState(() => _propertyType = v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _label('BHK Configuration'),
                  const SizedBox(height: 8),
                  _dropdownBox(
                    value: _bhkConfig,
                    hint: 'Select BHK configuration',
                    onTap: () => _showPicker(
                      title: 'BHK Configuration',
                      items: ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '4+ BHK', 'Studio', 'Independent'],
                      selected: _bhkConfig,
                      onSelect: (v) => setState(() => _bhkConfig = v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _label('Area (sq.ft)'),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _areaCtrl,
                    hint: 'Enter area',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    suffix: 'sq.ft',
                  ),
                  const SizedBox(height: 16),

                  _label('Location'),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _locationCtrl,
                    hint: 'Anna Nagar, Chennai',
                    prefixIcon: Icons.location_on_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Location required' : null,
                  ),
                  const SizedBox(height: 16),

                  _label('Short Description'),
                  const SizedBox(height: 8),
                  _descriptionBox(),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handlePublish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        shadowColor: const Color(0x40000000),
                      ),
                      child: const Text(
                        'Publish Short',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepper() {
    final steps = ['Upload', 'Details', 'Publish'];
    final done = _stepDone;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final lineIdx = i ~/ 2;
            return Expanded(
              child: Container(height: 2, color: done > lineIdx ? _purple : Colors.grey.shade200),
            );
          }
          final sIdx   = i ~/ 2;
          final isDone = done > sIdx;
          final isCur  = done == sIdx;
          return Column(
            children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone || isCur ? _purple : Colors.grey.shade200,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text('${sIdx + 1}',
                      style: TextStyle(
                        color: isCur ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600, fontSize: 13,
                      )),
                ),
              ),
              const SizedBox(height: 4),
              Text(steps[sIdx],
                  style: TextStyle(
                    fontSize: 11,
                    color: isDone || isCur ? _purple : Colors.grey,
                    fontWeight: isDone || isCur ? FontWeight.w600 : FontWeight.normal,
                  )),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildVideoUpload() {
    final borderColor = _videoSelected
        ? _purple
        : (_showVideoError ? Colors.red : _borderGrey);

    return GestureDetector(
      onTap: () => setState(() { _videoSelected = true; _showVideoError = false; }),
      child: Container(
        width: 280,
        height: 127,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(color: borderColor),
          child: _videoSelected
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam, color: _purple, size: 38),
              const SizedBox(height: 6),
              Text('Video Selected ✓',
                  style: TextStyle(color: _purple, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image,
                  color: _showVideoError ? Colors.red.shade300 : Colors.grey.shade400,
                  size: 32),
              const SizedBox(height: 6),
              Text(
                _showVideoError ? 'Please upload a video first' : 'Select your Video here',
                style: TextStyle(
                    fontSize: 12,
                    color: _showVideoError ? Colors.red : Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              if (!_showVideoError) ...[
                const SizedBox(height: 3),
                const Text('Tap to record or upload',
                    style: TextStyle(fontSize: 11, color: Colors.black38)),
              ],
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => setState(() { _videoSelected = true; _showVideoError = false; }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: _showVideoError ? Colors.red : _purple,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Upload Video',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListingType() {
    final types = [
      {'label': 'Sale',  'image': 'assets/shorts/sale.png',  'color': const Color(0xFF009812)},
      {'label': 'Rent',  'image': 'assets/shorts/lease.png', 'color': const Color(0xFFFF1515)},
      {'label': 'Lease', 'image': 'assets/shorts/rent.png',  'color': const Color(0xFF220BA6)},
    ];

    return Row(
      children: types.map((t) {
        final label = t['label'] as String;
        final image = t['image'] as String;
        final color = t['color'] as Color;
        final sel   = _listingType == label;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() {
                _listingType       = label;
              }),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: sel ? color : (_showListingError ? Colors.red : _borderGrey),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20, height: 20,
                      child: Image.asset(image, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.home_outlined, size: 20,
                                  color: sel ? color : Colors.grey.shade500)),
                    ),
                    const SizedBox(height: 4),
                    Text(label,
                        style: TextStyle(
                          fontSize: 12,
                          color: sel ? color : Colors.black,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Text field delegates to _InlineErrorField ──────────────────────────────
  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    String?   prefix,
    String?   suffix,
    IconData? prefixIcon,
  }) {
    return _InlineErrorField(
      controller: controller,
      hint: hint,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      prefix: prefix,
      suffix: suffix,
      prefixIcon: prefixIcon,
      borderGrey: _borderGrey,
    );
  }

  Widget _dropdownBox({
    required String value,
    required String hint,
    required VoidCallback onTap,
  }) {
    final hasVal = value.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _borderGrey, width: 1),
          boxShadow: const [
            BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasVal ? value : hint,
                style: TextStyle(fontSize: 13, color: hasVal ? Colors.black87 : Colors.grey.shade400),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _descriptionBox() {
    return Container(
      width: double.infinity,
      height: 83,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderGrey, width: 1),
      ),
      child: TextFormField(
        controller: _descCtrl,
        maxLines: 4,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Highlight nearby Metro, rating, gym...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  DASHED BORDER PAINTER
// ════════════════════════════════════════════════════════════════════════════
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 5.0;
    const radius    = 8.0;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      const Radius.circular(radius),
    );

    final path    = Path()..addRRect(rect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final end = (distance + (draw ? dashWidth : dashSpace)).clamp(0.0, metric.length);
        if (draw) canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}