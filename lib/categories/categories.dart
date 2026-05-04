import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  final Widget? bottomNavigationBar;
  final VoidCallback? onBack;
  const CategoriesScreen({super.key, this.bottomNavigationBar, this.onBack});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _selectedCategory = 'For You';

  final List<Map<String, dynamic>> _categories = [
    {'label': 'For You',             'icon': Icons.person_outline},
    {'label': 'Residential House',   'icon': Icons.house_outlined},
    {'label': 'Residential Lands',   'icon': Icons.landscape_outlined},
    {'label': 'Residential Villaz',  'icon': Icons.villa_outlined},
    {'label': 'Commercial Lands',    'icon': Icons.terrain_outlined},
    {'label': 'Shop Commercial',     'icon': Icons.store_outlined},
    {'label': 'Commercial Office',   'icon': Icons.business_center_outlined},
    {'label': 'Residential Plots',   'icon': Icons.grid_on_outlined},
    {'label': 'Hotel',               'icon': Icons.hotel_outlined},
    {'label': 'Hostel & PG',         'icon': Icons.apartment_outlined},
    {'label': 'Industrial Building', 'icon': Icons.factory_outlined},
  ];

  // Each category has its own image list
  final Map<String, List<String>> _categoryImages = {
    'For You':             ['assets/categories/luxury.png','assets/categories/luxury.png','assets/categories/luxury.png','assets/categories/luxury.png',
      'assets/categories/luxury.png','assets/categories/luxury.png','assets/categories/luxury.png','assets/categories/luxury.png'],

    'Residential House':   ['assets/categories/luxury.png','assets/categories/luxury.png','assets/categories/luxury.png','assets/categories/luxury.png',
      'assets/categories/luxury.png','assets/categories/luxury.png','assets/categories/luxury.png','assets/categories/luxury.png'],

    'Residential Lands':   ['assets/categories/res_land.png','assets/categories/res_land.png','assets/categories/res_land.png','assets/categories/res_land.png',
      'assets/categories/res_land.png','assets/categories/res_land.png','assets/categories/res_land.png','assets/categories/res_land.png'],

    'Residential Villaz':  ['assets/categories/villa.png','assets/categories/villa.png','assets/categories/villa.png','assets/categories/villa.png',
      'assets/categories/villa.png','assets/categories/villa.png','assets/categories/villa.png','assets/categories/villa.png'],

    'Commercial Lands':    ['assets/categories/land.png','assets/categories/land.png','assets/categories/land.png','assets/categories/land.png',
      'assets/categories/land.png','assets/categories/land.png','assets/categories/land.png','assets/categories/land.png'],

    'Shop Commercial':   ['assets/categories/shop.png','assets/categories/shop.png','assets/categories/shop.png','assets/categories/shop.png',
      'assets/categories/shop.png','assets/categories/shop.png','assets/categories/shop.png','assets/categories/shop.png'],

    'Commercial Office':   ['assets/categories/office.png','assets/categories/office.png','assets/categories/office.png','assets/categories/office.png',
      'assets/categories/office.png','assets/categories/office.png','assets/categories/office.png','assets/categories/office.png'],

    'Residential Plots':   ['assets/categories/plots.png','assets/categories/plots.png','assets/categories/plots.png','assets/categories/plots.png',
      'assets/categories/plots.png','assets/categories/plots.png','assets/categories/plots.png','assets/categories/plots.png'],

    'Hotel':               ['assets/categories/hotel.png','assets/categories/hotel.png','assets/categories/hotel.png','assets/categories/hotel.png',
      'assets/categories/hotel.png','assets/categories/hotel.png','assets/categories/hotel.png','assets/categories/hotel.png'],

    'Hostel & PG':          ['assets/categories/pg.png','assets/categories/pg.png','assets/categories/pg.png','assets/categories/pg.png',
      'assets/categories/pg.png','assets/categories/pg.png','assets/categories/pg.png','assets/categories/pg.png'],

    'Industrial Building':  ['assets/categories/building.png','assets/categories/building.png','assets/categories/building.png','assets/categories/building.png',
      'assets/categories/building.png','assets/categories/building.png','assets/categories/building.png','assets/categories/building.png'], };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: widget.bottomNavigationBar,
      appBar: AppBar(
        backgroundColor: const Color(0xFF742B88),
        elevation: 0,
        leading: GestureDetector(
          onTap: widget.onBack ?? () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 1.0,
            letterSpacing: 0,
          ),
        ),
        centerTitle: false,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── LEFT sidebar ──────────────────────────────────────────
          SizedBox(
            width: 115,
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final isSelected = _selectedCategory == cat['label'];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = cat['label']),
                  child: Container(
                    width: 115,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFFF2F2F2),
                      // full-width bottom divider like table row
                      border: const Border(
                        bottom: BorderSide(
                            color: Color(0xFFCAC5C5), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                            cat['icon'] as IconData,
                            size: 26,
                            color: Color(0xFF742B88)
                        ),
                        const SizedBox(height: 5),
                        Text(
                          cat['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF000000),

                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── CONSTANT vertical divider ────────────────────────────────
          Container(width: 1, color: const Color(0xFFCAC5C5)),

          // ── RIGHT content ────────────────────────────────────────────
          Expanded(
            child: _buildRightContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildRightContent() {
    final images = _categoryImages[_selectedCategory] ?? [];
    final half = (images.length / 2).ceil();
    final topImages    = images.take(half).toList();
    final bottomImages = images.skip(half).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: _selectedCategory,
            images: topImages,
            showFilter: true,
          ),
          _buildSection(
            title: 'Popular',
            images: bottomImages,
            showFilter: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> images,
    bool showFilter = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'Inter'
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showFilter)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    'assets/categories/filter.png',
                    height: 25,
                    width: 20,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.filter_list, size: 20, color: Color(0xFF742B88)),
                  ),
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.92,
            ),
            itemCount: images.isEmpty ? 4 : images.length,
            itemBuilder: (ctx, i) => _buildPropertyCard(
              imagePath: images.isEmpty ? '' : images[i],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyCard({required String imagePath}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF742B88), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
              child: imagePath.isNotEmpty
                  ? Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) =>
                    _placeholderBox(),
              )
                  : _placeholderBox(),
            ),
          ),
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: Row(
              children: [
                Icon(
                  Icons.home,
                  size: 13,
                  color: Color(0xff742B88),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Luxury Family Home',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff444444),
                      fontFamily: 'Lato',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _placeholderBox() {
    return Container(
      color: const Color(0xFFEDD9F5),
      child: const Center(
        child: Icon(Icons.house_outlined,
            size: 36, color: Color(0xFF742B88)),
      ),
    );
  }
}