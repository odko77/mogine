import 'package:flutter/cupertino.dart';
import 'package:mobile/models/tracker_state.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class TrackerDetailView extends StatelessWidget {
  final TrackerInfo tracker;
  const TrackerDetailView({super.key, required this.tracker});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Багцийн хугацаа",
          style: TextStyle(
            color: MyAppTheme.textColor,
            fontWeight: FontWeight.w800,
            fontSize: SizeConfig.sp(13),
          ),
        ),
        SizedBox(height: SizeConfig.dh(8)),

        _RowLine(left: "100 хоног үлдсэн", right: "2026/08/01"),

        SizedBox(height: SizeConfig.dh(14)),

        Text(
          "Ойролцоо байршилууд",
          style: TextStyle(
            color: MyAppTheme.textColor,
            fontWeight: FontWeight.w800,
            fontSize: SizeConfig.sp(13),
          ),
        ),
        SizedBox(height: SizeConfig.dh(8)),

        _RowLine(left: "Цагаан худаг", right: "5 км"),
        _RowLine(left: "Том уул", right: "5 км"),

        SizedBox(height: SizeConfig.dh(20)),
      ],
    );
  }
}

class _RowLine extends StatelessWidget {
  final String left;
  final String right;
  const _RowLine({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.dh(8)),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.dw(12),
        vertical: SizeConfig.dh(10),
      ),
      decoration: BoxDecoration(
        color: MyAppTheme.bgColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: TextStyle(
                color: MyAppTheme.grayColor,
                fontSize: SizeConfig.sp(12),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            right,
            style: TextStyle(
              color: MyAppTheme.textColor,
              fontSize: SizeConfig.sp(12),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
