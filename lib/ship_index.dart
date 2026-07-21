import 'dart:convert';
import 'dart:developer';

import 'package:flow1000_admin/album_content.dart';
import 'package:flow1000_admin/config.dart';
import 'package:flow1000_admin/struct/ship.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShipIndexPage extends StatefulWidget {
  const ShipIndexPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ShipIndexPageState();
  }
}

class ShipIndexPageState extends State<ShipIndexPage> {
  Future<List<Ship>> fetchShipList() async {
    final response = await http.get(Uri.parse(shipIndexUrl()));
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = jsonDecode(response.body);
      List<Ship> shipList = jsonArray.map((e) => Ship.fromJson(e)).toList();
      return shipList;
    } else {
      throw Exception("Failed to load album");
    }
  }

  late Future<List<Ship>> futureDataList;

  @override
  void initState() {
    super.initState();
    futureDataList = fetchShipList();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = FutureBuilder<List<Ship>>(
      future: futureDataList,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            prototypeItem: DirItem(
              index: 0,
              title: snapshot.data!.first.shipName,
              tapCallback: (index, title) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumContentPage(albumIndex: index),
                  ),
                );
              },
            ),
            itemBuilder: (context, index) {
              return DirItem(
                index: index,
                title: snapshot.data![index].shipName,
                tapCallback: (index, title) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlbumContentPage(albumIndex: index),
                    ),
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
