import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class LuxuryHomeScreen extends StatefulWidget {
  const LuxuryHomeScreen({super.key});

  @override
  State<LuxuryHomeScreen> createState() => _LuxuryHomeScreenState();
}

class _LuxuryHomeScreenState extends State<LuxuryHomeScreen> {
  int _selectedIndex = 0; // 0 for CHAT, 1 for MAKE OFFER
  bool _isChatExpanded = false;
  bool _showEmojiPicker = false;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _offerAmountController = TextEditingController(text: '5,500');
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;
  late AudioRecorder _audioRecorder;
  late AudioPlayer _audioPlayer;
  String? _currentPlayingPath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
  }

  final List<String> _commonEmojis = [
    '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😊', '😇',
    '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚',
    '😋', '😛', '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🤩',
    '🥳', '😏', '😒', '😞', '😔', '😟', '😕', '🙁', '☹️', '😣',
    '😖', '😫', '😩', '🥺', '😢', '😭', '😤', '😠', '😡', '🤬',
    '🤯', '😳', '🥵', '🥶', '😱', '😨', '😰', '😥', '😓', '🤗',
    '🤔', '🤭', '🤫', '🤥', '😶', '😐', '😑', '😬', '🙄', '😯',
    '😦', '😧', '😮', '😲', '🥱', '😴', '🤤', '😪', '😵', '🤐',
    '🥴', '🤢', '🤮', '🤧', '😷', '🤒', '🤕', '🤑', '🤠', '😈'
  ];
  
  final List<Map<String, dynamic>> _messages = [
    {
      'isOutgoing': false,
      'sender': 'Mike Mazowski',
      'text': 'Hello guys, we have discussed about post-corona vacation plan and our decision is to go to Bali. We will have a very big party after this corona ends! These are some images about our destination',
      'time': '16.04',
      'type': 'text',
    },
    {
      'isOutgoing': false,
      'type': 'images',
      'time': '16.04',
    },
    {
      'isOutgoing': true,
      'text': 'That’s very nice place! you guys\nmade a very good decision.\nCan’t wait to go on vacation!',
      'time': '16.04',
      'type': 'text',
    },
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'isOutgoing': true,
          'text': _messageController.text.trim(),
          'time': '16.04',
          'type': 'text',
        });
        _messageController.clear();
      });
      _scrollToBottom();
    }
  }

  void _handleSendAudioMessage(String path) {
    setState(() {
      _messages.add({
        'isOutgoing': true,
        'text': 'Audio Message',
        'path': path,
        'time': '16.05',
        'type': 'audio',
      });
    });
    _scrollToBottom();
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        const config = RecordConfig();
        await _audioRecorder.start(config, path: path);
        
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      if (path != null) {
        _handleSendAudioMessage(path);
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _playAudio(String path) async {
    try {
      if (_currentPlayingPath == path) {
        await _audioPlayer.stop();
        setState(() {
          _currentPlayingPath = null;
        });
      } else {
        await _audioPlayer.play(DeviceFileSource(path));
        setState(() {
          _currentPlayingPath = path;
        });
        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            _currentPlayingPath = null;
          });
        });
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> _handlePickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          for (var file in result.files) {
            bool isImage = file.extension != null && 
                ['jpg', 'jpeg', 'png', 'gif'].contains(file.extension!.toLowerCase());
            
            _messages.add({
              'isOutgoing': true,
              'text': file.name,
              'path': file.path,
              'time': '16.05',
              'type': isImage ? 'image_file' : 'file',
            });
          }
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showEmojiPicker) {
          setState(() {
            _showEmojiPicker = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 56,
          backgroundColor: const Color(0xFF742B88),
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF444444),
            statusBarIconBrightness: Brightness.light,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Luxury Family Home',
              style: TextStyle(
                fontFamily: 'Lato',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.0,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildChatList(),
            ),
            // Bottom Navigation + Chat Input Panel
            _buildBottomNavPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + 1, // +1 for the typing indicator
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return _buildTypingIndicator();
        }

        final msg = _messages[index];
        if (msg['type'] == 'images') {
          return _buildStaticImagesMessage(msg);
        }
        
        if (msg['type'] == 'image_file') {
          return _buildImageFileMessage(msg);
        }

        if (msg['type'] == 'audio') {
          return _buildAudioMessage(msg);
        }

        if (msg['type'] == 'file' || msg['isOutgoing']) {
          return _buildOutgoingOrFileMessage(msg);
        } else {
          return _buildIncomingMessage(msg);
        }
      },
    );
  }


  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 42, bottom: 16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48.98,
              height: 20.99,
              padding: const EdgeInsets.symmetric(horizontal: 10.5, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildDot(),
                  const SizedBox(width: 8.74),
                  Transform.translate(offset: const Offset(0, -3), child: _buildDot()),
                  const SizedBox(width: 8.74),
                  Transform.translate(offset: const Offset(0, 3), child: _buildDot()),
                ],
              ),
            ),
            Positioned(
              left: -18.33,
              bottom: 0,
              child: _buildOnlineIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticImagesMessage(Map<String, dynamic> msg) {
    return Padding(
      padding: const EdgeInsets.only(left: 56, top: 4, bottom: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 178.43,
                height: 87.47,
                decoration: BoxDecoration(
                  color: const Color(0xFFA4A3A3),
                  borderRadius: BorderRadius.circular(3.5),
                ),
              ),
              const SizedBox(height: 3.5),
              Row(
                children: [
                  Container(
                    width: 87.47,
                    height: 87.47,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA4A3A3),
                      borderRadius: BorderRadius.circular(3.5),
                    ),
                  ),
                  const SizedBox(width: 3.49),
                  Container(
                    width: 87.47,
                    height: 87.47,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA4A3A3),
                      borderRadius: BorderRadius.circular(3.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: -32.33,
            bottom: 0,
            child: _buildOnlineIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFileMessage(Map<String, dynamic> msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 32, bottom: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF742B88), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: msg['path'] != null 
                  ? Image.file(File(msg['path']), fit: BoxFit.cover)
                  : const Center(child: Icon(Icons.image)),
              ),
            ),
            Positioned(
              right: -26.0,
              bottom: 0,
              child: _buildOnlineIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioMessage(Map<String, dynamic> msg) {
    final bool isPlaying = _currentPlayingPath == msg['path'];
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 32, bottom: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () => _playAudio(msg['path']),
              child: Container(
                width: 200,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF742B88),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPlaying ? Icons.stop : Icons.play_arrow, 
                      color: Colors.white
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.white24,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: isPlaying ? 1.0 : 0.6,
                          child: Container(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      msg['time'],
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Display',
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -26.0,
              bottom: 0,
              child: _buildOnlineIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutgoingOrFileMessage(Map<String, dynamic> msg) {
    final bool isFile = msg['type'] == 'file';
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 32, bottom: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 250),
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8.75),
              decoration: const BoxDecoration(
                color: Color(0xFF742B88),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isFile)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.insert_drive_file, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              msg['text'],
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                fontSize: 10.5,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        msg['text'],
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          fontSize: 10.5,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        msg['time'],
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Display',
                          fontWeight: FontWeight.w400,
                          fontSize: 10.5,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -26.0,
              bottom: 0,
              child: _buildOnlineIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingMessage(Map<String, dynamic> msg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 56, bottom: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 250),
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8.75),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    msg['sender'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Color(0xFFE67E22),
                      fontWeight: FontWeight.bold,
                      fontSize: 10.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    msg['text'],
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      fontSize: 10.5,
                      color: Color(0xFF4F5E7B),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      msg['time'],
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Display',
                        fontWeight: FontWeight.w400,
                        fontSize: 10.5,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: -32.33,
              bottom: 0,
              child: _buildOnlineIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavPanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: _isChatExpanded 
          ? (_showEmojiPicker ? 460 : 320)
          : 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Purple Header (Navigation)
          Container(
            color: const Color(0xFF742B88),
            height: 60,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 9,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _isChatExpanded
                        ? Container(
                            width: 18,
                            height: 2.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                        : Image.asset(
                            'assets/bottomnavbar/arrowlineluxury.png',
                            width: 14.28,
                            height: 10.5,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 14),
                          ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedIndex == 0) {
                              _isChatExpanded = !_isChatExpanded;
                            } else {
                              _selectedIndex = 0;
                              _isChatExpanded = true;
                            }
                            if (!_isChatExpanded) _showEmojiPicker = false;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: const Center(
                          child: Text(
                            'CHAT',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedIndex == 1) {
                              _isChatExpanded = !_isChatExpanded;
                            } else {
                              _selectedIndex = 1;
                              _isChatExpanded = true;
                            }
                            _showEmojiPicker = false;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: const Center(
                          child: Text(
                            'MAKE OFFER',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Selection Indicator Underline
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: 0,
                  left: _selectedIndex == 0
                      ? MediaQuery.of(context).size.width * 0.15
                      : MediaQuery.of(context).size.width * 0.65,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Expanded Content
          if (_isChatExpanded)
            SizedBox(
              height: 250, // Fixed height for the expanded panel to prevent layout errors
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _selectedIndex == 0
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 10,
                                children: [
                                  _buildQuickReply('Hello'),
                                  _buildQuickReply('Is it available ?'),
                                  _buildQuickReply('Okay'),
                                  _buildQuickReply('No problem'),
                                  _buildQuickReply('Please reply'),
                                  _buildQuickReply('Not interested'),
                                ],
                              ),
                            )
                          : _buildMakeOfferPanelContent(),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  _buildBottomInputBar(),
                  if (_showEmojiPicker)
                    _buildCustomEmojiPicker(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMakeOfferPanelContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceChip('₹ 5,500'),
              _buildPriceChip('₹ 5,200'),
              _buildPriceChip('₹ 4,800'),
              _buildPriceChip('₹ 4,600'),
              _buildPriceChip('₹ 4,200'),
            ],
          ),
          const SizedBox(height: 30),
          // Amount section
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '₹ ',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 15.74 / 24,
                ),
              ),
              Container(
                width: 82,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF742B88),
                      width: 1.5,
                    ),
                  ),
                ),
                child: TextField(
                  controller: _offerAmountController,
                  keyboardType: TextInputType.number,
                  cursorHeight: 24,
                  cursorColor: const Color(0xFF742B88),
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 15.74 / 24,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Offer Bubble and SEND button
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      _messageController.text = 'Very good offer !';
                      _handleSendMessage();
                    },
                    child: Container(
                      width: 242,
                      height: 30,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 30),
                      decoration: BoxDecoration(
                        color: const Color(0xFF742B88),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Very good offer !',
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 12,
                          fontFamily: 'Lato'
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 9,
                    left: -6,
                    child: Transform.rotate(
                      angle: 0.785398, // 45 degrees
                      child: Container(
                        width: 12,
                        height: 12,
                        color: const Color(0xFF742B88),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  final amount = _offerAmountController.text.trim();
                  if (amount.isNotEmpty) {
                    _messageController.text = 'My offer is ₹ $amount';
                    _handleSendMessage();
                  }
                },
                child: Container(
                  width: 74,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF742B88),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SEND',
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.w400, 
                      fontSize: 12,
                      fontFamily: 'Lato'
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChip(String price) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Extract just the number from the chip text (e.g., "₹ 5,500" -> "5,500")
          _offerAmountController.text = price.replaceAll('₹ ', '');
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          price,
          style: const TextStyle(color: Color(0xFFA4A3A3), fontSize: 10.5, fontFamily: 'Lato'),
        ),
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Container(
      width: 360,
      height: 42,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFA9A5A5),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showEmojiPicker = !_showEmojiPicker;
                if (_showEmojiPicker) {
                  FocusScope.of(context).unfocus();
                }
              });
            },
            child: const Icon(
              Icons.sentiment_satisfied_alt_outlined,
              color: Color(0xFFA4A3A3),
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _messageController,
              onTap: () {
                if (_showEmojiPicker) {
                  setState(() {
                    _showEmojiPicker = false;
                  });
                }
              },
              onSubmitted: (_) => _handleSendMessage(),
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: 'Write a message...',
                hintStyle: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xFFA4A3A3),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const Icon(Icons.attach_file, color: Color(0xFFA4A3A3), size: 20),
          const SizedBox(width: 8),
          GestureDetector(
            onLongPressStart: (_) => _startRecording(),
            onLongPressEnd: (_) => _stopRecording(),
            child: Icon(
              Icons.mic,
              color: _isRecording ? Colors.red : const Color(0xFF742B88),
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _handleSendMessage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF742B88),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomEmojiPicker() {
    return SizedBox(
      height: 140, // Reduced from 250 to prevent overflow
      child: Container(
        color: const Color(0xFFF2F2F2),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemCount: _commonEmojis.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _messageController.text += _commonEmojis[index];
                });
              },
              child: Center(
                child: Text(
                  _commonEmojis[index],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickReply(String text) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        _handleSendMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFA4A3A3),
            fontSize: 12,
            fontFamily: 'Lato',
          ),
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 3.5,
      height: 3.5,
      decoration: const BoxDecoration(
        color: Color(0xFF742B88),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return Container(
      width: 10.5,
      height: 10.5,
      decoration: BoxDecoration(
        color: const Color(0xFF4CE417),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.75),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _offerAmountController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
