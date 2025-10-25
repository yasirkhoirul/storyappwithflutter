import 'package:flutter/material.dart';

import 'package:story_app/provider/auth_provider.dart';

import 'package:story_app/screen/list_story_screen.dart';
import 'package:story_app/screen/login_screen.dart';
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
  bool isalreadylogin = false;
  List<Page> page = [];
  List<Page> get isalreadylogon => [
    MaterialPage(
      key: ValueKey("list_story"),
      child: ListStoryScreen(
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
      MaterialPage(key: ValueKey("upload"), child: UploadScreen()),
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
