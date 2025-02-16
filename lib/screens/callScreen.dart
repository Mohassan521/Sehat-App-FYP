// import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final String? channelName;
  // final ClientRoleType? role;
  const CallScreen({super.key, this.channelName});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraClient? client;

  @override
  void initState() {
    // TODO: implement initState
    initAgora(widget.channelName!);
    super.initState();
  }

  void initAgora(String channelName) async {
    // f0d047423fdc47d8aef33adad735395e
    // 007eJxTYPAuiyr48+po39k4p5tuYYs0GoKk5l+6HVtzJKRZcs8xtUsKDGkGKQYm5iZGxmkpySbmKRaJqWnGxokpiSnmxqbGlqap399uSG8IZGRQbZNgYIRCEJ+PIb8oJbWoOD45IzEvLzWHgQEAM/AlTg==
    // UbitKU12#$
    client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            appId: "f0d047423fdc47d8aef33adad735395e",
            channelName: channelName,
            username: "user",
            tempToken:
                "007eJxTYFDUrRK7xJVxhnXj6+kFLTkZ82adfSpcz7JPq7qYpSczerMCQ5pBioGJuYmRcVpKsol5ikViapqxcWJKYoq5samxpWmq5d2N6Q2BjAy+JhMYGKEQxOdjyC9KSS0qjk/OSMzLS81hYAAANnkiaw=="));
    await client!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          AgoraVideoViewer(
            client: client!,
            layoutType: Layout.grid,
            enableHostControls: true,
          ),
          AgoraVideoButtons(
            client: client!,
            addScreenSharing: false,
          )
        ],
      )),
    );
  }
}
