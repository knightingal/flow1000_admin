import 'dart:convert';

import 'package:flow1000_admin/album_content.dart';
import 'package:flow1000_admin/config.dart';
import 'package:flow1000_admin/struct/album_info.dart';
import 'package:flow1000_admin/struct/slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class MasonryAlbumIndex extends StatefulWidget {
  const MasonryAlbumIndex({super.key, required this.album});

  final String album;

  @override
  State<StatefulWidget> createState() {
    return MasonryAlbumIndexState();
  }
}

class MasonryAlbumIndexState extends State<MasonryAlbumIndex> {
  late double width;
  Future<List<AlbumInfo>> fetchAlbumIndex() async {
    final response = await http.get(
      Uri.parse(albumIndexUrl(album: widget.album)),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = jsonDecode(response.body);
      List<AlbumInfo> albumInfoList =
          jsonArray.map((e) => AlbumInfo.fromJson(e)).toList();
      return albumInfoList;
    } else {
      throw Exception("Failed to load album");
    }
  }

  late Future<List<AlbumInfo>> albumInfoListFuture;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    Widget body = FutureBuilder<List<AlbumInfo>>(
      future: albumInfoListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<AlbumInfo> dataList = snapshot.data!;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var crossAxisCount = 2;
              return MasonryGridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AlbumContentPage(
                                albumIndex: snapshot.data![index].index,
                              ),
                        ),
                      );
                    },
                    child: buildCard(snapshot.data![index]),
                  );
                },
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
    return body;
  }

  final int coverPadding = 8;
  final int titleHeight = 56;
  late SlotGroup slotGroup;

  @override
  void initState() {
    super.initState();
    albumInfoListFuture = fetchAlbumIndex();
  }

  Widget _generateImageContainer(AlbumInfo albumInfo) {
    var url = albumInfo.toCoverUrl();
    if (url.endsWith(".avif")) {
      return AvifImage.network(
        width: albumInfo.realWidth,
        height: albumInfo.realHeight,
        key: Key("image-${albumInfo.index}"),
        url,
      );
    } else {
      return Image.network(
        width: albumInfo.realWidth,
        height: albumInfo.realHeight,
        key: Key("image-${albumInfo.index}"),
        albumInfo.toCoverUrl(),
      );
    }
  }

  Widget buildCard(AlbumInfo albumInfo) {
    int originImgHeight = albumInfo.coverHeight;
    int originImgWidth = albumInfo.coverWidth;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 2,
        ),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: originImgWidth / originImgHeight,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: _generateImageContainer(albumInfo),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                albumInfo.title,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
