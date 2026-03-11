import 'package:flutter/material.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final List<MenuSectionModel> _menus = [
    MenuSectionModel(
      title: "Газрын зураг",
      icon: Icons.map_outlined,
      subMenus: [
        SubMenuModel(
          title: "Цэг нэмэх",
          icon: Icons.place_outlined,
          onTap: () {
            debugPrint("Цэг нэмэх");
          },
        ),
        SubMenuModel(
          title: "Хамрах хүрээ",
          icon: Icons.crop_free_rounded,
          onTap: () {
            debugPrint("Хамрах хүрээ");
          },
        ),
      ],
    ),
    MenuSectionModel(
      title: "Төхөөрөмж",
      icon: Icons.memory_rounded,
      subMenus: [
        SubMenuModel(
          title: "Төхөөрөмж нэмэх",
          icon: Icons.add_rounded,
          onTap: () {
            debugPrint("Төхөөрөмж нэмэх");
          },
        ),
        SubMenuModel(
          title: "Төхөөрөмж хасах",
          icon: Icons.remove_rounded,
          onTap: () {
            debugPrint("Төхөөрөмж хасах");
          },
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: MyAppTheme.bgColor,
      body: SafeArea(
        bottom: false,
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.dw(10),
            SizeConfig.dh(10),
            SizeConfig.dw(10),
            SizeConfig.dh(18),
          ),
          itemCount: _menus.length,
          separatorBuilder: (_, __) => SizedBox(height: SizeConfig.dh(10)),
          itemBuilder: (_, i) {
            final menu = _menus[i];
            return _MenuSectionCard(menu: menu);
          },
        ),
      ),
    );
  }
}

class _MenuSectionCard extends StatelessWidget {
  final MenuSectionModel menu;

  const _MenuSectionCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyAppTheme.cardColor.withOpacity(.75),
        borderRadius: BorderRadius.circular(SizeConfig.dw(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.dw(12),
              SizeConfig.dh(10),
              SizeConfig.dw(12),
              SizeConfig.dh(8),
            ),
            child: Row(
              children: [
                Container(
                  width: SizeConfig.dw(22),
                  height: SizeConfig.dw(22),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2ECC71),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    menu.icon,
                    color: Colors.white,
                    size: SizeConfig.dw(13),
                  ),
                ),
                SizedBox(width: SizeConfig.dw(8)),
                Text(
                  menu.title,
                  style: TextStyle(
                    color: MyAppTheme.textColor,
                    fontSize: SizeConfig.sp(12),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyAppTheme.cardColor,
              borderRadius: BorderRadius.circular(SizeConfig.dw(18)),
            ),
            padding: EdgeInsets.fromLTRB(
              SizeConfig.dw(10),
              SizeConfig.dh(10),
              SizeConfig.dw(10),
              SizeConfig.dh(10),
            ),
            child: menu.subMenus.isEmpty
                ? _EmptyMenuBody()
                : Wrap(
                    spacing: SizeConfig.dw(10),
                    runSpacing: SizeConfig.dh(10),
                    children: menu.subMenus
                        .map((e) => _SubMenuButton(item: e))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SubMenuButton extends StatelessWidget {
  final SubMenuModel item;

  const _SubMenuButton({required this.item});

  @override
  Widget build(BuildContext context) {
    final itemWidth = SizeConfig.dw(84);

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
      child: Container(
        width: itemWidth,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.dw(8),
          vertical: SizeConfig.dh(12),
        ),
        decoration: BoxDecoration(
          color: MyAppTheme.primaryColor.withOpacity(.9),
          borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: MyAppTheme.textColor,
              size: SizeConfig.dw(24),
            ),
            SizedBox(height: SizeConfig.dh(10)),
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: MyAppTheme.textColor,
                fontSize: SizeConfig.sp(10),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMenuBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.dh(300),
      decoration: BoxDecoration(
        color: MyAppTheme.cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
      ),
    );
  }
}

class MenuSectionModel {
  final String title;
  final IconData icon;
  final List<SubMenuModel> subMenus;

  MenuSectionModel({
    required this.title,
    required this.icon,
    required this.subMenus,
  });
}

class SubMenuModel {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  SubMenuModel({required this.title, required this.icon, required this.onTap});
}
