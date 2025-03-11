import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:youllgetit_flutter/widgets/job_card.dart';  // Import the package

class JobCardSwiper extends StatelessWidget {
  JobCardSwiper({super.key});

  final List<JobCardData> jobs = [
    JobCardData(
      title: 'Chassis Engineer',
      company: 'RedBull',
      location: 'Amsterdam, The Netherlands',
      duration: 'Feb - Aug, 2025',
      education: 'BA3/MSc',
      salary: '1000\$',
      languages: 'EN, FR',
      jobType: 'Full-Time',
      experience: 'Not needed',
    ),
    JobCardData(
      title: 'Automotive Engineer',
      company: 'Mercedes',
      location: 'Berlin, Germany',
      duration: 'Feb - Aug, 2025',
      education: 'BSc/MSc',
      salary: '2000\$',
      languages: 'EN, GER',
      jobType: 'Part-Time',
      experience: 'Not needed',
    ),
    // Add more job entries here
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child:
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.7,
            child: CardSwiper(
              cardsCount: jobs.length,
              cardBuilder: (context, index, percentThresholdx, percentThresholdy) {
                return JobCard(jobData: jobs[index]);
              },
              numberOfCardsDisplayed: 2,
              backCardOffset: const Offset(0, 40),
              padding: const EdgeInsets.all(24.0),
              allowedSwipeDirection: AllowedSwipeDirection.only(
                right: true,
                left: true,
              ),
              onSwipe: (previousIndex, currentIndex, direction) {

                if (direction == CardSwiperDirection.left) {
                  print('Swiped left');
                } else if (direction == CardSwiperDirection.right) {
                  print('Swiped right');
                }
                // Handle swipe events here if needed
                return true; // Return true to allow the swipe
              },
            ),
          ),
      ),
    );
  }
}