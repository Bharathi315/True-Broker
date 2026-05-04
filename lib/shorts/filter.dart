import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  static const Color _purple = Color(0xFF7C348D);

  // ─── State ────────────────────────────────────────────────────────────────
  String _listingType = 'Sale'; // Sale | Rent | Lease
  RangeValues _budget = const RangeValues(210, 810);

  final List<String> _propertyTypes = ['Apartment', 'Villa', 'Plot', 'Commercial'];
  final Set<String> _selectedPropertyTypes = {};

  final List<String> _bhkOptions = ['1 BHK', '2 BHK', '3 BHK', '4 BHK'];
  final Set<String> _selectedBhk = {};

  final List<String> _cities = ['Coimbatore', 'Chennai'];
  final Set<String> _selectedCities = {};

  void _clearAll() {
    setState(() {
      _listingType = 'Sale';
      _budget = const RangeValues(210, 810);
      _selectedPropertyTypes.clear();
      _selectedBhk.clear();
      _selectedCities.clear();
    });
  }

  void _apply() {
    Navigator.pop(context, {
      'listingType': _listingType,
      'budget': _budget,
      'propertyTypes': _selectedPropertyTypes.toList(),
      'bhk': _selectedBhk.toList(),
      'cities': _selectedCities.toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter options',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(Icons.close, size: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),
            const Divider(height: 1),

            // ── Scrollable body ───────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Listing Type ──────────────────────────────────────────
                    _sectionTitle('Listing Type'),
                    const SizedBox(height: 10),
                    Row(
                      children: ['Sale', 'Rent', 'Lease'].map((t) {
                        final selected = _listingType == t;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => setState(() => _listingType = t),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? _purple : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: selected ? _purple : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                t,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // ── Budget ────────────────────────────────────────────────
                    _sectionTitle('Budget'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${_budget.start.toInt()}L',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                        Text(
                          '₹${_budget.end.toInt()}C',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: _purple,
                        inactiveTrackColor: Colors.grey.shade200,
                        thumbColor: _purple,
                        overlayColor: _purple.withOpacity(0.15),
                        rangeThumbShape: const RoundRangeSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        trackHeight: 3,
                      ),
                      child: RangeSlider(
                        min: 0,
                        max: 1000,
                        values: _budget,
                        onChanged: (v) => setState(() => _budget = v),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Property Type ─────────────────────────────────────────
                    _sectionTitle('Property Type'),
                    const SizedBox(height: 10),
                    _chipGroup(
                      items: _propertyTypes,
                      selected: _selectedPropertyTypes,
                      onTap: (v) => setState(() {
                        _selectedPropertyTypes.contains(v)
                            ? _selectedPropertyTypes.remove(v)
                            : _selectedPropertyTypes.add(v);
                      }),
                    ),

                    const SizedBox(height: 20),

                    // ── BHK ───────────────────────────────────────────────────
                    _sectionTitle('BHK'),
                    const SizedBox(height: 10),
                    _chipGroup(
                      items: _bhkOptions,
                      selected: _selectedBhk,
                      onTap: (v) => setState(() {
                        _selectedBhk.contains(v)
                            ? _selectedBhk.remove(v)
                            : _selectedBhk.add(v);
                      }),
                    ),

                    const SizedBox(height: 20),

                    // ── City ──────────────────────────────────────────────────
                    _sectionTitle('City'),
                    const SizedBox(height: 10),
                    _chipGroup(
                      items: _cities,
                      selected: _selectedCities,
                      onTap: (v) => setState(() {
                        _selectedCities.contains(v)
                            ? _selectedCities.remove(v)
                            : _selectedCities.add(v);
                      }),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ── Bottom action row ─────────────────────────────────────────────
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 14, 20, 14 + MediaQuery.of(context).padding.bottom),
              child: Row(
                children: [
                  // Clear All
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearAll,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text(
                        'Clear All',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Apply
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _chipGroup({
    required List<String> items,
    required Set<String> selected,
    required void Function(String) onTap,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isSelected = selected.contains(item);
        return GestureDetector(
          onTap: () => onTap(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? _purple.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? _purple : Colors.grey.shade300,
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? _purple : Colors.black87,
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}