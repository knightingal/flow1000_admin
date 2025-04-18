import 'dart:convert';
import 'dart:developer';

import 'package:flow1000_admin/album_content.dart';
import 'package:flow1000_admin/scroll.dart';
import 'package:flow1000_admin/struct/album_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'struct/slot.dart';

class AlbumIndexPage extends StatefulWidget {
  const AlbumIndexPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return AlbumIndexState();
  }
}

class AlbumIndexState extends State<AlbumIndexPage> {
  late double width;
  Future<List<AlbumInfo>> fetchAlbumIndex() async {
    final response = await http.get(Uri.parse(albumIndexUrl()));
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = jsonDecode(response.body);
      List<AlbumInfo> albumInfoList =
          jsonArray.map((e) => AlbumInfo.fromJson(e)).toList();
      return albumInfoList;
    } else {
      throw Exception("Failed to load album");
    }
  }

  List<AlbumInfo> albumInfoList = [];
  late List<Slot> slot;

  final int coverPadding = 8;

  @override
  void initState() {
    super.initState();
    fetchAlbumIndex().then((albumInfoList) {
      var length = (width > 1500) ? 8 : 4;
      slot = List.generate(length, (index) => Slot(), growable: false);
      for (int i = 0; i < albumInfoList.length; i++) {
        AlbumInfo albumInfo = albumInfoList[i];
        double coverWidth = width / slot.length - coverPadding;
        double coverHeight =
            albumInfo.coverHeight * (coverWidth / albumInfo.coverWidth);
        // log("coverHeight:$coverHeight, coverWidth:$coverWidth");
        albumInfo.realHeight = coverHeight;
        albumInfo.realWidth = coverWidth;

        albumInfo.frameWidth = width / slot.length;
        albumInfo.frameHeight = albumInfo.realHeight + coverPadding;

        int slotIndex = minSlot(slot);
        Slot slotOne = slot[slotIndex];
        slotOne.slotItemList.add(
          SlotItem(i, slotOne.totalHeight, albumInfo.frameHeight, slotIndex),
        );
        slotOne.totalHeight = slotOne.totalHeight + albumInfo.frameHeight;
      }
      setState(() {
        this.albumInfoList = albumInfoList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    Widget body;
    if (albumInfoList.isEmpty) {
      body = Text("AlbumIndexPage");
    } else {
      body = CustomScrollViewExample(
        slots: slot,
        builder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AlbumContentPage(
                        albumIndex: albumInfoList[index].index,
                      ),
                ),
              );
            },
            child: SizedBox.fromSize(
              size: Size(
                albumInfoList[index].realWidth,
                albumInfoList[index].realHeight,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  key: Key("image-$index"),
                  albumInfoList[index].toCoverUrl(),
                  width: albumInfoList[index].realWidth,
                  height: albumInfoList[index].realHeight,
                ),
              ),
            ),
          );
        },
        totalLength: albumInfoList.length,
      );
    }
    return body;
  }
}

class DirItem extends StatelessWidget {
  final String title;

  final int index;
  final void Function(int index, String title) tapCallback;

  const DirItem({
    super.key,
    required this.index,
    required this.title,
    required this.tapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        log("click $title");
        tapCallback(index, title);
      },
      title: Text(title),
    );
  }
}
