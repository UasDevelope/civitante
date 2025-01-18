import 'package:flutter/material.dart';
import 'package:civitante/App/utilse/widgets.dart';
class HistorySection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;
  final VoidCallback onSeeAll;

  const HistorySection({
    super.key,
    required this.title,
    required this.items,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(text: title,fontWeight:FontWeight.w600,fontSize:20),
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                AppStrings.See_All,
                style: GoogleFonts.poppins(
                  fontSize:14,
                  fontWeight:FontWeight.w400,
                  color: AppColors.moreblue,
                  decoration: TextDecoration.underline,
                  decorationColor:AppColors.moreblue
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment:MainAxisAlignment.start,
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: item['title']!,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.appColor,
                      ),
                      AppText(
                        text: item['date']!,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,

                        color: AppColors.textFieldHintColor,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        text: "pts ${item['points']!}",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.appColor,
                      ),

                      AppText(
                        text: item['currency']!,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: AppColors.textFieldHintColor,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
