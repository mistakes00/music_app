import 'package:flutter/material.dart';
import 'package:music_app/constants/app_color.dart';

import '../../model/music_model.dart';
import 'widget/neumorphism_button.dart';

class PlayerListScreen extends StatefulWidget {
  PlayerListScreen({Key? key, required this.selectedIndex}) : super(key: key);
  final int selectedIndex;
  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  late int selectedIndex;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calculateScrollPossition(scrollController);
    });
    super.initState();
  }

  calculateScrollPossition(ScrollController scrollController) {
    int totalLength = musicList.length;
    final maxScroll = scrollController.position.maxScrollExtent;
    scrollController.animateTo(maxScroll / totalLength * selectedIndex,
        duration: Duration(milliseconds: 10), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Flume Kai'.toUpperCase(),
              style: const TextStyle(
                color: AppColor.secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: size.height * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NeumorphismBtn(
                    onPressed: () {
                      Navigator.pop(context, selectedIndex);
                    },
                    size: 60,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColor.secondaryTextColor,
                    ),
                  ),
                  NeumorphismBtn(
                    size: size.width * 0.45,
                    padding: 8,
                    distance: 20,
                    imageUrl: musicList[selectedIndex].imageUrl,
                  ),
                  NeumorphismBtn(
                    size: 60,
                    child: Icon(
                      musicList[selectedIndex].isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppColor.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: musicList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: selectedIndex == index
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:
                                  AppColor.secondaryTextColor.withOpacity(0.3))
                          : null,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                musicList[index].name,
                                style: const TextStyle(
                                    color: AppColor.primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                musicList[index].artist,
                                style: const TextStyle(
                                    color: AppColor.secondaryTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                          selectedIndex == index
                              ? const NeumorphismBtn(
                                  size: 50,
                                  colors: [AppColor.blueTopDark, AppColor.blue],
                                  child: Icon(
                                    Icons.pause,
                                    color: AppColor.secondaryTextColor,
                                  ),
                                )
                              : const NeumorphismBtn(
                                  size: 50,
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: AppColor.white,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
