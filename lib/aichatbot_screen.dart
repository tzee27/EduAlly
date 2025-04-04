import 'package:flutter/material.dart';
import 'home_screen.dart';

class AIChatbotScreen extends StatefulWidget {
  const AIChatbotScreen({Key? key}) : super(key: key);

  @override
  _AIChatbotScreenState createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  // Color palette from the design
  final Color steelBlue = const Color(0xFF5193B3);
  final Color aqua = const Color(0xFF62C4C3);
  final Color peach = const Color(0xFFF8D49B);
  final Color cream = const Color(0xFFF8E6CB);
  
  // Controller for the message input
  final TextEditingController _messageController = TextEditingController();
  
  // Scroll controller for auto-scrolling to the bottom
  final ScrollController _scrollController = ScrollController();
  
  // List of chat messages
  List<ChatMessage> _messages = [];
  
  // Loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add a welcome message
    _addBotMessage("Hi there! I'm your EduAlly assistant. How can I help you today?");
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isBot: true,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    final String messageText = _messageController.text;
    
    // Add user message to chat
    setState(() {
      _messages.add(ChatMessage(
        text: messageText,
        isBot: false,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
      _messageController.clear();
    });
    
    // Scroll to bottom after adding message
    _scrollToBottom();
    
    // Simulate API call to Gemini
    await Future.delayed(const Duration(seconds: 2));
    
    // Add bot response
    setState(() {
      _isLoading = false;
      _messages.add(ChatMessage(
        text: _generateBotResponse(messageText),
        isBot: true,
        timestamp: DateTime.now(),
      ));
    });
    
    // Scroll to bottom after response
    _scrollToBottom();
  }
  
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
  
  String _generateBotResponse(String message) {
    // This is a placeholder. In a real app, you would call the Gemini API here.
    if (message.toLowerCase().contains("hello") || message.toLowerCase().contains("hi")) {
      return "Hello! How can I assist you with your teaching today?";
    } else if (message.toLowerCase().contains("help")) {
      return "I can help you with lesson planning, student assessments, educational resources, and more. What specific assistance do you need?";
    } else if (message.toLowerCase().contains("lesson") || message.toLowerCase().contains("plan")) {
      return "For lesson planning, I recommend starting with clear learning objectives. What subject and grade level are you teaching?";
    } else if (message.toLowerCase().contains("assessment") || message.toLowerCase().contains("test")) {
      return "I can help design various assessment types: formative, summative, diagnostic, or performance-based. Which would you like assistance with?";
    } else if (message.toLowerCase().contains("resource")) {
      return "There are many educational resources available. Would you like recommendations for digital tools, printable materials, or interactive content?";
    } else {
      return "Thank you for your message. I'm here to assist with your educational needs. Could you provide more details about what you're looking for?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Check if we can pop (came from direct navigation)
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // We're in tab mode, so use the GlobalKey to navigate to the home tab
              HomePage.homeKey.currentState?.onItemTapped(0);
            }
          },
        ),
            // Check if we can pop (came from direct navigation)
        title: const Text(
          'AI Assistant',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () => _showInfoDialog(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "clear",
                child: Text("Clear Conversation"),
              ),
              const PopupMenuItem(
                value: "save",
                child: Text("Save Conversation"),
              ),
              const PopupMenuItem(
                value: "settings",
                child: Text("AI Settings"),
              ),
            ],
            onSelected: (value) {
              if (value == "clear") {
                setState(() {
                  _messages = [];
                  // Add welcome message back
                  _addBotMessage("Hi there! I'm your EduAlly assistant. How can I help you today?");
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAICapabilitiesBanner(),
          Expanded(
            child: _buildChatMessages(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }
  
  Widget _buildAICapabilitiesBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: cream,
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.orange[800]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Powered by AI. I can answer questions and help you with teaching tasks.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final showTimestamp = index == 0 || 
          _messages[index].timestamp.difference(_messages[index - 1].timestamp).inMinutes > 5;
        
        return Column(
          children: [
            if (showTimestamp)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _formatTimestamp(message.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            _buildMessageBubble(message),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    if (timestamp.day == now.day && 
        timestamp.month == now.month && 
        timestamp.year == now.year) {
      return "Today at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
    } else if (timestamp.day == now.day - 1 && 
               timestamp.month == now.month && 
               timestamp.year == now.year) {
      return "Yesterday at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
    } else {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year} at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
    }
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Row(
      mainAxisAlignment: message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.isBot)
          Container(
            margin: const EdgeInsets.only(right: 12),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: steelBlue,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message.isBot ? Colors.white : steelBlue,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: message.isBot ? const Radius.circular(0) : const Radius.circular(16),
                bottomRight: message.isBot ? const Radius.circular(16) : const Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isBot ? Colors.black : Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        if (!message.isBot)
          Container(
            margin: const EdgeInsets.only(left: 12),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "Me",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          _isLoading
              ? Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: steelBlue,
                    shape: BoxShape.circle,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                  style: IconButton.styleFrom(
                    backgroundColor: steelBlue,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
        ],
      ),
    );
  }
  
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: steelBlue),
            const SizedBox(width: 8),
            const Text("About AI Assistant"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Powered by Google Gemini",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This AI assistant can help you with:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildCapabilityItem("Analyzing student work and data"),
            _buildCapabilityItem("Creating lesson plans and materials"),
            _buildCapabilityItem("Answering educational questions"),
            _buildCapabilityItem("Processing and summarizing documents"),
            _buildCapabilityItem("Generating teaching resources"),
            const SizedBox(height: 16),
            Text(
              "Your conversations are private and secure. Data is handled according to our privacy policy.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCapabilityItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• "),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isBot;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isBot,
    required this.timestamp,
  });
}