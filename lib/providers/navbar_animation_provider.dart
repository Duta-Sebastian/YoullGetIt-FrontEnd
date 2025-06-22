import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkAnimationState {
  final bool isAnimating;
  final double progress;
  
  BookmarkAnimationState({
    required this.isAnimating, 
    required this.progress
  });
}

class BookmarkAnimationNotifier extends StateNotifier<BookmarkAnimationState> {
  BookmarkAnimationNotifier() : super(
    BookmarkAnimationState(isAnimating: false, progress: 0.0)
  );
  
  int _animationId = 0;
  
  void triggerAnimation() {
    _animationId++;
    final currentAnimationId = _animationId;
    
    state = BookmarkAnimationState(isAnimating: true, progress: 0.0);
    
    const totalDuration = 800;
    const steps = 20;
    const stepDuration = totalDuration ~/ steps;
    
    for (int i = 1; i <= steps; i++) {
      Future.delayed(Duration(milliseconds: i * stepDuration), () {
        if (mounted && currentAnimationId == _animationId) {
          final progress = i / steps;
          state = BookmarkAnimationState(isAnimating: true, progress: progress);
        }
      });
    }
  }
}

final bookmarkAnimationProvider = StateNotifierProvider<BookmarkAnimationNotifier, BookmarkAnimationState>((ref) {
  return BookmarkAnimationNotifier();
});