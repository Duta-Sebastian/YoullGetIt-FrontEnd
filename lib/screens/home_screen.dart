import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/screens/job_card_swiper_screen.dart';
import 'package:youllgetit_flutter/screens/job_cart_screen.dart';
import 'package:youllgetit_flutter/screens/profile_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  final pages = [
    JobCardSwiperScreen(),
    JobCartScreen(),
    const Page3(),
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

class Page3 extends ConsumerStatefulWidget {
  const Page3({super.key});

  @override
  Page3State createState() => Page3State();
}

class Page3State extends ConsumerState<Page3> {

  @override
  void initState() {
    super.initState();
    _deleteJobs();
  }

    Future<void> _deleteJobs() async {
    await DatabaseManager.deleteAllJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 3",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}