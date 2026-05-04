import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truebroker/home/luxuryhomescreen.dart';


class MessageScreen extends StatelessWidget {
  final Widget? bottomNavigationBar;
  final VoidCallback? onBack;
  const MessageScreen({super.key, this.bottomNavigationBar, this.onBack});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: bottomNavigationBar,
        appBar: AppBar(
          toolbarHeight: 56,
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF444444),
            statusBarIconBrightness: Brightness.light,
          ),
          flexibleSpace: Container(
            color: const Color(0xFF742B88),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          title: const Text(
            'Message',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0), // Moves the search icon slightly to the left
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(76), // Total height: 48px (tabs) + 28px (white gap)
            child: Container(
              color: Colors.white, // The white part
              child: Column(
                children: [
                  const SizedBox(height: 28), // Increased gap within the white section
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 5,
                        color: Color(0xFF742B88),
                      ),
                      insets: EdgeInsets.zero,
                    ),
                    labelColor: const Color(0xFF000000),
                    unselectedLabelColor: const Color(0xFF000000),
                    labelStyle: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.0,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.0,
                    ),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(child: SizedBox(width: 110, child: Center(child: Text('ALL')))),
                      Tab(child: SizedBox(width: 100, child: Center(child: Text('BUYING')))),
                      Tab(child: SizedBox(width: 100, child: Center(child: Text('SELLING')))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            MessageList(category: 'all'),
            MessageList(category: 'buying'),
            MessageList(category: 'selling'),
          ],
        ),
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  final String category;
  const MessageList({super.key, required this.category});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  int? _selectedIndex;

  final List<Map<String, dynamic>> allChats = [
    {
      'name': 'Darlene Steward',
      'message': 'Pls take a look at the images.',
      'time': '18.31',
      'unread': 5,
      'dotColor': const Color(0xFFF2C94C),
      'type': 'buying'
    },
    {
      'name': 'Fullsnack Designers',
      'message': 'Hello guys, we have discussed about ...',
      'time': '16.04',
      'unread': 0,
      'type': 'selling'
    },
    {
      'name': 'Lee Williamson',
      'message': 'Yes, that\'s gonna work, hopefully.',
      'time': '06.12',
      'unread': 0,
      'dotColor': const Color(0xFF4CE417),
      'type': 'buying'
    },
    {
      'name': 'Ronald Mccoy',
      'message': 'Thanks dude 😉',
      'time': 'Yesterday',
      'unread': 0,
      'dotColor': const Color(0xFFA4A3A3),
      'showTicks': true,
      'type': 'selling'
    },
    {
      'name': 'Albert Bell',
      'message': 'I\'m happy this anime has such grea...',
      'time': 'Yesterday',
      'unread': 0,
      'dotColor': const Color(0xFFA4A3A3),
      'type': 'buying'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredChats = allChats;

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        bool isHighlighted = _selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            if (chat['name'] == 'Darlene Steward') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LuxuryHomeScreen()),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isHighlighted ? const Color(0xFFEDF4ED) : Colors.transparent,
              borderRadius: isHighlighted ? BorderRadius.circular(12) : null,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (chat['dotColor'] != null)
                    Positioned(
                      bottom: -7, // Moved down even further
                      right: 6,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: chat['dotColor'],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chat['name'],
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF742B88),
                    fontSize: 14,
                    height: 1.0,
                  ),
                ),
                Text(
                  chat['time'],
                  style: const TextStyle(color: Color(0xFF333333), fontSize: 10.95),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                if (chat['showTicks'] == true)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Image.asset(
                      'assets/bottomnavbar/tick.png',
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                    ),
                  ),
                Expanded(
                  child: Text(
                    chat['message'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF4F5E7B), fontSize: 10.95),
                  ),
                ),
                if (chat['unread'] > 0)
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E8540),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat['unread']}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ));
      },
    );
  }
}
