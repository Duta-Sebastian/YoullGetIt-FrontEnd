import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:youllgetit_flutter/models/job_card_model.dart';
import 'package:youllgetit_flutter/widgets/job_card.dart';

class JobCardSwiper extends StatefulWidget {
  const JobCardSwiper({super.key});

  @override
  JobCardSwiperState createState() => JobCardSwiperState();
}

class JobCardSwiperState extends State<JobCardSwiper> {
  final List<JobCardModel> jobs = [
    JobCardModel(
      title: 'Chassis Engineer',
      company: 'RedBull',
      location: 'Amsterdam, The Netherlands',
      duration: 'Feb - Aug, 2025',
      education: 'BA3/MSc',
      salary: '1000\$',
      languages: 'EN, FR',
      jobType: 'Full-Time',
      experience: 'Not needed',
      skills: ['CAD', 'FEA', 'CFD'],
      niceToHave: ['Python', 'Matlab'],
    ),
    JobCardModel(
      title: 'Automotive Engineer',
      company: 'Mercedes',
      location: 'Berlin, Germany',
      duration: 'Feb - Aug, 2025',
      education: 'BSc/MSc',
      salary: '2000\$',
      languages: 'EN, GER',
      jobType: 'Part-Time',
      experience: 'Not needed',
      skills: ['CAD', 'FEA', 'CFD'],
      niceToHave: ['No', 'Matlab'],
    ),
    JobCardModel(
      title: 'Automotive Engineer1',
      company: 'Mercedes',
      location: 'Berlin, Germany',
      duration: 'Feb - Aug, 2025',
      education: 'BSc/MSc',
      salary: '2000\$',
      languages: 'EN, GER',
      jobType: 'Part-Time',
      experience: 'Not needed',
      skills: ['CAD', 'FEA', 'CFD'],
      niceToHave: ['No', 'Matlab'],
    ),
    JobCardModel(
      title: 'Automotive Engineer2',
      company: 'Mercedes',
      location: 'Berlin, Germany',
      duration: 'Feb - Aug, 2025',
      education: 'BSc/MSc',
      salary: '2000\$',
      languages: 'EN, GER',
      jobType: 'Part-Time',
      experience: 'Not needed',
      skills: ['CAD', 'FEA', 'CFD'],
      niceToHave: ['No', 'Matlab'],
    ),
    // Add more job entries here
  ];

  int _currentTopCardIndex = 0; // Track the current top card index

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight * 0.7,
          child: CardSwiper(
            cardsCount: jobs.length,
            cardBuilder: (context, index, percentThresholdx, percentThresholdy) {
              bool isTopCard = index == _currentTopCardIndex;
              return IgnorePointer(
                ignoring: !isTopCard,
                child: JobCard(jobData: jobs[index], percentThresholdx: percentThresholdx.toDouble()),
              );
            },
            numberOfCardsDisplayed: 2,
            backCardOffset: const Offset(0, 40),
            padding: const EdgeInsets.all(24.0),
            allowedSwipeDirection: AllowedSwipeDirection.only(
              right: true,
              left: true,
            ),
            onSwipe: (previousIndex, currentIndex, direction) {
              if (currentIndex != null) {
                setState(() {
                  _currentTopCardIndex = currentIndex;
                });
              }
              return true;
            },
          ),
        ),
      ),
    );
  }
}