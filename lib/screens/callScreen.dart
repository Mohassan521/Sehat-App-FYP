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
    client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            appId: "f0d047423fdc47d8aef33adad735395e",
            channelName: channelName,
            username: "user"));
    await client!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Stack(
        children: [
          AgoraVideoViewer(client: client!, layoutType: Layout.oneToOne,enableHostControls: true,),
          AgoraVideoButtons(client: client!, addScreenSharing: false,)
        ],
      )),
    );
  }
}
