import 'package:flow1000_admin/album_content.dart';
import 'package:flow1000_admin/album_grid.dart';
import 'package:flow1000_admin/album_index.dart';
import 'package:flutter/material.dart';

import 'struct/slot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(text: "main"),
              Tab(text: "1803"),
              Tab(text: "1804"),
              Tab(text: "1805"),
              Tab(text: "1806"),
              Tab(text: "1807"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AlbumIndexPage(album: "1000"),
            AlbumIndexPage(album: "1803"),
            AlbumIndexPage(album: "1804"),
            AlbumIndexPage(album: "1805"),
            AlbumIndexPage(album: "1806"),
            AlbumIndexPage(album: "1807"),
          ],
        ),
        // body: AlbumGridPage(),
        // body: AlbumContentPage(albumIndex: 5,),
        // body: EncriptImageWidget(),
        // body: ImageEx.network("http://192.168.2.12:3002/linux1000/encrypted/20151209003040BB-29 USS NORTH DAKOTA/011739.jpg.bin"),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
