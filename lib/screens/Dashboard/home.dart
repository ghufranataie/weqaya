import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:weqaya/components/components.dart';
import 'package:weqaya/components/mainAppBar.dart';
import 'package:weqaya/screens/Doctor/docCategories.dart';
import 'package:weqaya/screens/LabTests/Tests.dart';
import 'package:weqaya/screens/MedicalPosts/medicalPostCategories.dart';
import 'package:weqaya/screens/Medicine/medicines.dart';
import 'package:weqaya/screens/Places/places.dart';
import 'package:weqaya/screens/QA/questions.dart';
import 'package:weqaya/components/stuff.dart';
import 'package:weqaya/components/mainDrawer.dart';
import 'package:weqaya/components/provider.dart';
import 'package:weqaya/screens/soon.dart';
import 'package:weqaya/screens/splash.dart';
import 'dashboard_module.dart';
import 'menu_services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Env env = Env();
  List<MenuModel> _menus = [];
  bool isLoggedIn = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<SettingProvider>(context, listen: false).setupMenus();
      Provider.of<SettingProvider>(context, listen: false).getUserID();
      Provider.of<SettingProvider>(context, listen: false).getUserRole();
    });
    _setupMenus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      mobile: _homeMobile(),
      tablet: _homeTablet(),
      web: _homeWeb(),
    );
  }

  Widget _homeMobile() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Env.appName, style: const TextStyle(fontSize: 20, color: Colors.white),),
          elevation: 2,
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
        ),
        endDrawer: const MainDrawer(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
            future: _setupMenus(),
            builder: (BuildContext context, snapshot) {
              return Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _menus.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(10),
                      //height: 90,
                      decoration: BoxDecoration(
                          color: Color(int.parse(_menus[index].color)),
                          //gradient: LinearGradient(colors: [Color(a), Color(b)]),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(23))),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListTile(
                          title: Text(
                            _menus[index].title,
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white),
                          ),
                          subtitle: Text(
                            _menus[index].slogan,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: CachedNetworkImage(
                                imageUrl: _menus[index].icon,
                                height: 45,
                                width: 45,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        const SpinKitCircle(
                                          //value: downloadProgress.progress,
                                          color: Colors.white,
                                        ),
                            ),
                          ),
                          onTap: () {
                            _navigateToPage(_menus[index].short);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ));
  }
  Widget _homeTablet() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Env.appName, style: const TextStyle(fontSize: 20, color: Colors.white),),
          elevation: 2,
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
        ),
        endDrawer: const MainDrawer(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: FutureBuilder(
            future: _setupMenus(),
            builder: (BuildContext context, snapshot) {
              return Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _menus.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(10),
                      //height: 90,
                      decoration: BoxDecoration(
                          color: Color(int.parse(_menus[index].color)),
                          //gradient: LinearGradient(colors: [Color(a), Color(b)]),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(23))),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListTile(
                          title: Text(
                            _menus[index].title,
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white),
                          ),
                          subtitle: Text(
                            _menus[index].slogan,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: CachedNetworkImage(
                                imageUrl: _menus[index].icon,
                                height: 45,
                                width: 45,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        const SpinKitCircle(
                                          //value: downloadProgress.progress,
                                          color: Colors.white,
                                        )),
                          ),
                          onTap: () {
                            _navigateToPage(_menus[index].short);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ));
  }
  Widget _homeWeb() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Env.appName, style: const TextStyle(fontSize: 20, color: Colors.white),),
        elevation: 2,
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
      ),
      endDrawer: const MainDrawer(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              const SizedBox(height: 30),
              Column(
                children: [
                  Image.asset("assets/icons/appLogo.png", height: 80, width: 80),
                  Text(Env.slogan, style: const TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 1001,
                  child: FutureBuilder(
                      future: _setupMenus(),
                      builder: (BuildContext context, snapshot) {
                        return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisExtent: 130,
                          ),
                          itemCount: _menus.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _navigateToPage(_menus[index].short),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 5.0,
                                margin: const EdgeInsets.all(10),
                                color: Color(int.parse(_menus[index].color)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: _menus[index].icon,
                                      height: 45,
                                      width: 45,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                          const SpinKitCircle(
                                            color: Colors.white,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      _menus[index].title,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/app-store.png", width: 120),
                      const SizedBox(width: 50),
                      Image.asset("assets/images/play-store.png", width: 120),
                      const SizedBox(width: 50),
                      Image.asset("assets/images/web-button.png", width: 120),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: const Text(
                          "َتماس با ما",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                        onTap: () => {},
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      InkWell(
                        child: const Text("َدر باره ما",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white)),
                        onTap: () => Env.goto(context, const Soon(pageName: "درباره ما",)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  void _navigateToPage(String menuName) {
    switch (menuName) {
      case 'معلومات':
        Env.goto(context, const PostCategory());
        break;
      case 'داکتران':
        Env.goto(context, const DoctorCategory());
        break;
      case 'پرسش':
        Env.goto(context, const Questions());
        break;
      case 'محل':
        Env.goto(context, const Places());
        break;
      case 'ادویه':
        Env.goto(context, const Medicines());
        break;
      case 'آزمایشات':
        Env.goto(context, const Tests());
        break;
      default:
        Env.goto(context, const Splash());
        break;
    }
  }

  Future _setupMenus() async {
    List<MenuModel> menus = await MenuServices.getMenus();
    _menus = menus;
  }
}
