import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_auth.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/router/myrouter_delegate.dart';
import 'package:story_app/theme/theme.dart';
import 'package:story_app/theme/util.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => Apiauth()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(apiauth: context.read<Apiauth>()),
        ),
        ChangeNotifierProvider(
          create: (context) => MyrouterDelegate(
            navigatorkeys: GlobalKey<NavigatorState>(),
            authprovider: context.read<AuthProvider>(),
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto Flex");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: Router(
        routerDelegate: context.read<MyrouterDelegate>(),
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
