import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import '../config/app_colors.dart';
import '../providers/language_provider.dart';
import '../models/chat_message.dart';
import '../models/job.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Job job;

  const ChatScreen({
    Key? key,
    required this.job,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late List<ChatMessage> messages;

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  void _initializeMessages() {
    final strings = ref.read(appStringsProvider);
    messages = [
      ChatMessage(text: strings.hello, isUser: true),
      ChatMessage(text: 'Hello~', isUser: false),
      ChatMessage(
        text: strings.applyMessage,
        isUser: false,
      ),
      ChatMessage(
        text: strings.contactMessage,
        isUser: false,
      ),
    ];
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    if (widget.job.whatsappPhone == null || widget.job.whatsappPhone!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WhatsApp contact information not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final phone = widget.job.whatsappPhone!.replaceAll(RegExp(r'[^\d+]'), '');
    final message = 'Hi, I am interested in the ${widget.job.title} position at ${widget.job.companyName}.';
    final whatsappUrl = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';

    try {
      // 在浏览器中使用 window.open
      html.window.open(whatsappUrl, '_blank');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening WhatsApp for ${widget.job.companyName}...'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);

    // 当语言改变时，重新初始化消息
    ref.listen(languageProvider, (previous, next) {
      _initializeMessages();
      setState(() {});
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              itemCount: messages.length,
              itemBuilder: (context, index) => ChatBubble(
                message: messages[index],
              ),
            ),
          ),
          // Apply 按钮
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => _openWhatsApp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  '${strings.applyNow} for ${widget.job.title}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
