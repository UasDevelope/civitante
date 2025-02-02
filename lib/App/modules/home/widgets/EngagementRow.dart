// Engagement Row Widget (separate component)
import '../../../utilse/widgets.dart';
import 'engament_row.dart';

class EngagementRow extends StatelessWidget {
  final int views;
  final int likes;
  final int comments;

  const EngagementRow({
    required this.views,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildStatItem(
          icon: Image.asset(AppImages.view, height: 20),
          label: _formatCount(views),
        ),
        SizedBox(width: 10),
        buildStatItem(
          icon: Image.asset(AppImages.like, height: 15),
          label: _formatCount(likes),
        ),
        SizedBox(width: 10),
        buildStatItem(
          icon: Image.asset(AppImages.comment, height: 15),
          label: _formatCount(comments),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count > 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}