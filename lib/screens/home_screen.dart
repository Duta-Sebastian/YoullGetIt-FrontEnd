import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/providers/database_provider.dart';
import 'package:youllgetit_flutter/screens/job_card_swiper.dart';
import 'package:youllgetit_flutter/screens/job_cart_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final pages = [
    JobCardSwiper(),
    JobCartScreen(),
    const Page3(),
    const Page4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(
      //     "You'll Get It",
      //     style: TextStyle(
      //       color: Theme.of(context).primaryColor,
      //       fontSize: 25,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      // ),
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
  const Page3({Key? key}) : super(key: key);

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
    final database = ref.read(databaseProvider).value;
    if (database != null) {
      await DatabaseManager.deleteAllJobs();
    }
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

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Page Number 4",
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