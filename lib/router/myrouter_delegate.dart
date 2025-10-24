import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';
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
  late bool isalreadylogin;
  List<Page> page = [];
  @override
  Widget build(BuildContext context) {
    if (isalreadylogin) {
      page = [
        MaterialPage(
          key: ValueKey("list_story"),
          child: ListStoryScreen(
            uploadtap: () {
              goupload = true;
              
              notifyListeners();
            },
            logoutap: () async{
              await authprovider.deleteDatalogin();
              isalreadylogin = authprovider.datalogin != null;
              if(!context.mounted)return;
              context.read<AuthProvider>().status = IsIdle();
              islogin = false;
              notifyListeners();
            },
          ),
        ),
        if (goupload == true)
          MaterialPage(key: ValueKey("upload"), child: UploadScreen()),
      ];
    }else{
      page = [
        MaterialPage(
          key: ValueKey("loginscreen"),
          child: LoginScreen(
            signintap: (data) async{
              islogin = true;
              isalreadylogin = authprovider.datalogin != null;
              if(!context.mounted) return;
              context.read<AuthProvider>().status = IsIdle();
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
                gosignup = false;
                notifyListeners();
              },
            ),
          ),
      ];
    }
    return Navigator(
      key: navigatorkeys,
      pages: page,
      onDidRemovePage: (page) {
        if (islogin && page.key == ValueKey("loginscreen")) {
          islogin = false;
        }
        if (gosignup && page.key == ValueKey("signup")) {
          gosignup = false;
        }
        if (goupload && page.key == ValueKey("upload")) {
          goupload = false;
        }
        notifyListeners();
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
