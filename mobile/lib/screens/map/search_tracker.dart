import 'package:flutter/material.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class SearchTracker extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;

  const SearchTracker({required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
      child: Container(
        height: SizeConfig.dh(44),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.dw(14)),
        decoration: BoxDecoration(
          color: MyAppTheme.primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: MyAppTheme.textColor.withOpacity(0.9)),
            SizedBox(width: SizeConfig.dw(10)),
            Text(
              hint,
              style: TextStyle(
                color: MyAppTheme.textColor.withOpacity(0.75),
                fontSize: SizeConfig.sp(13),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
