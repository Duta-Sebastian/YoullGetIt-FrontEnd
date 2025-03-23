import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/providers/database_provider.dart';
import 'package:youllgetit_flutter/screens/job_card_swiper.dart';
import 'package:youllgetit_flutter/screens/job_cart_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

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
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  ClipRRect buildMyNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.loop, 0),
            _buildNavItem(Icons.bookmark, 1),
            _buildNavItem(Icons.widgets_rounded, 2),
            _buildNavItem(Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = pageIndex == index;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        enableFeedback: false,
        onPressed: () {
          setState(() {
            pageIndex = index;
          });
        },
        icon: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            icon,
            color: Colors.white,
            size: isSelected ? 46 : 32,
          ),
        ),
        padding: EdgeInsets.all(isSelected ? 8 : 12),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
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