import '../utilse/widgets.dart';

class NotificationItem {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String category;
  final DateTime timestamp;
  final IconData? icon;
  final bool isBold;
  final bool isHighlighted;
  final Map<String, dynamic>? extraData;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.category,
    required this.timestamp,
    this.icon,
    this.isBold = false,
    this.isHighlighted = false,
    this.extraData,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      category: json['category'],
      timestamp: DateTime.parse(json['timestamp']),
      extraData: json.containsKey('extraData')
          ? json['extraData'] as Map<String, dynamic>
          : null,
    );
  }

  String getTimeDisplay() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) {
      return DateTime.now().weekday == timestamp.weekday
          ? 'This ${getWeekdayName(timestamp.weekday)}'
          : getWeekdayName(timestamp.weekday);
    }
    if (difference.inDays < 14) return '1 week ago';
    if (difference.inDays < 21) return '2 weeks ago';
    if (difference.inDays < 28) return '3 weeks ago';
    if (difference.inDays < 60) return '1 month ago';
    return '${(difference.inDays / 30).floor()} months ago';
  }

  String getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}
