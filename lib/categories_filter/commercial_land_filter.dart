import 'package:flutter/material.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

const Color kPrimary = Color(0xFF742B88);
const Color kPrimaryLight = Color(0xFFF6F4F9);
const Color kDividerColor = Color(0xFFD1CFDF);

// ─── Filter Type Enum ─────────────────────────────────────────────────────────

enum FilterType { radio }

// ─── Data Models ──────────────────────────────────────────────────────────────

class FilterOption {
  final String label;
  const FilterOption({required this.label});
}

class FilterCategory {
  final String key;
  final String label;
  final List<FilterOption> options;

  const FilterCategory({
    required this.key,
    required this.label,
    required this.options,
  });
}

final List<FilterCategory> filterCategories = [
  FilterCategory(
    key: 'budget',
    label: 'By Budget',
    options: [
      FilterOption(label: 'Below 25 Lakhs'),
      FilterOption(label: '25 – 50 Lakhs'),
      FilterOption(label: '50 Lakhs – 1 Cr'),
      FilterOption(label: '1 – 5 Cr'),
      FilterOption(label: 'Above 5 Cr'),
    ],
  ),
  FilterCategory(
    key: 'land_type',
    label: 'By Land Type',
    options: [
      FilterOption(label: 'Commercial Plot'),
      FilterOption(label: 'Industrial Land'),
      FilterOption(label: 'Retail Land'),
      FilterOption(label: 'Investment Land'),
    ],
  ),
  FilterCategory(
    key: 'plot_size',
    label: 'By Plot Size',
    options: [
      FilterOption(label: 'Below 1000 Sq.ft'),
      FilterOption(label: '1000 – 2500 Sq.ft'),
      FilterOption(label: '2500 – 5000 Sq.ft'),
      FilterOption(label: '5000 – 10,000 Sq.ft'),
      FilterOption(label: 'Above 10,000 Sq.ft'),
    ],
  ),
  FilterCategory(
    key: 'road_width',
    label: 'By Road Width',
    options: [
      FilterOption(label: '20 ft'),
      FilterOption(label: '30 ft'),
      FilterOption(label: '40 ft'),
      FilterOption(label: '60 ft'),
      FilterOption(label: '80+ ft'),
    ],
  ),
  FilterCategory(
    key: 'approval',
    label: 'By Approval',
    options: [
      FilterOption(label: 'DTCP Approved'),
      FilterOption(label: 'CMDA Approved'),
      FilterOption(label: 'RERA Approved'),
      FilterOption(label: 'Corporation Approved'),
    ],
  ),
  FilterCategory(
    key: 'facing',
    label: 'By Facing',
    options: [
      FilterOption(label: 'East'),
      FilterOption(label: 'West'),
      FilterOption(label: 'North'),
      FilterOption(label: 'South'),
      FilterOption(label: 'North-East'),
      FilterOption(label: 'North-West'),
      FilterOption(label: 'South-East'),
      FilterOption(label: 'South-West'),
    ],
  ),
  FilterCategory(
    key: 'property_type',
    label: 'By Property Type',
    options: [
      FilterOption(label: 'Corner Plot'),
      FilterOption(label: 'Main Road Facing'),
      FilterOption(label: 'Highway Facing'),
      FilterOption(label: 'Gated Layout'),
    ],
  ),
  FilterCategory(
    key: 'listed_by',
    label: 'Listed By',
    options: [
      FilterOption(label: 'Owner'),
      FilterOption(label: 'Agent'),
      FilterOption(label: 'Builder'),
    ],
  ),
];

// ─── Show Filter Sheet ────────────────────────────────────────────────────────

void showCommercialLandFilterSheet(
    BuildContext context, {
      void Function(Map<String, dynamic> result)? onApply,
    }) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FilterBottomSheet(onApply: onApply),
  );
}

// ─── FilterBottomSheet ────────────────────────────────────────────────────────

class FilterBottomSheet extends StatefulWidget {
  final void Function(Map<String, dynamic> result)? onApply;
  const FilterBottomSheet({super.key, this.onApply});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String _activeKey = filterCategories.first.key;
  final Map<String, int> _radioSelected = {};

  FilterCategory get _activeCategory =>
      filterCategories.firstWhere((c) => c.key == _activeKey);

  void _handleClear() {
    setState(() {
      _radioSelected.clear();
    });
  }

  void _handleApply() {
    final result = <String, dynamic>{};
    for (final cat in filterCategories) {
      if (_radioSelected.containsKey(cat.key)) {
        result[cat.key] = cat.options[_radioSelected[cat.key]!].label;
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
                        hasSelection: (key) => _radioSelected.containsKey(key),
                        onTap: (key) => setState(() => _activeKey = key),
                      ),
                    ),
                    Expanded(
                      child: _RadioPane(
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
            'Commercial Lands Filter',
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
          child: Padding(
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
              ],
            ),
          ),
        );
      },
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