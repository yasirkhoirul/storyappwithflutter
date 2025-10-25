import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:story_app/widget/list_story_item.dart';

class ListStoryScreen extends StatelessWidget {
  final void Function() uploadtap;
  final void Function() logoutap;
  const ListStoryScreen({
    super.key,
    required this.uploadtap,
    required this.logoutap,
  });
  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(onPressed: uploadtap, icon: Icon(Icons.upload)),
                IconButton(onPressed: () {
                  logoutap();
                  context.read<AuthProvider>().status = IsIdle();
                }, icon: Icon(Icons.logout)),
              ],
              expandedHeight: 300,
              pinned: true,
              title: Text(
                "Story",
                style: font.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lottie/news.json",
                      width: 200,
                      height: 200,
                    ),
                    const Text("Selamat Datang Di Halaman Story"),
                  ],
                ),
              ),
            ),
            SliverList.builder(
              itemCount: 3,
              itemBuilder: (context, index) => ListStoryItem(),
            ),
          ],
        ),
      ),
    );
  }
}
