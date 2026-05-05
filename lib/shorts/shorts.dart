import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'filter.dart';
import 'post.dart';

class ShortsPage extends StatefulWidget {
  final Widget? bottomNavigationBar;
  final VoidCallback? onBack;

  const ShortsPage({
    super.key,
    this.bottomNavigationBar,
    this.onBack,
  });

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  static const Color _purple = Color(0xFF7C348D);

  final List<Map<String, dynamic>> _stories = [
    {'label': 'Add Post', 'isAdd': true,'img': 'assets/categories/house.png'},
  ];

  final List<Map<String, dynamic>> _shorts = [
    {
      'views': '1,102 watching',
      'img': 'assets/shorts/property1.png',
      'tag': 'For Sale',
      'price': '₹32 Lakhs',
      'title': 'Home',
      'location': 'Krishna Nagar, Coimbatore.',
      'badges': ['3BHK', 'CMDA', 'Gated Society'],
      'agent': 'AK',
      'agentName': 'Akhil Infra Property',
      'verified': true,
      'agentLoc': 'Coimbatore',
      'rating': '4.4',
      'time': '53B',
      'likes': '1.2K',
      'comments': '234',
      'saves': '89',
    },
  ];

  bool _showStories = true;

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const FilterBottomSheet(),
    );
  }

  void _openAddPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPostScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      // ── bottomNavigationBar passed from parent ──
      bottomNavigationBar: widget.bottomNavigationBar,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _shorts.length,
            onPageChanged: (i) {
              if (i > 0 && _showStories) {
                setState(() => _showStories = false);
              } else if (i == 0 && !_showStories) {
                setState(() => _showStories = true);
              }
            },
            itemBuilder: (_, i) => _fullScreenShort(_shorts[i]),
          ),

          // ── Top overlay: AppBar + Stories ──
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAppBar(),
                if (_showStories) _buildStoryRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            // use onBack callback if provided, else pop
            onTap: widget.onBack ?? () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _openFilter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.tune, size: 15, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── STORY ROW ────────────────────────────────────────────────────────────
  Widget _buildStoryRow() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        itemCount: _stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final s = _stories[i];
          return s['isAdd'] == true ? _addPostCircle() : _storyCircle(s);
        },
      ),
    );
  }

  Widget _addPostCircle() {
    return GestureDetector(
      onTap: _openAddPost,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black45,
              border: Border.all(color: Colors.white54, width: 2),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add Post',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _storyCircle(Map<String, dynamic> s) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4F7BD9), Color(0xFFCA6868)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: ClipOval(
                child: Image.asset(
                  s['img'],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, color: Colors.white54, size: 24),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          s['label'],
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
      ],
    );
  }

  // ─── FULL SCREEN SHORT ────────────────────────────────────────────────────
  Widget _fullScreenShort(Map<String, dynamic> d) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          d['img'],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF1A1A1A),
            child: const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white24, size: 72),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.35, 0.65, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.92),
                ],
              ),
            ),
          ),
        ),

        // Right side actions
        Positioned(
          right: 12,
          bottom: 200,
          child: Column(
            children: [
              _sideAction(Icons.favorite_border, d['likes']),
              const SizedBox(height: 24),
              _sideAction(Icons.chat_bubble_outline, d['comments']),
              const SizedBox(height: 24),
              _sideAction(Icons.bookmark_border, d['saves']),
              const SizedBox(height: 24),
              _sideAction(Icons.share, ''),
            ],
          ),
        ),

        // Bottom property info
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: d['tag'] == 'For Sale'
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFF1565C0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      d['tag'],
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    d['price'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(d['title'],
                      style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 13, color: Colors.white54),
                      const SizedBox(width: 4),
                      Text(d['location'],
                          style: const TextStyle(fontSize: 12, color: Colors.white54)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: (d['badges'] as List<String>)
                        .map((b) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(b,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white70)),
                      ),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: _purple,
                        child: Text(d['agent'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(d['agentName'],
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                if (d['verified'] == true) ...[
                                  const SizedBox(width: 3),
                                  const Icon(Icons.verified,
                                      color: Color(0xFF7C348D), size: 13),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                if (d['verified'] == true)
                                  const Text('✓ Verified · ',
                                      style: TextStyle(fontSize: 10, color: Colors.green)),
                                const Icon(Icons.star, color: Colors.amber, size: 11),
                                const SizedBox(width: 2),
                                Text('${d['rating']} · ${d['agentLoc']}',
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.white54)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(Icons.share, color: Colors.white38, size: 16),
                          const SizedBox(height: 2),
                          Text(d['time'],
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white38)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Contact',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
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

  Widget _sideAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0x33F0F0F0),
            shape: BoxShape.circle,
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 22)),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
        ],
      ],
    );
  }
}