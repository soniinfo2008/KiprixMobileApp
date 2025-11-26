import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // This method returns the FirebaseAnalyticsObserver
  FirebaseAnalyticsObserver getAnalyticObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  // This method logs a screen view event
  Future<void> logEvent(String pageName) async {
    await analytics.logEvent(
      name: 'screen_view',
      parameters: <String, Object>{ // Corrected to use Map<String, Object>
        'page_name': pageName,
      },
    );
  }

  // This method logs a search event
  Future<void> searchEvent(String searchKey) async {
    await analytics.logEvent(
      name: 'search',
      parameters: <String, Object>{ // Corrected to use Map<String, Object>
        'search_key': searchKey,
      },
    );
  }

  // This method sets the user ID for analytics
  Future<void> setUserId(int userId) async {
    await analytics.setUserId(id: userId.toString());
  }
}
