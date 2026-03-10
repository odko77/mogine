import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/widgets/home/pinned_trackers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: MyAppTheme.bgColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.dw(16),
            SizeConfig.dh(12),
            SizeConfig.dw(16),
            SizeConfig.dh(14),
          ),
          children: [
            AnimalCarousel(),
            SizedBox(height: SizeConfig.dh(14)),

            _SectionTitle(title: "Цэсүүд"),
            SizedBox(height: SizeConfig.dh(10)),
            _MenuGrid(),
            SizedBox(height: SizeConfig.dh(14)),

            _SectionTitleWithAction(
              title: "Шинэчлэгдсэн байршилууд",
              actionText: "Харах →",
              onTap: () {},
            ),
            SizedBox(height: SizeConfig.dh(10)),

            // List cards
            ...List.generate(
              3,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.dh(10)),
                child: _TrackerCard(
                  name: "Хар морь",
                  lat: "106.321321",
                  lon: "48.231321",
                  time: "2026-03-03 14:32",
                  battery: 80,
                  satellites: 5,
                  speed: 12,
                  distanceKm: 45,
                  imageAsset: "assets/horse.jpg",
                ),
              ),
            ),

            SizedBox(height: SizeConfig.dh(18)),
          ],
        ),
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MenuButton(
            color: const Color(0xFF33C24D),
            icon: Icons.map_outlined,
            label: "Зураг",
            onTap: () {},
          ),
        ),
        SizedBox(width: SizeConfig.dw(12)),
        Expanded(
          child: _MenuButton(
            color: const Color(0xFFF2B24A),
            icon: Icons.memory_rounded,
            label: "Төхөөрөмж",
            onTap: () {},
          ),
        ),
        SizedBox(width: SizeConfig.dw(12)),
        Expanded(
          child: _MenuButton(
            color: const Color(0xFF00B8D4),
            icon: Icons.credit_card,
            label: "Төлбөр",
            onTap: () {},
          ),
        ),
        SizedBox(width: SizeConfig.dw(12)),
        Expanded(
          child: _MenuButton(
            color: MyAppTheme.grayColor,
            icon: Icons.menu,
            label: "Бусад",
            iconColor: MyAppTheme.primaryColor,
            labelColor: MyAppTheme.grayColor,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _MenuButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final btnSize = SizeConfig.dw(58);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SizeConfig.dw(15)),
          child: Container(
            width: btnSize,
            height: btnSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(SizeConfig.dw(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: SizeConfig.dw(26),
              color: iconColor ?? Colors.white,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.dh(8)),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: (labelColor ?? MyAppTheme.textColor).withOpacity(0.9),
            fontSize: SizeConfig.sp(10),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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

class _SectionTitleWithAction extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const _SectionTitleWithAction({
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SectionTitle(title: title)),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.dw(6),
              vertical: SizeConfig.dh(4),
            ),
            child: Text(
              actionText,
              style: TextStyle(
                color: MyAppTheme.textColor.withOpacity(0.85),
                fontSize: SizeConfig.sp(12),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackerCard extends StatelessWidget {
  final String name;
  final String lat;
  final String lon;
  final String time;
  final int battery;
  final int satellites;
  final int speed;
  final int distanceKm;
  final String imageAsset;

  const _TrackerCard({
    required this.name,
    required this.lat,
    required this.lon,
    required this.time,
    required this.battery,
    required this.satellites,
    required this.speed,
    required this.distanceKm,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.dw(12)),
      decoration: BoxDecoration(
        color: MyAppTheme.cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
            child: Image.asset(
              imageAsset,
              width: SizeConfig.dw(58),
              height: SizeConfig.dw(58),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: SizeConfig.dw(12)),

          // Middle info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: MyAppTheme.textColor,
                    fontSize: SizeConfig.sp(13),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: SizeConfig.dh(6)),
                _InfoLine(icon: Icons.location_on_outlined, text: "$lat  $lon"),
                SizedBox(height: SizeConfig.dh(4)),
                _InfoLine(icon: Icons.calendar_month, text: time),
                SizedBox(height: SizeConfig.dh(6)),
                Row(
                  children: [
                    _MiniChip(icon: Icons.battery_full, text: "$battery%"),
                    SizedBox(width: SizeConfig.dw(8)),
                    _MiniChip(
                      icon: Icons.device_thermostat_rounded,
                      text: "$satellites",
                    ),
                    SizedBox(width: SizeConfig.dw(8)),
                    _MiniChip(icon: Icons.speed, text: "$speed км/ц"),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: SizeConfig.dw(10)),

          // Right distance
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/distance.svg',
                height: SizeConfig.dw(24),
                colorFilter: const ColorFilter.mode(
                  MyAppTheme.textColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: SizeConfig.dh(6)),
              Text(
                "$distanceKm км",
                style: TextStyle(
                  color: MyAppTheme.textColor,
                  fontSize: SizeConfig.sp(12),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: SizeConfig.dw(14), color: MyAppTheme.secondaryColor),
        SizedBox(width: SizeConfig.dw(6)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: MyAppTheme.textColor.withOpacity(0.85),
              fontSize: SizeConfig.sp(10),
              fontWeight: FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: SizeConfig.dw(14), color: MyAppTheme.secondaryColor),
        SizedBox(width: SizeConfig.dw(4)),
        Text(
          text,
          style: TextStyle(
            color: MyAppTheme.textColor.withOpacity(0.85),
            fontSize: SizeConfig.sp(10),
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
