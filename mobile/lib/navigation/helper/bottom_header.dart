import 'package:flutter/material.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class MongineHeader extends StatelessWidget {
  final String logoAsset;
  final String phone;
  final String name;
  final int badge;
  final VoidCallback? onAvatarTap;

  const MongineHeader({
    required this.logoAsset,
    required this.phone,
    required this.name,
    required this.badge,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: SizeConfig.dh(72),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.dw(16)),
        decoration: BoxDecoration(
          color: MyAppTheme.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(SizeConfig.dw(20)),
            bottomRight: Radius.circular(SizeConfig.dw(20)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(180),
              blurRadius: SizeConfig.dw(12),
              offset: Offset(0, SizeConfig.dh(6)),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              logoAsset,
              height: SizeConfig.dh(28),
              fit: BoxFit.contain,
            ),
            SizedBox(width: SizeConfig.dw(12)),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    phone,
                    style: TextStyle(
                      color: MyAppTheme.textColor,
                      fontWeight: FontWeight.normal,
                      fontSize: SizeConfig.sp(12),
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: MyAppTheme.textColor,
                      fontWeight: FontWeight.w800,
                      fontSize: SizeConfig.sp(16),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: SizeConfig.dw(12)),

            InkWell(
              onTap: onAvatarTap,
              borderRadius: BorderRadius.circular(999),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: SizeConfig.dw(44),
                    height: SizeConfig.dw(44),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6E6E6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: MyAppTheme.primaryColor,
                    ),
                  ),
                  if (badge > 0)
                    Positioned(
                      right: -SizeConfig.dw(2),
                      top: -SizeConfig.dh(2),
                      child: Container(
                        width: SizeConfig.dw(22),
                        height: SizeConfig.dw(22),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          badge.toString(),
                          style: TextStyle(
                            fontSize: SizeConfig.sp(12),
                            fontWeight: FontWeight.w800,
                            color: MyAppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
