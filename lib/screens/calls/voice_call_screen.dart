// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/calls_settings.dart';
import '../../constants/size_config.dart';

class VoiceCallScreen extends StatefulWidget {
  const VoiceCallScreen({Key? key}) : super(key: key);

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  bool videoCall = false;
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;
  bool muted = false;
  bool speakerOn = false;

  late RtcEngine engine;

  void toggleSwitch(bool value) {
    if (videoCall == false) {
      setState(() {
        videoCall = true;
      });
    } else {
      setState(() {
        videoCall = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Get microphone permission
    await [Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext context = RtcEngineContext(APP_ID);
    engine = await RtcEngine.createWithContext(context);
    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        print('joinChannelSuccess $channel $uid ${elapsed.toString()}');
        setState(() {
          _joined = true;
        });
      },
      userJoined: (int uid, int elapsed) {
        print('userJoined $uid');
        setState(() {
          _remoteUid = uid;
        });
      },
      userOffline: (int uid, UserOfflineReason reason) {
        print('userOffline $uid');
        setState(() {
          _remoteUid = 0;
        });
      },
    ));
    // Join channel with channel name as 123
    await engine.joinChannel(Token, 'abc', null, 0);
  }

  Widget _toolbar() {
    // if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _speakerOn,
            child: Icon(
              speakerOn ? Icons.volume_up_sharp : Icons.volume_off_sharp,
              color: speakerOn ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: speakerOn ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    engine.muteLocalAudioStream(muted);
  }

  void _speakerOn() {
    setState(() {
      speakerOn = !speakerOn;
    });
    engine.setEnableSpeakerphone(speakerOn);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      top: false,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/profile_test.png',
            fit: BoxFit.fitHeight,
          ),
          Scaffold(
            backgroundColor: Colors.teal.withOpacity(0.8),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.05,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.03,
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.teal,
                        backgroundImage: AssetImage('assets/images/profile_test.png'),
                        radius: SizeConfig.screenWidth * 0.2,
                      ),
                    ),
                    Center(
                      child: Text(
                        'مريم أشرف',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                _toolbar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
