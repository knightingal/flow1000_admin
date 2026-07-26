import 'dart:convert';

// ignore: unused_import
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'struct/album_info.dart';

class SectoinContentPage extends StatefulWidget {
  const SectoinContentPage({super.key, required this.albumIndex});

  final int albumIndex;

  @override
  State<StatefulWidget> createState() {
    return SectoinContentPageState();
  }
}

class SectoinContentPageState extends State<SectoinContentPage> {
  late double width;
  late double top;
  Future<SectionDetail> fetchAlbumIndex() async {
    final response = await http.get(
      Uri.parse(albumContentUrl(widget.albumIndex)),
    );
    if (response.statusCode == 200) {
      dynamic jsonArray = jsonDecode(response.body);
      SectionDetail albumInfoList = SectionDetail.fromJson(jsonArray);
      return albumInfoList;
    } else {
      throw Exception("Failed to load album");
    }
  }

  late Future<SectionDetail> sectionDetail;

  @override
  void initState() {
    super.initState();
    sectionDetail = fetchAlbumIndex();
  }

  void subscribeAlbum() async {
    final url = subscribeAlbumUrl(widget.albumIndex);
    final response = await http.post(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Failed to subscribe album");
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    Widget body = FutureBuilder<SectionDetail>(
      future: sectionDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.pics.isNotEmpty) {
          var sectionInfo = snapshot.data!;
          var dataList = snapshot.data!.pics;
          return LayoutBuilder(
            builder: (context, constraints) {
              var crossAxisCount = 1;
              return MasonryGridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  var url = dataList[index].toUrl(sectionInfo);
                  if (url.endsWith(".avif")) {
                    return AspectRatio(
                      aspectRatio:
                          dataList[index].width / dataList[index].height,
                      child: AvifImage.network(key: Key("content-$index"), url),
                    );
                  } else {
                    return AspectRatio(
                      aspectRatio:
                          dataList[index].width / dataList[index].height,
                      child: Image.network(key: Key("content-$index"), url),
                    );
                  }
                },
              );
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
    return Scaffold(body: body);
  }
}
