import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import Riverpod
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_card.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';  // Import your job provider

class JobCardSwiper extends ConsumerStatefulWidget {  // Use StatefulConsumerWidget to listen to the provider
  const JobCardSwiper({super.key});

  @override
  JobCardSwiperState createState() => JobCardSwiperState();
}

class JobCardSwiperState extends ConsumerState<JobCardSwiper> {
  int _currentTopCardIndex = 0;
  int jobNumber = 0;

  @override
  Widget build(BuildContext context,) {
    int jobNumber = 0;
    final jobList = ref.watch(jobProvider);  // Watch the job provider
    if (jobList.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),  // Show loading indicator if jobs are still being fetched
        ),
      );
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight * 0.7,
          child: CardSwiper(
            cardsCount: jobList.length,
            cardBuilder: (context, index, percentThresholdx, percentThresholdy) {
              bool isTopCard = index == _currentTopCardIndex;
              return IgnorePointer(
                ignoring: !isTopCard,
                child: JobCard(jobData: jobList[index], percentThresholdx: percentThresholdx.toDouble()),
              );
            },
            numberOfCardsDisplayed: 2,
            backCardOffset: const Offset(0, 40),
            padding: const EdgeInsets.all(24.0),
            isLoop: false,
            allowedSwipeDirection: AllowedSwipeDirection.only(
              right: true,
              left: true,
            ),
            onSwipe: (previousIndex, currentIndex, direction) {
              if (currentIndex == null) {
                return false;
              }
              setState(() {
                _currentTopCardIndex = currentIndex;
              });
              if (jobNumber % 5 == 0) {
                ref.read(jobProvider.notifier).fetchJobs(5);
              }
                if (direction == CardSwiperDirection.right) {
                  DatabaseManager.insertJobCard(jobList[previousIndex]);
                }
              jobNumber++;
              return true;
            },
          ),
        ),
      ),
    );
  }
}
