import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/screens/job_card_swiper.dart';
import 'package:youllgetit_flutter/screens/job_cart_screen.dart';
import 'package:youllgetit_flutter/screens/manual_search_screen.dart';
import 'package:youllgetit_flutter/screens/profile_screen.dart';
import 'package:youllgetit_flutter/widgets/navbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int pageIndex = 0;

  final pages = [
    JobCardSwiper(),
    JobSearchScreen(),
    JobCartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavBar(
        currentPageIndex: pageIndex,
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        pages: pages,
      ),
    );
  }
}