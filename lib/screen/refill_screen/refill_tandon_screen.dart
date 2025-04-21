// Layar dengan tombol ON/OFF
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:iot_plant_control/widgets/refill_tandon_widget/refill_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefillTandonScreen extends StatefulWidget {
  const RefillTandonScreen({super.key});

  @override
  State<RefillTandonScreen> createState() => _RefillTandonScreenState();
}

class _RefillTandonScreenState extends State<RefillTandonScreen> {
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFull', false);
      await _service.startService();
    } else {
      _service.invoke('stopService');
    }

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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
            const SizedBox(height: 20),
            // Tombol untuk menampilkan notifikasi kustom (opsional)
            ElevatedButton(
              onPressed: () => showPengisianTandonNotification(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text('Tampilkan Notifikasi Kustom'),
            ),
          ],
        ),
      ),
    );
  }
}
