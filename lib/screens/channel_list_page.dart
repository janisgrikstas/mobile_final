// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stremio/screens/profile_scrren.dart';

import 'channel_page.dart';

class ChannelListPage extends StatefulWidget {
  final Channel channel;

  const ChannelListPage(this.channel);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Stream Chat'),
        ),
        body: ChannelsBloc(
      child: ChannelListView(
        filter: Filter.in_('members', [StreamChat.of(context).user!.id]),
        sort: [SortOption('last_message_at')],
        pagination: PaginationParams(limit: 30),
        channelWidget: Builder(
          builder: (context) => ChannelPage(widget.channel),
        ),
      ),
    ),
        bottomNavigationBar:BottomAppBar(
          child: Row(
            children: [
              IconButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>ProfilePage(userid: "janisgrikstas")
                  ));},
               icon: Icon(Icons.person),
               )

            ],//children
          )
        )
        );
  }

  
}

