import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/status_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/widget/list_story_item.dart';

class ListStoryScreen extends StatefulWidget {
  final void Function() uploadtap;
  final void Function() logoutap;
  final Function(String id) itemtap;
  const ListStoryScreen({
    super.key,
    required this.uploadtap,
    required this.logoutap,
    required this.itemtap,
  });

  @override
  State<ListStoryScreen> createState() => _ListStoryScreenState();
}

class _ListStoryScreenState extends State<ListStoryScreen> {
  @override
  void initState() {
    super.initState();
    Logger().d("init diapnggil");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!context.mounted) return;
      context.read<StoryProvider>().fetchdata();
    });
  }

  Future<void> onrefresh() async {
    await context.read<StoryProvider>().fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onrefresh,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: widget.uploadtap,
                    icon: Icon(Icons.upload),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.logoutap();
                      context.read<AuthProvider>().status = IsIdle();
                    },
                    icon: Icon(Icons.logout),
                  ),
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
              Consumer<StoryProvider>(
                builder: (context, value, child) {
                  return switch (value.status) {
                    Isloading() => SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    IsError(message: var message) => SliverToBoxAdapter(
                      child: Center(child: Text(message)),
                    ),
                    Issuksesmessage() => SliverList.builder(
                      itemCount: value.datastory?.liststory.length ?? 0,
                      itemBuilder: (context, index) => ListStoryItem(
                        data: value.datastory!.liststory[index],
                        onitemtap: (id) {
                          widget.itemtap(id);
                        },
                      ),
                    ),
                    _ => SliverToBoxAdapter(child: Container()),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
