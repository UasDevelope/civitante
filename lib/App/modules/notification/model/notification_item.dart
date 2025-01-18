import '../../../utilse/widgets.dart';

class NotificationItem {
  final String title;
  final IconData? icon;
  final bool isBold;
  final bool isHighlighted;

  NotificationItem({
    required this.title,
    this.icon,
    this.isBold = false,
    this.isHighlighted = false,
  });
}
