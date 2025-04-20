// Layar dengan tombol ON/OFF
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class RefillScreen extends StatefulWidget {
  const RefillScreen({super.key});

  @override
  State<RefillScreen> createState() => _RefillScreenState();
}

class _RefillScreenState extends State<RefillScreen> {
  bool _isServiceRunning = false;
  final FlutterBackgroundService _service = FlutterBackgroundService();

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
  }

  void _checkServiceStatus() async {
    final isRunning = await _service.isRunning();
    setState(() {
      _isServiceRunning = isRunning;
    });
  }

  void _toggleService(bool start) async {
    if (start) {
      await _service.startService();
    } else {
      _service.invoke('stopService');
    }

    // Beri waktu untuk service memulai/berhenti
    await Future.delayed(const Duration(milliseconds: 500));
    _checkServiceStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kontrol Background Service')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status service
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    _isServiceRunning
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _isServiceRunning ? 'Service Aktif' : 'Service Tidak Aktif',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      _isServiceRunning
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol ON/OFF
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol ON
                ElevatedButton(
                  onPressed:
                      _isServiceRunning ? null : () => _toggleService(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text('ON', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 40),

                // Tombol OFF
                ElevatedButton(
                  onPressed:
                      _isServiceRunning ? () => _toggleService(false) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text('OFF', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
