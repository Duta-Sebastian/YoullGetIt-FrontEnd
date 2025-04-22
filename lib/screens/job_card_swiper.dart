import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_card.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';

class JobCardSwiper extends ConsumerStatefulWidget {
  const JobCardSwiper({super.key});
  @override
  JobCardSwiperState createState() => JobCardSwiperState();
}

class JobCardSwiperState extends ConsumerState<JobCardSwiper> {
  int jobNumber = 0;
  double? cachedScreenWidth;
  double? cachedScreenHeight;
  
  @override
  Widget build(BuildContext context) {
    final activeJobs = ref.watch(activeJobsProvider);
    
    if (activeJobs.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    cachedScreenWidth ??= MediaQuery.of(context).size.width;
    cachedScreenHeight ??= MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: cachedScreenWidth,
          height: cachedScreenHeight! * 0.7,
          child: CardSwiper(
            cardsCount: activeJobs.length,
            cardBuilder: (context, index, percentThresholdx, percentThresholdy) {
              bool isTopCard = index == 0;
              return IgnorePointer(
                ignoring: !isTopCard,
                child: JobCard(
                  jobData: activeJobs[index],
                  percentThresholdx: percentThresholdx.toDouble(),
                ),
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
              if (previousIndex < 0 || previousIndex >= activeJobs.length) {
                return false;
              }
              
              final liked = direction == CardSwiperDirection.right;
              
              if (liked) {
                DatabaseManager.insertJobCard(activeJobs[previousIndex]);
              }
              
              ref.read(jobCoordinatorProvider).handleSwipe(previousIndex, liked);
              
              jobNumber++;
              return false;
            },
          ),
        ),
      ),
    );
  }
}