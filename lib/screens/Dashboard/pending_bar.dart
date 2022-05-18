import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/provider.dart';
import 'package:weqaya/screens/Doctor/doctorsPending.dart';
import 'package:weqaya/screens/MedicalPosts/pendingPosts.dart';
import 'package:weqaya/components/stuff.dart';
import 'dashboard_module.dart';


class PendingBar extends StatefulWidget {
  const PendingBar({Key? key}) : super(key: key);
  @override
  _PendingBarState createState() => _PendingBarState();
}

class _PendingBarState extends State<PendingBar> {

  String pageName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Provider.of<SettingProvider>(context).menus.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(pageName),
          bottom: TabBar(
            unselectedLabelColor: Env.appColor,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: Provider.of<SettingProvider>(context).menus.map<Widget>((MenuModel menu){
              return Tab(
                iconMargin: EdgeInsets.zero,
                text: menu.short,
                icon: CachedNetworkImage(
                  imageUrl: menu.icon,
                  height: 25, width: 25,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress, color: Env.appColor,),
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: Provider.of<SettingProvider>(context).menus.map((MenuModel menu) {
            switch(menu.short){
              case "معلومات":
                return const PendingPosts();
              case "داکتران":
                return const PendingDoctors();
              default:
                return const Center(child: Text("No Pending "));
            }

          }).toList(),
      ),
    ),
    );
  }
}

