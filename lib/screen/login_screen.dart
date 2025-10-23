import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final void Function() signintap;
  const LoginScreen({super.key, required this.signintap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 1000,
              minHeight: 800,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Center(
                      child: CircleAvatar(
                        radius: 150,
                        child: Icon(Icons.person, size: 150),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Login", style: font.displayMedium!.copyWith(fontWeight: FontWeight.bold)),
                            Text("selamat datang silahkan masukkan password dan email",style: font.titleSmall,),
                          ],
                        ),
                        SizedBox(height: 20,),
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
                          controller: password,
                          decoration: InputDecoration(
                            label: const Text("passowrd"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: widget.signintap,
                          child: const Text("Signin"),
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
  }
}
