import 'package:flutter/material.dart';
import 'package:mobile/models/tracker_state.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/widgets/bottom_sheet/tracker_detail.dart';
import 'package:mobile/widgets/bottom_sheet/tracker_short_hint.dart';
import 'package:mobile/widgets/bottom_sheet/tracker_summary_card.dart';

class TrackerBottomSheet extends StatefulWidget {
  final TrackerInfo tracker;
  final ScrollController scrollCtrl;
  final DraggableScrollableController sheetCtrl;

  final double minSize;
  final double midSize;
  final double maxSize;

  const TrackerBottomSheet({
    super.key,
    required this.tracker,
    required this.scrollCtrl,
    required this.sheetCtrl,
    required this.minSize,
    required this.midSize,
    required this.maxSize,
  });

  @override
  State<TrackerBottomSheet> createState() => _TrackerBottomSheetState();
}

class _TrackerBottomSheetState extends State<TrackerBottomSheet> {
  bool _expanded = false;

  void _toggle() {
    setState(() => _expanded = !_expanded);

    widget.sheetCtrl.animateTo(
      _expanded ? widget.maxSize : widget.midSize,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyAppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.dw(18)),
          topRight: Radius.circular(SizeConfig.dw(18)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ✅ Header хэсэг (гарчиг + stats)
          Expanded(
            child: ListView(
              controller: widget.scrollCtrl,
              padding: EdgeInsets.fromLTRB(
                SizeConfig.dw(14),
                SizeConfig.dh(10),
                SizeConfig.dw(14),
                SizeConfig.dh(10),
              ),
              children: [
                TrackerSummaryCard(tracker: widget.tracker),

                SizedBox(height: SizeConfig.dh(10)),

                // ✅ эндээс дэлгэрэнгүй контент орж ирнэ
                if (_expanded)
                  TrackerDetailView(tracker: widget.tracker)
                else
                  TrackerShortHint(tracker: widget.tracker),
              ],
            ),
          ),

          // ✅ Bottom button (Дэлгэрэнгүй / Хураах)
          Container(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.dw(14),
              SizeConfig.dh(8),
              SizeConfig.dw(14),
              SizeConfig.dh(12),
            ),
            decoration: BoxDecoration(
              color: MyAppTheme.secondaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.dw(14)),
                topRight: Radius.circular(SizeConfig.dw(14)),
              ),
            ),
            child: InkWell(
              onTap: _toggle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: MyAppTheme.primaryColor,
                  ),
                  SizedBox(width: SizeConfig.dw(6)),
                  Text(
                    _expanded ? "Хураах" : "Дэлгэрэнгүй",
                    style: TextStyle(
                      color: MyAppTheme.primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: SizeConfig.sp(13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
