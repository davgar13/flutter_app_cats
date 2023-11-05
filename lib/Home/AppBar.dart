
import 'package:flutter/material.dart';
import 'package:flutter_app_cats/Home/pages/Cat_Screen.dart';
import 'package:flutter_app_cats/Home/pages/date_Cats.dart';
import 'package:flutter_app_cats/Home/pages/post_screen.dart';


List<String> titles = <String>[
  'Cats',
  'Adopt Cat',
  'Give Cat',
];


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 3;

    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adopt a Cat'),
          
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
    
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Image(image: AssetImage('asset/images/cat.png'),
                 width: 28, 
                 height: 28,
                 ),
                text: titles[0],
              ),
              Tab(
                icon: const Image(image: AssetImage('asset/images/paws.png'),
                 width: 35, 
                 height: 35,
                 ),
                text: titles[1],
              ),
              Tab(
                icon: const Image(
                  image: AssetImage('asset/images/hair.png'),
                  width: 28,
                  height: 28,
                ),
                text: titles[2],
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[

            ListadoGatos(),
              
            PostsScreen(),

            DataEntryScreen(),
              
          ],
        ),
      ),
    );
  }
}