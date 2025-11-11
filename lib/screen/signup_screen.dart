import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';

class SignupScreen extends StatefulWidget {
  final void Function(Status) status;
  final void Function() tapsignup;
  final void Function() gosignin;
  const SignupScreen({
    super.key,
    required this.tapsignup,
    required this.gosignin,
    required this.status,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool hidepassword = true;
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<AuthProvider>();
    provider.addListener(_listenerstate);
  }

  void _listenerstate() {
    if (!context.mounted) return;
    final state = context.read<AuthProvider>().status;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!context.mounted) return;
      if (state is Isloading) {
        widget.status(state);
      }
      if (state is Isuksessignup) {
        widget.status(state);
        widget.gosignin();
        context.read<AuthProvider>().setidlelogin();
      }
      if (state is IsError) {
        widget.status(state);
      }
    });
  }

  @override
  void dispose() {
    context.read<AuthProvider>().removeListener(_listenerstate);
    email.dispose();
    password.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 1000, minHeight: 800),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: CircleAvatar(
                            radius: 150,
                            child: Icon(Icons.person, size: 150),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Signup",
                                  style: font.displayMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "selamat datang silahkan masukkan password dan email untuk membuat akun",
                                  style: font.titleSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: username,
                              decoration: InputDecoration(
                                label: const Text("username"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            TextField(
                              controller: email,
                              decoration: InputDecoration(
                                label: const Text("email"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            TextField(
                              obscureText: hidepassword,
                              controller: password,
                              decoration: InputDecoration(
                                suffix: InkWell(
                                  onTap: () => setState(() {
                                    hidepassword = !hidepassword;
                                  }),
                                  child: hidepassword
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                ),
                                label: const Text("password"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () async {
                                Logger().d(
                                  "tombol signup ditekan dengan ${email.text}",
                                );
                                widget.tapsignup();
                                await value.signup(
                                  email.text,
                                  password.text,
                                  username.text,
                                );
                                Logger().d("tombol signup selesai ditekan");
                              },
                              child: const Text("Signup"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
