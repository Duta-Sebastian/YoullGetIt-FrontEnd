import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ProgressBar extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;

  const ProgressBar({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4, 
        intensity: 0.8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
        color: Colors.grey[300], 
      ),
      child: SizedBox(
        height: 20,
        width: double.infinity,
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double progressWidth = (currentQuestionIndex + 1) / totalQuestions * constraints.maxWidth;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Container(
                        width: progressWidth,
                        height: 20,
                        color: const Color.fromRGBO(89, 164, 144, 1),
                      ),
                      Positioned(
                        top: 2,
                        left: 10,
                        child: Container(
                          width: progressWidth - progressWidth*.10,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(120, 200, 180, 1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}