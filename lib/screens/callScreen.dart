// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatefulWidget {
  final String? channelName;
  final String user_id;
  final String user_name;
  // final ClientRoleType? role;
  const CallScreen(
      {super.key,
      this.channelName,
      required this.user_id,
      required this.user_name});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  // AgoraClient? client;

  @override
  void initState() {
    // TODO: implement initState
    // initAgora(widget.channelName!);
    super.initState();
  }

  // void initAgora(String channelName) async {
  //   // f0d047423fdc47d8aef33adad735395e
  //   // 007eJxTYPAuiyr48+po39k4p5tuYYs0GoKk5l+6HVtzJKRZcs8xtUsKDGkGKQYm5iZGxmkpySbmKRaJqWnGxokpiSnmxqbGlqap399uSG8IZGRQbZNgYIRCEJ+PIb8oJbWoOD45IzEvLzWHgQEAM/AlTg==
  //   // UbitKU12#$
  //   client = AgoraClient(
  //       agoraConnectionData: AgoraConnectionData(
  //           appId: "f0d047423fdc47d8aef33adad735395e",
  //           channelName: channelName,
  //           username: "user",
  //           tempToken:
  //               "007eJxTYJj3jt0q4Z4o46NTbhUrXnxyWt9xwJHheqx5Ud2Z/iqOI2sUGNIMUgxMzE2MjNNSkk3MUywSU9OMjRNTElPMjU2NLU1TW3fvTW8IZGT4UxvIzMgAgSA+H0N+UUpqUXF8ckZiXl5qDgMDAAuHJUE="));
  //   await client!.initialize();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SafeArea(
    //       child: Stack(
    //     children: [
    //       // AgoraVideoViewer(
    //       //   client: client!,
    //       //   layoutType: Layout.grid,
    //       //   enableHostControls: true,
    //       // ),
    //       // AgoraVideoButtons(
    //       //   client: client!,
    //       //   addScreenSharing: false,
    //       // )
    //     ],
    //   )),
    // );
    // 841b410390ea76e67d24f94cb7832fac897962422bd23d70f3297a14801c0494
    return ZegoUIKitPrebuiltCall(
        appID: 1261986953,
        appSign:
            "841b410390ea76e67d24f94cb7832fac897962422bd23d70f3297a14801c0494",
        callID: widget.channelName!,
        userID: widget.user_id,
        userName: widget.user_name,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  }
}
