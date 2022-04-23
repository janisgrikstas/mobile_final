import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userid;
 
 ProfilePage({required this.userid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('janis grikstas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("this is the bio"),
      ),
    );
  }
}
