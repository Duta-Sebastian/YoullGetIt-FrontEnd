import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_card.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';

class JobCardSwiper extends ConsumerStatefulWidget {
  const JobCardSwiper({super.key});
  @override
  JobCardSwiperState createState() => JobCardSwiperState();
}

class JobCardSwiperState extends ConsumerState<JobCardSwiper> {
  // Create a new controller each time we rebuild
  late CardSwiperController controller;
  int jobNumber = 0;
  
  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobState = ref.watch(jobProvider);
    final activeJobs = jobState.activeJobs;
    
    if (activeJobs.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
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
            // Create a unique key for each build to ensure fresh state
            key: UniqueKey(),
            controller: controller,
            cardsCount: activeJobs.length,
            cardBuilder: (context, index, percentThresholdx, percentThresholdy) {
              return JobCard(
                jobData: activeJobs[index], 
                percentThresholdx: percentThresholdx.toDouble()
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
            onSwipe: (previousIndex, currentIndex, direction) async {
              // Process the swipe action
              final liked = direction == CardSwiperDirection.right;
              
              // Process the swipe
              await ref.read(jobProvider.notifier).swipeJob(previousIndex, liked);
              
              // Check if we need to fetch more jobs
              jobNumber++;
              if (jobNumber % 5 == 0) {
                ref.read(jobProvider.notifier).fetchJobs(5);
              }
              
              return false;
            },
          ),
        ),
      ),
    );
  }
}