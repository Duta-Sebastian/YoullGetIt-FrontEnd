import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/job_card/job_card_model.dart';
import 'package:youllgetit_flutter/providers/connectivity_provider.dart';
import 'package:youllgetit_flutter/providers/navbar_animation_provider.dart';
import 'package:youllgetit_flutter/services/job_api.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/jobs/job_card.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';

class JobCardSwiper extends ConsumerStatefulWidget {
  const JobCardSwiper({super.key});
  @override
  JobCardSwiperState createState() => JobCardSwiperState();
}

class JobCardSwiperState extends ConsumerState<JobCardSwiper> {
  double? screenWidth;
  double? screenHeight;
  
  // Function to handle job reporting
  Future<void> _reportJob(JobCardModel job) async {
    final localizations = AppLocalizations.of(context)!;
    
    // Show confirmation dialog
    final bool? shouldReport = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.reportJob),
          content: Text(localizations.reportJobConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(localizations.report),
            ),
          ],
        );
      },
    );
    
    if (shouldReport == true) {
      try {
        JobApi.markJobWithResult(job.feedbackId).then((success) {
          if (success) {
            // Optionally, you can remove the job from the list or update UI
            ref.read(activeJobsProvider.notifier).removeJob(0);
          } else {
            throw Exception('Failed to report job');
          }
        });
        debugPrint('Reporting job with ID: ${job.feedbackId}');
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.reportSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.reportError),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final jobsState = ref.watch(activeJobsProvider);
    final List<JobCardModel> activeJobs = jobsState.jobs;
    final bool isLoading = jobsState.isLoading;
    final String? errorMessage = jobsState.errorMessage;
    
    final connectivityStatus = ref.watch(isConnectedProvider);
    final bool isConnected = connectivityStatus.when(
      data: (value) => value,
      loading: () => true,
      error: (_, __) => false
    );
    
    debugPrint('JobCardSwiper: Connectivity status = $isConnected, state = ${connectivityStatus.toString()}');

    if (errorMessage != null) {
      debugPrint('JobCardSwiper: Showing error state: $errorMessage');
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              if (!isConnected)
                Text(
                  localizations.jobCardSwiperWaitingForConnection,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              if (isConnected)
                ElevatedButton.icon(
                  onPressed: () => {
                    ref.read(activeJobsProvider.notifier).resetJobs()
                  },
                  icon: Icon(Icons.restore_rounded),
                  label: Text(localizations.jobCardSwiperRetry),
                )
            ],
          ),
        )
      );
    }
    
    if (isLoading || activeJobs.isEmpty) {
      debugPrint('JobCardSwiper: Showing loading state');
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.amber,),
              SizedBox(height: 20),
              Text(localizations.jobCardSwiperLoadingRecommendations, selectionColor: Colors.amber,)
            ],
          ),
        ),
      );
    }

    screenWidth ??= MediaQuery.of(context).size.width;
    screenHeight ??= MediaQuery.of(context).size.height;

    debugPrint('JobCardSwiper: Showing normal state with ${activeJobs.length} jobs, isConnected = $isConnected');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (!isConnected && connectivityStatus is AsyncData) 
            Container(
              color: Colors.amber.shade100,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.wifi_off, size: 16, color: const Color.fromRGBO(252, 245, 203, 1)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      localizations.jobCardSwiperOfflineNotice,
                      style: TextStyle(fontSize: 12, color: const Color.fromRGBO(252, 245, 203, 1)),
                    ),
                  ),
                ],
              ),
            ),
          
            Expanded(
              child: Center(
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight! * 0.7,
                  child: CardSwiper(
                    cardsCount: activeJobs.length,
                    cardBuilder: (context, index, percentThresholdx, percentThresholdy) {
                      bool isTopCard = index == 0;
                      return IgnorePointer(
                        ignoring: !isTopCard,
                        child: JobCard(
                          jobData: activeJobs[index],
                          percentThresholdx: percentThresholdx.toDouble(),
                          onReport: isTopCard ? () => _reportJob(activeJobs[index]) : null, // Only add callback for top card
                        ),
                      );
                    },
                    numberOfCardsDisplayed: activeJobs.length > 1 ? 2 : 1,
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
                        ref.read(bookmarkAnimationProvider.notifier).triggerAnimation();
                      }
                      ref.read(jobCoordinatorProvider).handleSwipe(previousIndex, liked);
                      
                      return false;
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}