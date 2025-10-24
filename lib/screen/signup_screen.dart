import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget{
  final void Function() tapsignup;
  const SignupScreen({super.key,required this.tapsignup});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
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
                            Text("Signup", style: font.displayMedium!.copyWith(fontWeight: FontWeight.bold)),
                            Text("selamat datang silahkan masukkan password dan email untuk membuat akun",style: font.titleSmall,textAlign: TextAlign.center,),
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
                            label: const Text("password"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: widget.tapsignup,
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
  }
}