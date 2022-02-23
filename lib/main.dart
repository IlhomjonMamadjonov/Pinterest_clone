import 'package:flutter/material.dart';
import 'package:unsplash_demo/pages/UpdatePage.dart';
import 'package:unsplash_demo/pages/detail_page.dart';
import 'package:unsplash_demo/pages/home_page.dart';
import 'package:unsplash_demo/pages/inbox_page.dart';
import 'package:unsplash_demo/pages/message_page.dart';
import 'package:unsplash_demo/pages/profile_page.dart';
import 'package:unsplash_demo/pages/search_page.dart';
import 'package:unsplash_demo/pages/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "UnSplash Demo",
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        SearchPage.id: (context) => SearchPage(),
        MessagePage.id: (context) => MessagePage(),
        Profilepage.id: (context) => Profilepage(),
        UpdatePage.id: (context) => UpdatePage(),
        InboxPage.id: (context) => InboxPage(),
        DetailPage.id: (context) => DetailPage(),
        SplashPage.id: (context) => SplashPage()
      },
    );
  }
}
