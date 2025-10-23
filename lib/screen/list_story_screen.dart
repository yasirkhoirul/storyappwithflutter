import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:story_app/widget/list_story_item.dart';

class ListStoryScreen extends StatelessWidget {
  const ListStoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              title: Text("Story", style: font.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
              flexibleSpace: FlexibleSpaceBar(
                
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/lottie/news.json",width: 200,height: 200),
                    const Text("Selamat Datang Di Halaman Story")
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
