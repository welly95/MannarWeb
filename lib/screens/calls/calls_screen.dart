import 'package:flutter/material.dart';
import '../../screens/calls/video_call_screen.dart';
import '../../screens/calls/voice_call_screen.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.withOpacity(0.8),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(backgroundColor: Colors.blueGrey, elevation: 4),
              child: Text(
                'Video Call',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoCallScreen(),
                  ),
                );
              },
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(backgroundColor: Colors.blueGrey, elevation: 4),
              child: Text(
                'Voice Call',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VoiceCallScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
