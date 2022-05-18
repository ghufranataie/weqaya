import 'package:flutter/material.dart';
import 'package:weqaya/components/mainDrawer.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ghufran Ataie"),
        centerTitle: true,
      ),
      endDrawer: const MainDrawer(),
    );
  }
}
