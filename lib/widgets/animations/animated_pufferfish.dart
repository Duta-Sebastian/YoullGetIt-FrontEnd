import 'package:flutter/material.dart';

class AnimatedPufferfish extends StatefulWidget {
  final double rotation;
  
  const AnimatedPufferfish({
    super.key,
    this.rotation = 0.0,
  });

  @override
  State<AnimatedPufferfish> createState() => _AnimatedPufferfishState();
}

class _AnimatedPufferfishState extends State<AnimatedPufferfish>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frameAnimation;
  
  int _cycleCount = 0;
  bool _imagesLoaded = false;
  bool _animationComplete = false;
  int _finalFrameIndex = 0;
  static const int _maxCycles = 6;
  
  // Frame assets with natural wave cycle
  static const List<String> _frames = [
    'assets/pufferfish_wave_1.png',
    'assets/pufferfish_wave_5.png',
    'assets/pufferfish_wave_2.png',
    'assets/pufferfish_wave_4.png',
    'assets/pufferfish_wave_3.png',
  ];

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Frame animation with linear progression for consistent timing
    _frameAnimation = Tween<double>(
      begin: 0.0,
      end: _frames.length.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Listen for animation completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_cycleCount < _maxCycles - 1) {
          _cycleCount++;
          _controller.reset();
          _controller.forward();
        } else {
          // Store the final frame index before stopping
          _finalFrameIndex = (_frameAnimation.value % _frames.length).floor();
          _controller.stop();
          setState(() {
            _animationComplete = true;
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Preload images
    if (!_imagesLoaded) {
      _preloadImages();
    }
  }

  Future<void> _preloadImages() async {
    // Preload all frames to avoid flash
    await Future.wait(
      _frames.map((frame) => precacheImage(AssetImage(frame), context))
    );
    
    if (mounted) {
      setState(() {
        _imagesLoaded = true;
      });
      // Start animation after images are loaded
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show first frame while loading
    if (!_imagesLoaded) {
      return SizedBox(
        width: 120,
        height: 120,
        child: Transform.rotate(
          angle: widget.rotation,
          child: Image.asset(
            _frames[0],
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    // If animation is complete, show the final frame
    if (_animationComplete) {
      return SizedBox(
        width: 120,
        height: 120,
        child: Transform.rotate(
          angle: widget.rotation,
          child: Image.asset(
            _frames[_finalFrameIndex],
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return SizedBox(
      width: 120,
      height: 120,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final frameIndex = (_frameAnimation.value % _frames.length).floor();
          
          return Transform.rotate(
            angle: widget.rotation,
            child: Image.asset(
              _frames[frameIndex],
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDE15),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 60,
                    color: Colors.black54,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}