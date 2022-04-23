import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'screens/channel_list_page.dart';
import 'secrets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamChatClient(
    STREAM_KEY,
    logLevel: Level.OFF,
  );

  const USER_ID = 'johnsmith';

  await client.connectUser(
    User(
      id: USER_ID,
      extraData: {
        'name': 'John Smith',
        'image': '<https://i.pravatar.cc/150?img=8>',
        'wallet_id': 'ewallet_04f995b6017211d0c147b5f226abc184',
      },
    ),
    USER_TOKEN,
  );

  final channel = client.channel('messaging', id: 'p2p-payment');
  await channel.watch();

  runApp(MyApp(client, channel));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;
  final Channel channel;

  MyApp(this.client, this.channel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        return StreamChat(
          child: widget!,
          client: client,
        );
      },
      debugShowCheckedModeBanner: false,
      home: ChannelListPage(channel),
    );
  }
}