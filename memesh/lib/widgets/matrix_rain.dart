import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MatrixRain extends StatefulWidget {
  final double speed; // Kecepatan jatuh (default: 30)
  final Color color; // Warna matrix (default: hijau)
  final double fontSize; // Ukuran font (default: 20)
  final int? maxColumns; // 🔴 UBAH: int → int? (biar bisa null)

  const MatrixRain({
    super.key,
    this.speed = 30,
    this.color = Colors.green,
    this.fontSize = 20,
    this.maxColumns, // 🔴 UBAH: gak pake required
  });

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain> with SingleTickerProviderStateMixin {
  late List<RainDrop> _rainDrops;
  late Timer _timer;
  late Random _random;
  int _columnCount = 0;
  
  // Karakter matrix (katakana + angka + simbol)
  final String _chars = '01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン';

  @override
  void initState() {
    super.initState();
    _random = Random();
    _initRainDrops();
    
    // Update setiap 50ms untuk animasi
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) { // 🔴 TAMBAH: cek mounted
        setState(() {
          for (var drop in _rainDrops) {
            drop.update();
          }
        });
      }
    });
  }

  void _initRainDrops() {
    // Hitung jumlah kolom berdasarkan lebar layar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final screenWidth = MediaQuery.of(context).size.width;
        final calculatedColumns = (screenWidth / widget.fontSize).floor();
        
        setState(() {
          _columnCount = widget.maxColumns ?? calculatedColumns;
          _rainDrops = List.generate(_columnCount, (index) {
            return RainDrop(
              column: index,
              speed: widget.speed,
              random: _random,
              fontSize: widget.fontSize,
              chars: _chars,
            );
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_rainDrops.isEmpty) {
      return const SizedBox.expand();
    }

    return SizedBox.expand(
      child: CustomPaint(
        painter: MatrixRainPainter(
          rainDrops: _rainDrops,
          color: widget.color,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }
}

class RainDrop {
  int column;
  double y;
  double speed;
  int length;
  late List<int> charIndexes; // 🔴 UBAH: pake 'late' karena diinisialisasi di method
  Random random;
  double fontSize;
  String chars;

  RainDrop({
    required this.column,
    required this.speed,
    required this.random,
    required this.fontSize,
    required this.chars,
  })  : y = random.nextDouble() * -1000, // Mulai dari atas
        length = random.nextInt(15) + 5 { // Panjang tetesan 5-20 karakter
    _generateChars();
  }

  void _generateChars() {
    charIndexes = List.generate(length, (index) {
      return random.nextInt(chars.length);
    });
  }

  void update() {
    // Gerakkan ke bawah
    y += speed;
    
    // Reset kalau sudah keluar layar
    if (y > 2000) {
      y = -100 * random.nextDouble();
      _generateChars();
    }
  }
}

class MatrixRainPainter extends CustomPainter {
  final List<RainDrop> rainDrops;
  final Color color;
  final double fontSize;
  final TextPainter _textPainter;

  MatrixRainPainter({
    required this.rainDrops,
    required this.color,
    required this.fontSize,
  }) : _textPainter = TextPainter(
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );

  @override
  void paint(Canvas canvas, Size size) {
    for (var drop in rainDrops) {
      final x = drop.column * fontSize;
      
      for (int i = 0; i < drop.charIndexes.length; i++) {
        final y = drop.y - (i * fontSize);
        
        // Hanya gambar yang ada di layar
        if (y > -fontSize && y < size.height + fontSize) {
          final charIndex = drop.charIndexes[i];
          final char = drop.chars[charIndex];
          
          // Opacity gradient (atas terang, bawah gelap)
          double opacity;
          if (i == 0) {
            opacity = 1.0; // Karakter pertama paling terang
          } else {
            opacity = max(0.1, 1.0 - (i * 0.15));
          }
          
          final textColor = color.withOpacity(opacity);
          
          _textPainter.text = TextSpan(
            text: char,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          );
          
          _textPainter.layout();
          _textPainter.paint(canvas, Offset(x, y));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MatrixRainPainter oldDelegate) {
    return true; // Selalu repaint untuk animasi
  }
}
