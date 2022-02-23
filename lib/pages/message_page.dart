import 'package:flutter/material.dart';
import 'package:unsplash_demo/pages/UpdatePage.dart';
import 'package:unsplash_demo/pages/inbox_page.dart';

class MessagePage extends StatefulWidget {
  static const String id = "/message_page";

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 10,
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: TabBar(
              indicatorColor: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.18),
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: [
                /// Update Button
                Tab(
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: (_selectedIndex == 0)
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Text(
                          "Updates",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: (_selectedIndex == 0)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ))),

                /// Inbox Button
                Tab(
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: (_selectedIndex == 1)
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Text(
                          "Inbox",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: (_selectedIndex == 1)
                                  ? Colors.white
                                  : Colors.black),
                        ))),
              ],
            ),
          ),
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [UpdatePage(), InboxPage()])),
    );
  }
}
