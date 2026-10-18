import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  final String difficulty;

  const QuizScreen({Key? key, required this.category, required this.difficulty})
      : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isFlashOn = false;
  bool _isFrontCamera = false;

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFlashOn ? 'Flash turned ON' : 'Flash turned OFF'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _switchCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFrontCamera
            ? 'Switched to Front Camera'
            : 'Switched to Back Camera'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _simulateScanResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanned!'),
        content: Text(
            'Successfully scanned quiz code!\nCategory: ${widget.category}\nDifficulty: ${widget.difficulty}'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A)),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to Dashboard
            },
            child: const Text('Proceed to Quiz',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${widget.category} Scanner (${widget.difficulty})'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        actions: [
          // Flash Button
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
            tooltip: 'Toggle Flash',
          ),
          // Change Camera Button
          IconButton(
            icon: Icon(_isFrontCamera ? Icons.camera_front : Icons.camera_rear),
            onPressed: _switchCamera,
            tooltip: 'Switch Camera',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Mock Camera Background (You can integrate mobile_scanner or qr_code_scanner here)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade900,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                    size: 60,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isFrontCamera
                        ? 'Front Camera Active'
                        : 'Back Camera Active',
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Center Scanner Viewfinder Box
          Center(
            child: GestureDetector(
              onTap:
                  _simulateScanResult, // Tap box to simulate a successful scan for testing
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        const Color(0xFFA3E635), // Lime green viewfinder border
                    width: 3.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                ),
                child: Stack(
                  children: [
                    // Corner accents for professional scanner look
                    Positioned(top: 8, left: 8, child: _buildCornerLine()),
                    Positioned(top: 8, right: 8, child: _buildCornerLine()),
                    Positioned(bottom: 8, left: 8, child: _buildCornerLine()),
                    Positioned(bottom: 8, right: 8, child: _buildCornerLine()),

                    const Center(
                      child: Text(
                        'Align QR Code / Barcode\ninside the box',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Instruction & Cancel Button
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                const Text(
                  'Point your camera at the U-Trivia QR code or station barcode.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red.shade600, // Red cancel button as requested
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerLine() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white, width: 3),
          left: BorderSide(color: Colors.white, width: 3),
        ),
      ),
    );
  }
}
