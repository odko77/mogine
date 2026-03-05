import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';
import 'package:go_router/go_router.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  Future<void> requestPermissions() async {
    await [Permission.location, Permission.notification].request();

    if (mounted) {
      context.pushReplacement("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: MyAppTheme.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.dw(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: SizeConfig.dw(90),
                color: MyAppTheme.secondaryColor,
              ),

              SizedBox(height: SizeConfig.dh(30)),

              Text(
                "Апп ашиглахын тулд дараах эрхүүд хэрэгтэй",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.sp(18),
                  fontWeight: FontWeight.bold,
                  color: MyAppTheme.textColor,
                ),
              ),

              SizedBox(height: SizeConfig.dh(30)),

              permissionItem(Icons.location_on, "Байршил"),
              permissionItem(Icons.notifications, "Мэдэгдэл"),

              SizedBox(height: SizeConfig.dh(40)),

              SizedBox(
                width: double.infinity,
                height: SizeConfig.dh(50),
                child: ElevatedButton(
                  onPressed: requestPermissions,
                  child: Text(
                    "Зөвшөөрөх",
                    style: TextStyle(
                      fontSize: SizeConfig.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget permissionItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.dh(14)),
      child: Row(
        children: [
          Container(
            width: SizeConfig.dw(44),
            height: SizeConfig.dw(44),
            decoration: BoxDecoration(
              color: MyAppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: MyAppTheme.secondaryColor),
          ),

          SizedBox(width: SizeConfig.dw(14)),

          Text(
            text,
            style: TextStyle(
              fontSize: SizeConfig.sp(14),
              color: MyAppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
