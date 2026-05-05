import 'package:flutter/material.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

const Color kPrimary = Color(0xFF742B88);
const Color kPrimaryLight = Color(0xFFF6F4F9);
const Color kDividerColor = Color(0xFFD1CFDF);

// ─── Filter Type Enum ─────────────────────────────────────────────────────────

enum FilterType { radio, range }

// ─── Data Models ──────────────────────────────────────────────────────────────

class FilterOption {
  final String label;
  final String count;
  const FilterOption({required this.label, this.count = ''});
}

class FilterCategory {
  final String key;
  final String label;
  final FilterType type;
  final List<FilterOption> options;
  final double rangeMin;
  final double rangeMax;
  final String rangeHint;

  const FilterCategory({
    required this.key,
    required this.label,
    this.type = FilterType.radio,
    this.options = const [],
    this.rangeMin = 0,
    this.rangeMax = 1000000,
    this.rangeHint = 'Choose a range below',
  });
}

final List<FilterCategory> filterCategories = [
  FilterCategory(
    key: 'power_supply',
    label: 'By Power Supply',
    options: [
      FilterOption(label: 'Single Phase', count: '5 Items'),
      FilterOption(label: 'Three Phase', count: '10+ Items'),
    ],
  ),
  FilterCategory(
    key: 'floor_height',
    label: 'By Floor Height',
    options: [
      FilterOption(label: '10 - 15 ft', count: '5 Items'),
      FilterOption(label: '15 - 20 ft', count: '10+ Items'),
      FilterOption(label: '20+ ft', count: '3 Items'),
    ],
  ),
  FilterCategory(
    key: 'budget',
    label: 'By Budget',
    type: FilterType.range,
    rangeMin: 0,
    rangeMax: 1000000,
    rangeHint: 'Choose a range below',
  ),
  FilterCategory(
    key: 'area',
    label: 'By Area',
    type: FilterType.range,
    rangeMin: 0,
    rangeMax: 100000,
    rangeHint: 'Choose a range below (sq ft)',
  ),
  FilterCategory(
    key: 'listed_by',
    label: 'Listed By',
    options: [
      FilterOption(label: 'Owner', count: '5 Items'),
      FilterOption(label: 'Dealer', count: '10+ Items'),
      FilterOption(label: 'Builder', count: '3 Items'),
    ],
  ),
];

// ─── Show Industrial Building Filter Sheet ───────────────────────────────────

void showIndustrialBuildingFilterSheet(
    BuildContext context, {
      void Function(Map<String, dynamic> result)? onApply,
    }) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => IndustrialBuildingFilterBottomSheet(onApply: onApply),
  );
}

// ─── IndustrialBuildingFilterBottomSheet ──────────────────────────────────────

class IndustrialBuildingFilterBottomSheet extends StatefulWidget {
  final void Function(Map<String, dynamic> result)? onApply;
  const IndustrialBuildingFilterBottomSheet({super.key, this.onApply});

  @override
  State<IndustrialBuildingFilterBottomSheet> createState() => _IndustrialBuildingFilterBottomSheetState();
}

class _IndustrialBuildingFilterBottomSheetState extends State<IndustrialBuildingFilterBottomSheet> {
  String _activeKey = filterCategories.first.key;
  final Map<String, int> _radioSelected = {};
  final Map<String, RangeValues> _rangeSelected = {};

  FilterCategory get _activeCategory =>
      filterCategories.firstWhere((c) => c.key == _activeKey);

  bool _hasSelection(String key) {
    final cat = filterCategories.firstWhere((c) => c.key == key);
    return cat.type == FilterType.radio
        ? _radioSelected.containsKey(key)
        : _rangeSelected.containsKey(key);
  }

  void _handleClear() {
    setState(() {
      _radioSelected.clear();
      _rangeSelected.clear();
    });
  }

  void _handleApply() {
    final result = <String, dynamic>{};
    for (final cat in filterCategories) {
      if (cat.type == FilterType.radio && _radioSelected.containsKey(cat.key)) {
        result[cat.key] = cat.options[_radioSelected[cat.key]!].label;
      } else if (cat.type == FilterType.range && _rangeSelected.containsKey(cat.key)) {
        final rv = _rangeSelected[cat.key]!;
        result[cat.key] = '${rv.start.toInt()} – ${rv.end.toInt()}';
      }
    }
    widget.onApply?.call(result);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, __) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              _SheetHeader(onClose: () => Navigator.pop(context)),
              const Divider(height: 1, thickness: 0.5, color: kDividerColor),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 160,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: kDividerColor, width: 0.5),
                        ),
                      ),
                      child: _LeftNav(
                        categories: filterCategories,
                        activeKey: _activeKey,
                        hasSelection: _hasSelection,
                        onTap: (key) => setState(() => _activeKey = key),
                      ),
                    ),
                    Expanded(
                      child: _activeCategory.type == FilterType.range
                          ? _RangePane(
                        category: _activeCategory,
                        value: _rangeSelected[_activeKey] ??
                            RangeValues(
                              _activeCategory.rangeMin,
                              _activeCategory.rangeMax,
                            ),
                        onChanged: (v) =>
                            setState(() => _rangeSelected[_activeKey] = v),
                      )
                          : _RadioPane(
                        category: _activeCategory,
                        selectedIndex: _radioSelected[_activeKey],
                        onSelect: (i) =>
                            setState(() => _radioSelected[_activeKey] = i),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 0.5, color: kDividerColor),
              _SheetFooter(onClear: _handleClear, onApply: _handleApply),
            ],
          ),
        );
      },
    );
  }
}

// ─── Sheet Header ─────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final VoidCallback onClose;
  const _SheetHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Industrial Building Filters',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: kPrimary,
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF5F6368), width: 1.2),
              ),
              child: const Icon(Icons.close, size: 16, color: Color(0xFF5F6368)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Left Nav ─────────────────────────────────────────────────────────────────

class _LeftNav extends StatelessWidget {
  final List<FilterCategory> categories;
  final String activeKey;
  final bool Function(String key) hasSelection;
  final void Function(String key) onTap;

  const _LeftNav({
    required this.categories,
    required this.activeKey,
    required this.hasSelection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        thickness: 0.5,
        color: kDividerColor,
      ),
      itemBuilder: (_, i) {
        final cat = categories[i];
        final isActive = cat.key == activeKey;
        final hasSel = hasSelection(cat.key);

        return GestureDetector(
          onTap: () => onTap(cat.key),
          child: Container(
            padding: EdgeInsets.only(
              left: isActive ? 12 : 16,
              right: 8,
              top: 14,
              bottom: 14,
            ),
            decoration: BoxDecoration(
              color: isActive ? kPrimaryLight : Colors.transparent,
              border: isActive
                  ? const Border(
                left: BorderSide(color: kPrimary, width: 4),
              )
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.normal,
                      color: isActive ? Colors.black : const Color(0xFF555555),
                      height: 1.4,
                    ),
                  ),
                ),
                if (hasSel)
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: kPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Radio Pane ───────────────────────────────────────────────────────────────

class _RadioPane extends StatelessWidget {
  final FilterCategory category;
  final int? selectedIndex;
  final void Function(int index) onSelect;

  const _RadioPane({
    required this.category,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      itemCount: category.options.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Choose from below options',
              style: TextStyle(fontSize: 11, color: Color(0xFF414141)),
            ),
          );
        }

        final optIndex = i - 1;
        final opt = category.options[optIndex];
        final isChecked = selectedIndex == optIndex;

        return GestureDetector(
          onTap: () => onSelect(optIndex),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isChecked ? kPrimary : Colors.transparent,
                        border: Border.all(
                          color: isChecked ? kPrimary : const Color(0xFF5F6368),
                          width: 1.5,
                        ),
                      ),
                      child: isChecked
                          ? const Center(
                        child: CircleAvatar(
                          radius: 3.5,
                          backgroundColor: Colors.white,
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        opt.label,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ),
                    if (opt.count.isNotEmpty)
                      Text(
                        opt.count,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Range Pane ───────────────────────────────────────────────────────────────

class _RangePane extends StatelessWidget {
  final FilterCategory category;
  final RangeValues value;
  final void Function(RangeValues) onChanged;

  const _RangePane({
    required this.category,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.rangeHint,
            style: const TextStyle(fontSize: 11, color: Color(0xFF414141)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value.start.toInt().toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222222),
                ),
              ),
              Text(
                value.end.toInt().toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: kPrimary,
              inactiveTrackColor: const Color(0xFFE0E0E0),
              thumbColor: kPrimary,
              overlayColor: kPrimary.withOpacity(0.12),
              trackHeight: 3,
              thumbShape:
              const RoundSliderThumbShape(enabledThumbRadius: 7),
              rangeThumbShape:
              const RoundRangeSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: RangeSlider(
              min: category.rangeMin,
              max: category.rangeMax,
              values: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sheet Footer ─────────────────────────────────────────────────────────────

class _SheetFooter extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onApply;
  const _SheetFooter({required this.onClear, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Row(
        children: [
          Container(
            width: 160,
            alignment: Alignment.center,
            child: TextButton(
              onPressed: onClear,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFBE000C),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Clear All',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(130, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}