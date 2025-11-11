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

class _ListStoryScreenState extends State<ListStoryScreen> with RouteAware {
  final ScrollController scrollcontroller = ScrollController();
  @override
  void dispose() {
    scrollcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Logger().d("init diapnggil");
    scrollcontroller.addListener(() {
      final maxscroll = scrollcontroller.position.maxScrollExtent;

      final isbottoms = scrollcontroller.position.pixels >= maxscroll;

      if (isbottoms) {
        Logger().d("sudah sampai bawah");
        if (context.read<StoryProvider>().pageitemlist == null) return;
        context.read<StoryProvider>().fetchdata();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!context.mounted) return;
      final storyprovider = context.read<StoryProvider>();
      storyprovider.setPageItemone();
      storyprovider.fetchdata();
    });
  }

  Future<void> onrefresh() async {
    final storyprovider = context.read<StoryProvider>();
    storyprovider.setPageItemone();
    await storyprovider.fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onrefresh,
          child: CustomScrollView(
            controller: scrollcontroller,
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
                      itemCount:
                          value.datastory!.liststory.length +
                          ((value.pageitemlist != null) ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == value.datastory!.liststory.length &&
                            value.pageitemlist != null) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return ListStoryItem(
                          data: value.datastory!.liststory[index],
                          onitemtap: (id) {
                            widget.itemtap(id);
                          },
                        );
                      },
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
