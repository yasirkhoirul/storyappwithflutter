import 'package:flutter/material.dart';
import 'package:logger/web.dart';

import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/screen/detail_screen.dart';

import 'package:story_app/screen/list_story_screen.dart';
import 'package:story_app/screen/login_screen.dart';
import 'package:story_app/screen/mapscreen.dart';
import 'package:story_app/screen/signup_screen.dart';
import 'package:story_app/screen/upload_screen.dart';

class MyrouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final AuthProvider authprovider;
  final GlobalKey<NavigatorState> navigatorkeys;
  void init() async {
    await authprovider.loadDatalogin();
    isalreadylogin = authprovider.datalogin != null;
    notifyListeners();
  }

  MyrouterDelegate({required this.navigatorkeys, required this.authprovider}) {
    Future.microtask(() => init());
  }

  bool islogin = false;
  bool gosignup = false;
  bool goupload = false;
  bool godetail = false;
  bool gomap = false;
  String? iddetail;
  bool isalreadylogin = false;
  List<Page> page = [];
  List<Page> get isalreadylogon => [
    MaterialPage(
      key: ValueKey("list_story"),
      child: ListStoryScreen(
        itemtap: (id) {
          godetail = true;
          iddetail = id;
          notifyListeners();
        },
        uploadtap: () {
          goupload = true;
          notifyListeners();
        },
        logoutap: () async {
          await authprovider.deleteDatalogin();
          isalreadylogin = authprovider.datalogin != null;
          islogin = false;
          notifyListeners();
        },
        
      ),
    ),
    if (goupload == true)
      MaterialPage(key: ValueKey("upload"), child: UploadScreen(
        onMap: (){
          gomap = true;
          notifyListeners();
        },
        onbacktomain: () {
          goupload = false;
          notifyListeners();
        },
      )),
    if (godetail == true && iddetail != null)
      MaterialPage(
        key: ValueKey("detail"),
        child: DetailScreen(id: iddetail),
      ),
    if (gomap == true) 
      MaterialPage(
        child: Mapscreen(onconfirm: () { 
          gomap = false;
          notifyListeners();
         },),
        key: ValueKey("maps")),
  ];
  List<Page> get isnotlogin => [
    MaterialPage(
      key: ValueKey("loginscreen"),
      child: LoginScreen(
        signintap: (data) async {
          islogin = true;
          isalreadylogin = authprovider.datalogin != null;
          notifyListeners();
        },
        signuptap: () {
          gosignup = true;
          notifyListeners();
        },
      ),
    ),
    if (gosignup == true)
      MaterialPage(
        key: ValueKey("signup"),
        child: SignupScreen(
          tapsignup: () {
            notifyListeners();
          },
          gosignin: () async {
            Logger().d("masuk gosignin");
            islogin = true;
            await authprovider.loadDatalogin();
            isalreadylogin = authprovider.datalogin != null;
            Logger().d("data lginnya $isalreadylogin");
            notifyListeners();
          },
        ),
      ),
  ];
  @override
  Widget build(BuildContext context) {
    if (isalreadylogin) {
      page = isalreadylogon;
    } else {
      page = isnotlogin;
    }
    return Navigator(
      key: navigatorkeys,
      pages: page,
      onDidRemovePage: (page) {
        if (islogin && page.key == ValueKey("loginscreen")) {
          islogin = false;
          notifyListeners();
        }
        if (gosignup == true && page.key == ValueKey("signup")) {
          gosignup = false;

          notifyListeners();
        }
        if (goupload && page.key == ValueKey("upload")) {
          goupload = false;
          notifyListeners();
        }
        if (godetail && page.key == ValueKey("detail") && iddetail != null) {
          iddetail != null;
          godetail = false;
          notifyListeners();
        }
        if (gomap == true && page.key == ValueKey("maps")) {
          gomap = false;
          notifyListeners();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => navigatorkeys;
}
