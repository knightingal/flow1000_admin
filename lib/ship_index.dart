import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
