import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String? pageName;
  const CustomAppBar({Key? key, this.pageName = "وقایه"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text( pageName!, style: const TextStyle(fontSize: 20, color: Colors.white),),
      elevation: 2,
      centerTitle: true,
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
