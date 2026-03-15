import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/models/tracker_state.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class TrackerSummaryCard extends StatelessWidget {
  final TrackerInfo tracker;

  const TrackerSummaryCard({super.key, required this.tracker});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.dw(12)),
      decoration: BoxDecoration(
        color: MyAppTheme.bgColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: SizeConfig.dw(56),
                height: SizeConfig.dw(56),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
                  image: DecorationImage(
                    image: NetworkImage(tracker.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: SizeConfig.dw(10)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tracker.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: MyAppTheme.textColor,
                        fontWeight: FontWeight.w800,
                        fontSize: SizeConfig.sp(15),
                      ),
                    ),

                    SizedBox(height: SizeConfig.dh(4)),

                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: SizeConfig.dw(14),
                          color: MyAppTheme.secondaryColor,
                        ),
                        SizedBox(width: SizeConfig.dw(4)),
                        if (tracker.lastUpdate != null)
                          Text(
                            DateFormat(
                              "yyyy/MM/dd HH:mm",
                            ).format(tracker.lastUpdate!),
                            style: TextStyle(
                              color: MyAppTheme.grayColor,
                              fontSize: SizeConfig.sp(11),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.dh(2)),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: SizeConfig.dw(14),
                          color: MyAppTheme.secondaryColor,
                        ),
                        SizedBox(width: SizeConfig.dw(4)),
                        Expanded(
                          child: Text(
                            tracker.address,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: MyAppTheme.grayColor,
                              fontSize: SizeConfig.sp(11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.dh(12)),

          /// battery temp speed
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.battery_full,
                  label: "Цэнэг",
                  value: "${tracker.battery}%",
                  color: const Color(0xFF4CAF50),
                ),
              ),

              _DividerV(),

              Expanded(
                child: _StatItem(
                  icon: Icons.device_thermostat,
                  label: "Температур",
                  value: "${tracker.temperature}",
                  color: const Color(0xFF00BCD4),
                ),
              ),

              _DividerV(),

              Expanded(
                child: _StatItem(
                  icon: Icons.speed,
                  label: "Хурд",
                  value: "${tracker.speed} км/ц",
                  color: const Color(0xFF00BCD4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: SizeConfig.dw(18)),
        SizedBox(height: SizeConfig.dh(4)),
        Text(
          value,
          style: TextStyle(
            color: MyAppTheme.textColor,
            fontWeight: FontWeight.w800,
            fontSize: SizeConfig.sp(13),
          ),
        ),
        SizedBox(height: SizeConfig.dh(2)),
        Text(
          label,
          style: TextStyle(
            color: MyAppTheme.grayColor,
            fontSize: SizeConfig.sp(11),
          ),
        ),
      ],
    );
  }
}

class _DividerV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: SizeConfig.dh(40),
      color: MyAppTheme.grayColor.withOpacity(0.25),
    );
  }
}
