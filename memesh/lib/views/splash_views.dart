import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memesh/controllers/auth_controllers.dart';
import 'package:memesh/widgets/matrix_rain.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _cursorController;
  
  List<String> _terminalLogs = [];
  double _progress = 0.0;
  String _currentAction = 'initializing system...';
  int _step = 0;
  
  final List<Map<String, dynamic>> _bootSteps = [
    {'text': '> mounting root filesystem...', 'progress': 0.07, 'color': Colors.cyan},
    {'text': '> loading kernel modules...', 'progress': 0.15, 'color': Colors.yellow},
    {'text': '> initializing network interfaces...', 'progress': 0.22, 'color': Colors.orange},
    {'text': '> starting memesh protocol...', 'progress': 0.30, 'color': Colors.purple},
    {'text': '> establishing secure connection...', 'progress': 0.38, 'color': Colors.blue},
    {'text': '> verifying identity...', 'progress': 0.45, 'color': Colors.indigo},
    {'text': '> loading user preferences...', 'progress': 0.53, 'color': Colors.pink},
    {'text': '> initializing matrix rain...', 'progress': 0.60, 'color': Colors.green},
    {'text': '> starting background services...', 'progress': 0.68, 'color': Colors.teal},
    {'text': '> configuring firewall...', 'progress': 0.75, 'color': Colors.amber},
    {'text': '> loading encrypted modules...', 'progress': 0.82, 'color': Colors.deepPurple},
    {'text': '> synchronizing time...', 'progress': 0.88, 'color': Colors.lightBlue},
    {'text': '> finalizing boot sequence...', 'progress': 0.95, 'color': Colors.lightGreen},
    {'text': '> system ready.', 'progress': 1.00, 'color': Colors.green},
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
      duration: const Duration(seconds: 15),
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    
    _progressController.addListener(() {
      setState(() {
        _progress = _progressController.value;
      });
    });
    
    _progressController.forward();
    
    // Mulai boot sequence
    _startBootSequence();
    
    // Setelah 15 detik, cek auth state
    Timer(const Duration(seconds: 15), () {
      _checkAuthAndNavigate();
    });
  }
  
  void _startBootSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    for (int i = 0; i < _bootSteps.length; i++) {
      final step = _bootSteps[i];
      
      setState(() {
        _terminalLogs.add(step['text']);
        _step = i;
        _currentAction = step['text'].replaceFirst('> ', '');
      });
      
      // Tunggu sesuai progress
      if (i < _bootSteps.length - 1) {
        final nextProgress = _bootSteps[i + 1]['progress'] as double;
        final currentProgress = step['progress'] as double;
        final waitTime = ((nextProgress - currentProgress) * 15000).toInt();
        await Future.delayed(Duration(milliseconds: waitTime));
      } else {
        await Future.delayed(const Duration(milliseconds: 800));
      }
    }
  }

  void _checkAuthAndNavigate() {
    if (_authController.isAuthenticated) {
      Get.offAllNamed('/main');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  Color _getProgressColor() {
    if (_progress < 0.3) return Colors.cyan;
    if (_progress < 0.6) return Colors.purple;
    if (_progress < 0.9) return Colors.pink;
    return Colors.green;
  }

  String _getProgressText() {
    return '${(_progress * 100).toStringAsFixed(0)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Matrix Rain Background
          const MatrixRain(speed: 50),

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

          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.purple, Colors.pink, Colors.cyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'MEMESH NETWORK',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'v2.0.1 // SECURE PROTOCOL',
                      style: TextStyle(
                        color: Colors.cyan.shade400.withOpacity(0.7),
                        fontSize: 14,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Terminal Window
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.pink.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900.withOpacity(0.8),
                              border: Border.all(
                                color: Colors.pink.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Terminal header
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
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
                                      Expanded(
                                        child: Text(
                                          'memesh@boot:~ system_init.sh',
                                          style: TextStyle(
                                            color: Colors.pink.shade300.withOpacity(0.8),
                                            fontSize: 12,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ),
                                      Text(
                                        _getProgressText(),
                                        style: TextStyle(
                                          color: _getProgressColor(),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Terminal content
                                Container(
                                  height: 300,
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
                                            padding: const EdgeInsets.only(bottom: 6),
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
                                                if (index == _step && _progress < 0.99)
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
                                        
                                        // Cursor berkedip
                                        if (_progress < 0.99)
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
                                
                                // Progress bar
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
                                            'BOOT SEQUENCE',
                                            style: TextStyle(
                                              color: Colors.purple.shade300,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          Text(
                                            '${_step + 1}/${_bootSteps.length}',
                                            style: TextStyle(
                                              color: Colors.pink.shade300,
                                              fontSize: 10,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Stack(
                                        children: [
                                          Container(
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade800,
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                          ),
                                          AnimatedBuilder(
                                            animation: _progressAnimation,
                                            builder: (context, child) {
                                              return FractionallySizedBox(
                                                widthFactor: _progress,
                                                child: Container(
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      colors: [
                                                        Colors.purple,
                                                        Colors.pink,
                                                        Colors.cyan,
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.circular(3),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.pink,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Loading text
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return Text(
                          _progress < 1.0 
                              ? 'Initializing secure environment...'
                              : 'Redirecting to memesh network...',
                          style: TextStyle(
                            color: Colors.pink.shade300.withOpacity(0.8),
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
