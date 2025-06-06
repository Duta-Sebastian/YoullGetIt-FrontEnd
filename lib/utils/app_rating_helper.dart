import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class AppRatingHelper {
  static final InAppReview _inAppReview = InAppReview.instance;

  static Future<void> requestRating(BuildContext context) async {
    try {
      final bool isAvailable = await _inAppReview.isAvailable();
      
      if (isAvailable) {
        await _inAppReview.requestReview();
      } else {
        if (context.mounted) {
          await _openStoreListing(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        await _openStoreListing(context);
      }
    }
  }

  static Future<void> _openStoreListing(BuildContext context) async {
    try {
      await _inAppReview.openStoreListing(
        // TODO: Replace with app store ID when we have it
        appStoreId: 'your_app_store_id_here',
      );
    } catch (e) {
      // Show error message if store opening fails
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open app store. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Alternative: Show custom dialog first, then rating
  static Future<void> showRatingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 8),
              Text('Rate Our App'),
            ],
          ),
          content: Text(
            'If you enjoy using our app, would you mind taking a moment to rate it? It really helps us improve!',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Maybe Later'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No Thanks'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                requestRating(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Rate Now'),
            ),
          ],
        );
      },
    );
  }
}