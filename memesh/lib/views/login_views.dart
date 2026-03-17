import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:memesh/controllers/auth_controllers.dart';
import 'package:memesh/widgets/matrix_rain.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  
  // Terminal animation
  late AnimationController _cursorController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  
  bool _showTerminal = false;
  List<String> _terminalLogs = [];
  double _progress = 0.0;
  String _currentAction = 'initializing...';
  Timer? _progressTimer;
  
  final List<Map<String, dynamic>> _bootSteps = [
    {'text': '> connecting to memesh network...', 'progress': 0.1, 'color': Colors.cyan},
    {'text': '> establishing secure channel...', 'progress': 0.2, 'color': Colors.purple},
    {'text': '> verifying anonymous identity...', 'progress': 0.35, 'color': Colors.blue},
    {'text': '> generating session token...', 'progress': 0.5, 'color': Colors.pink},
    {'text': '> synchronizing with mesh nodes...', 'progress': 0.65, 'color': Colors.orange},
    {'text': '> loading user preferences...', 'progress': 0.8, 'color': Colors.teal},
    {'text': '> initializing chat protocols...', 'progress': 0.9, 'color': Colors.green},
    {'text': '> system ready. redirecting...', 'progress': 1.0, 'color': Colors.green.shade400},
  ];

  @override
  void initState() {
    super.initState();
    
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    
    _progressController.addListener(() {
      setState(() {
        _progress = _progressController.value;
      });
    });
  }

  @override
  void dispose() {
    _cursorController.dispose();
    _progressController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleAnonymousLogin() async {
    HapticFeedback.mediumImpact();
    
    setState(() {
      _showTerminal = true;
      _terminalLogs = [];
      _progress = 0.0;
    });
    
    // Mulai progress bar
    _progressController.forward();
    
    // Jalankan terminal animation
    await _runTerminalAnimation();
    
    // Login ke Firebase
    await _authController.loginAnonymous();
  }

  Future<void> _runTerminalAnimation() async {
    for (var step in _bootSteps) {
      setState(() {
        _terminalLogs.add(step['text']);
        _currentAction = step['text'].replaceFirst('> ', '');
      });
      
      // Tunggu sesuai progress
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  String _getProgressText() {
    return '${(_progress * 100).toStringAsFixed(0)}%';
  }

  Color _getProgressColor() {
    if (_progress < 0.3) return Colors.cyan;
    if (_progress < 0.6) return Colors.purple;
    if (_progress < 0.9) return Colors.pink;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Matrix Rain Background
          const MatrixRain(),
          
          // Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
          
          // Content
          if (_showTerminal) _buildTerminalView()
          else _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x1A6F5CEE), // purple with opacity
                  Color(0x1ADB2773), // pink with opacity
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.pink.withOpacity(0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.3),
                  blurRadius: 60,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900.withOpacity(0.9),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo / Title
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.purple, Colors.pink, Colors.cyan],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'MEMESH',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      const Text(
                        'NETWORK',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 12,
                          color: Colors.pink,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.pink.withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          'v2.0.1 // SECURE PROTOCOL',
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 10,
                            letterSpacing: 2,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Welcome text
                      const Text(
                        'Welcome to the Mesh',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.purple,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      const Text(
                        'Enter the anonymous network',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.pink,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Anonymous Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Obx(() => ElevatedButton(
                          onPressed: _authController.isLoading 
                              ? null 
                              : _handleAnonymousLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.pink,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _authController.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.pink,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.security, color: Colors.pink),
                                    SizedBox(width: 12),
                                    Text(
                                      'ENTER ANONYMOUSLY',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                        )),
                      ),

                      const SizedBox(height: 24),

                      // Terminal style text
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.purple.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '> No email or password required',
                                style: TextStyle(
                                  color: Colors.green.shade400,
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info text
                      Text(
                        'Your identity is anonymous and ephemeral',
                        style: TextStyle(
                          color: Colors.purple.shade300.withOpacity(0.7),
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTerminalView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.pink.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.3),
                  blurRadius: 60,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900.withOpacity(0.95),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Terminal header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade900.withOpacity(0.5),
                              Colors.pink.shade900.withOpacity(0.5),
                            ],
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.pink.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Window controls
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.yellow.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Title
                            Expanded(
                              child: Text(
                                'memesh@login:~ authenticate.sh',
                                style: TextStyle(
                                  color: Colors.pink.shade300.withOpacity(0.8),
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            
                            // Progress percentage
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return Text(
                                  _getProgressText(),
                                  style: TextStyle(
                                    color: _getProgressColor(),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      // Terminal content
                      Container(
                        constraints: BoxConstraints(
                          minHeight: 300,
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ..._terminalLogs.asMap().entries.map((entry) {
                                final index = entry.key;
                                final line = entry.value;
                                final stepData = index < _bootSteps.length 
                                    ? _bootSteps[index] 
                                    : null;
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '>',
                                        style: TextStyle(
                                          color: stepData?['color'] ?? Colors.green,
                                          fontFamily: 'monospace',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          line.substring(2),
                                          style: TextStyle(
                                            color: stepData?['color'] ?? Colors.green,
                                            fontFamily: 'monospace',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      if (index == _terminalLogs.length - 1 && _progress < 1.0)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                stepData?['color'] ?? Colors.pink,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }),
                              
                              // Cursor animation
                              if (_progress < 1.0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        '>',
                                        style: TextStyle(
                                          color: Colors.pink.shade300,
                                          fontFamily: 'monospace',
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      AnimatedBuilder(
                                        animation: _cursorController,
                                        builder: (context, child) {
                                          return Text(
                                            '$_currentAction█',
                                            style: TextStyle(
                                              color: Colors.pink.shade300.withOpacity(
                                                _cursorController.value,
                                              ),
                                              fontFamily: 'monospace',
                                              fontSize: 16,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '> system ready.█',
                                    style: TextStyle(
                                      color: Colors.green.shade400,
                                      fontFamily: 'monospace',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Progress bar section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.pink.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'AUTHENTICATION PROGRESS',
                                  style: TextStyle(
                                    color: Colors.purple.shade300,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  '${_terminalLogs.length}/${_bootSteps.length}',
                                  style: TextStyle(
                                    color: Colors.pink.shade300,
                                    fontSize: 10,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Progress bar
                            Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    return FractionallySizedBox(
                                      widthFactor: _progress,
                                      child: Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.purple,
                                              Colors.pink,
                                              Colors.cyan,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.pink.withOpacity(0.5),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Status text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'STATUS:',
                                  style: TextStyle(
                                    color: Colors.purple.shade300,
                                    fontSize: 10,
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    String status = _progress < 1.0 
                                        ? 'AUTHENTICATING' 
                                        : 'REDIRECTING';
                                    
                                    return Text(
                                      status,
                                      style: TextStyle(
                                        color: _progress < 1.0 
                                            ? Colors.pink 
                                            : Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
