import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/modelauth.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:story_app/widget/dialog.dart';

class LoginScreen extends StatefulWidget {
  final Function(LoginModel) signintap;
  final void Function() signuptap;
  const LoginScreen({
    super.key,
    required this.signintap,
    required this.signuptap,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  late AuthProvider authProvider;
  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    authProvider.addListener(_onstateschange);
    super.initState();
  }

  void _onstateschange() {
    final state = authProvider.status;

    switch (state) {
      case Isloading():
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (!context.mounted) return;
          showDialog(
            barrierDismissible: false,
            useRootNavigator: false,
            context: context,
            builder: (context) => StatusDialogManager(),
          );
        });
        break;
      case Isuccesslogin(data: var data):
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          authProvider.setidlelogin();
          widget.signintap(data);
        });
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    authProvider.removeListener(_onstateschange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final font = Theme.of(context).textTheme;
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
                    child: Consumer<AuthProvider>(
                      builder: (context, value, child) {
                        //artinya tutup semua halaman termasuk dialog hingga tersisa paling atas
                        return Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Login",
                                  style: font.displayMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "selamat datang silahkan masukkan password dan email",
                                  style: font.titleSmall,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: email,
                              decoration: InputDecoration(
                                label: const Text("Email"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            TextField(
                              obscureText: true,
                              controller: password,
                              decoration: InputDecoration(
                                label: const Text("password"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () async {
                                await auth.setemail(email.text);
                                await auth.setPassword(password.text);
                                await auth.login();
                                await auth.loadDatalogin();
                              },
                              child: const Text("Signin"),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Belum memiliki akun? "),
                                TextButton(
                                  onPressed: widget.signuptap,
                                  child: const Text("Daftar"),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
