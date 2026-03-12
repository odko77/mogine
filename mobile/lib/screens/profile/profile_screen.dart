import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/location_notifier.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final session = ref.watch(authProvider).value;
    final me = session?.me;

    final phone = me?['phone_number']?.toString() ?? '---';
    final name = me?['first_name']?.toString() ?? '---';

    const trackerCount = 5;

    // device-level subscription summary
    const activeSubs = 3;
    const expiringSoon = 1;
    const expiredSubs = 1;

    return Scaffold(
      backgroundColor: MyAppTheme.bgColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.dw(12),
            SizeConfig.dh(12),
            SizeConfig.dw(12),
            SizeConfig.dh(24),
          ),
          children: [
            _ProfileHeaderCard(name: name, phone: phone),

            SizedBox(height: SizeConfig.dh(12)),

            const _SectionTitle(title: "Төхөөрөмжүүдийн төлбөр"),
            SizedBox(height: SizeConfig.dh(8)),

            const _DeviceSubscriptionSummaryCard(
              total: trackerCount,
              active: activeSubs,
              expiringSoon: expiringSoon,
              expired: expiredSubs,
            ),

            SizedBox(height: SizeConfig.dh(12)),

            const _SectionTitle(title: "Тохиргоо"),
            SizedBox(height: SizeConfig.dh(8)),

            _SettingsCard(
              items: [
                _SettingsItemData(
                  icon: Icons.person_outline,
                  title: "Хувийн мэдээлэл",
                  onTap: () {},
                ),
                _SettingsItemData(
                  icon: Icons.location_on_outlined,
                  title: "Байршлын эрх",
                  onTap: () {},
                ),
                _SettingsItemData(
                  icon: Icons.notifications_none,
                  title: "Мэдэгдлийн тохиргоо",
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: SizeConfig.dh(14)),

            SizedBox(
              width: double.infinity,
              height: SizeConfig.dh(48),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                },
                icon: Icon(
                  Icons.logout,
                  size: SizeConfig.dw(18),
                  color: MyAppTheme.primaryColor,
                ),
                label: Text(
                  "Системээс гарах",
                  style: TextStyle(
                    fontSize: SizeConfig.sp(14),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String phone;
  final String? role;

  const _ProfileHeaderCard({
    required this.name,
    required this.phone,
    this.role = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.dw(14)),
      decoration: BoxDecoration(
        color: MyAppTheme.cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(18)),
      ),
      child: Row(
        children: [
          Container(
            width: SizeConfig.dw(58),
            height: SizeConfig.dw(58),
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name.characters.first : "U",
              style: TextStyle(
                color: MyAppTheme.primaryColor,
                fontSize: SizeConfig.sp(22),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: SizeConfig.dw(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MyAppTheme.textColor,
                    fontSize: SizeConfig.sp(16),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: SizeConfig.dh(4)),
                Text(
                  phone,
                  style: TextStyle(
                    color: MyAppTheme.grayColor,
                    fontSize: SizeConfig.sp(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: SizeConfig.dh(6)),
                if (role != "")
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.dw(8),
                      vertical: SizeConfig.dh(4),
                    ),
                    decoration: BoxDecoration(
                      color: MyAppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(SizeConfig.dw(999)),
                    ),
                    child: Text(
                      role ?? "",
                      style: TextStyle(
                        color: MyAppTheme.secondaryColor,
                        fontSize: SizeConfig.sp(10),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: MyAppTheme.textColor,
        fontSize: SizeConfig.sp(14),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _InfoStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.dw(12)),
      decoration: BoxDecoration(
        color: MyAppTheme.cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: SizeConfig.dw(22)),
          SizedBox(height: SizeConfig.dh(12)),
          Text(
            value,
            style: TextStyle(
              color: MyAppTheme.textColor,
              fontSize: SizeConfig.sp(18),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: SizeConfig.dh(2)),
          Text(
            title,
            style: TextStyle(
              color: MyAppTheme.grayColor,
              fontSize: SizeConfig.sp(11),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationStatusCard extends StatelessWidget {
  final double? lat;
  final double? lon;
  final double? accuracy;
  final double? speed;
  final DateTime? updatedAt;

  const _LocationStatusCard({
    this.lat,
    this.lon,
    this.accuracy,
    this.speed,
    this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final hasLocation = lat != null && lon != null;

    return Container(
      padding: EdgeInsets.all(SizeConfig.dw(12)),
      decoration: BoxDecoration(
        color: MyAppTheme.cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasLocation ? Icons.gps_fixed : Icons.gps_off,
                color: hasLocation ? const Color(0xFF2ECC71) : Colors.redAccent,
                size: SizeConfig.dw(18),
              ),
              SizedBox(width: SizeConfig.dw(8)),
              Text(
                hasLocation ? "Байршил идэвхтэй" : "Байршил унтарсан",
                style: TextStyle(
                  color: MyAppTheme.textColor,
                  fontSize: SizeConfig.sp(13),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.dh(10)),
          Text(
            hasLocation
                ? "lat: ${lat!.toStringAsFixed(6)}\nlon: ${lon!.toStringAsFixed(6)}"
                : "Байршлын эрх эсвэл GPS үйлчилгээ идэвхгүй байна.",
            style: TextStyle(
              color: MyAppTheme.grayColor,
              fontSize: SizeConfig.sp(11),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          if (hasLocation) ...[
            SizedBox(height: SizeConfig.dh(10)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Нарийвчлал: ${accuracy?.toStringAsFixed(1) ?? "-"} м",
                    style: TextStyle(
                      color: MyAppTheme.grayColor,
                      fontSize: SizeConfig.sp(11),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Хурд: ${speed?.toStringAsFixed(1) ?? "0"} м/с",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: MyAppTheme.grayColor,
                      fontSize: SizeConfig.sp(11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DeviceSubscriptionSummaryCard extends StatelessWidget {
  final int total;
  final int active;
  final int expiringSoon;
  final int expired;

  const _DeviceSubscriptionSummaryCard({
    required this.total,
    required this.active,
    required this.expiringSoon,
    required this.expired,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.dw(12)),
      decoration: BoxDecoration(
        color: MyAppTheme.cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Төлбөрийн ерөнхий төлөв",
            style: TextStyle(
              color: MyAppTheme.textColor,
              fontSize: SizeConfig.sp(14),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: SizeConfig.dh(12)),
          Row(
            children: [
              Expanded(
                child: _MiniStatus(
                  title: "Нийт",
                  value: "$total",
                  color: MyAppTheme.textColor,
                ),
              ),
              Expanded(
                child: _MiniStatus(
                  title: "Идэвхтэй",
                  value: "$active",
                  color: const Color(0xFF2ECC71),
                ),
              ),
              Expanded(
                child: _MiniStatus(
                  title: "Удахгүй",
                  value: "$expiringSoon",
                  color: MyAppTheme.secondaryColor,
                ),
              ),
              Expanded(
                child: _MiniStatus(
                  title: "Дууссан",
                  value: "$expired",
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStatus extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MiniStatus({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: SizeConfig.sp(16),
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: SizeConfig.dh(4)),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyAppTheme.grayColor,
            fontSize: SizeConfig.sp(10),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<_SettingsItemData> items;

  const _SettingsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyAppTheme.cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.dw(12),
                    vertical: SizeConfig.dh(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        color: MyAppTheme.textColor,
                        size: SizeConfig.dw(20),
                      ),
                      SizedBox(width: SizeConfig.dw(12)),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: MyAppTheme.textColor,
                            fontSize: SizeConfig.sp(13),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: MyAppTheme.grayColor,
                        size: SizeConfig.dw(18),
                      ),
                    ],
                  ),
                ),
              ),
              if (i != items.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: MyAppTheme.primaryColor,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _SettingsItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _SettingsItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
