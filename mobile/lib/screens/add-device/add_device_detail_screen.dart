import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class AddDeviceDetailScreen extends StatefulWidget {
  final String deviceCode;

  const AddDeviceDetailScreen({super.key, required this.deviceCode});

  @override
  State<AddDeviceDetailScreen> createState() => _AddDeviceDetailScreenState();
}

class _AddDeviceDetailScreenState extends State<AddDeviceDetailScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  String? _animalType;

  final List<_AnimalTypeItem> _types = const [
    _AnimalTypeItem(label: 'Морь', value: 'horse', emoji: '🐎'),
    _AnimalTypeItem(label: 'Үхэр', value: 'cow', emoji: '🐄'),
    _AnimalTypeItem(label: 'Тэмээ', value: 'camel', emoji: '🐫'),
    _AnimalTypeItem(label: 'Хонь', value: 'sheep', emoji: '🐑'),
    _AnimalTypeItem(label: 'Ямаа', value: 'goat', emoji: '🐐'),
    _AnimalTypeItem(label: 'Бусад', value: 'other', emoji: '🐾'),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  // Future<void> _pickImage() async {
  //   // final file = await _picker.pickImage(
  //   //   source: ImageSource.gallery,
  //   //   imageQuality: 85,
  //   // );
  //   // if (file == null) return;

  //   // setState(() {
  //   //   _imageFile = File(file.path);
  //   // });
  // }

  Future<void> _pickImage() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (file == null) {
        debugPrint('Image picking cancelled');
        return;
      }

      setState(() {
        _imageFile = File(file.path);
      });
    } catch (e, st) {
      debugPrint('pick image error: $e');
      debugPrintStack(stackTrace: st);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Зураг сонгох үед алдаа гарлаа: $e')),
      );
    }
  }

  void _submit() {
    final name = _nameCtrl.text.trim();

    if (name.isEmpty) {
      _showMsg('Нэр оруулна уу');
      return;
    }
    if (_animalType == null) {
      _showMsg('Төрөл сонгоно уу');
      return;
    }

    // TODO:
    // image upload
    // save api call
    // device bind api call

    _showMsg('Төхөөрөмж амжилттай нэмэгдэхэд бэлэн боллоо');
  }

  void _showMsg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: MyAppTheme.bgColor,
      appBar: AppBar(
        title: const Text('Төхөөрөмжийн мэдээлэл'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(SizeConfig.dw(14)),
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.dw(12)),
              decoration: BoxDecoration(
                color: MyAppTheme.cardColor,
                borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code_2,
                    color: MyAppTheme.secondaryColor,
                    size: SizeConfig.dw(22),
                  ),
                  SizedBox(width: SizeConfig.dw(10)),
                  Expanded(
                    child: Text(
                      widget.deviceCode,
                      style: TextStyle(
                        color: MyAppTheme.textColor,
                        fontSize: SizeConfig.sp(14),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: SizeConfig.dh(14)),

            Text(
              'Зураг',
              style: TextStyle(
                color: MyAppTheme.textColor,
                fontSize: SizeConfig.sp(13),
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: SizeConfig.dh(8)),

            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
              child: Container(
                height: SizeConfig.dh(180),
                decoration: BoxDecoration(
                  color: MyAppTheme.cardColor,
                  borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
                  border: Border.all(
                    color: MyAppTheme.primaryColor,
                    width: 1.5,
                  ),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(SizeConfig.dw(16)),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: MyAppTheme.grayColor,
                            size: SizeConfig.dw(28),
                          ),
                          SizedBox(height: SizeConfig.dh(8)),
                          Text(
                            'Зураг сонгох',
                            style: TextStyle(
                              color: MyAppTheme.grayColor,
                              fontSize: SizeConfig.sp(12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            SizedBox(height: SizeConfig.dh(14)),

            Text(
              'Нэр',
              style: TextStyle(
                color: MyAppTheme.textColor,
                fontSize: SizeConfig.sp(13),
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: SizeConfig.dh(8)),

            Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.dw(14)),
              decoration: BoxDecoration(
                color: MyAppTheme.cardColor,
                borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
              ),
              child: TextField(
                controller: _nameCtrl,
                style: TextStyle(
                  color: MyAppTheme.textColor,
                  fontSize: SizeConfig.sp(14),
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ж: Хонгор азарга',
                ),
              ),
            ),

            SizedBox(height: SizeConfig.dh(14)),

            Text(
              'Төрөл',
              style: TextStyle(
                color: MyAppTheme.textColor,
                fontSize: SizeConfig.sp(13),
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: SizeConfig.dh(8)),

            Wrap(
              spacing: SizeConfig.dw(8),
              runSpacing: SizeConfig.dh(8),
              children: _types.map((e) {
                final selected = _animalType == e.value;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _animalType = e.value;
                    });
                  },
                  borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.dw(12),
                      vertical: SizeConfig.dh(10),
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? MyAppTheme.secondaryColor
                          : MyAppTheme.cardColor,
                      borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e.emoji,
                          style: TextStyle(fontSize: SizeConfig.sp(14)),
                        ),
                        SizedBox(width: SizeConfig.dw(6)),
                        Text(
                          e.label,
                          style: TextStyle(
                            color: selected
                                ? MyAppTheme.primaryColor
                                : MyAppTheme.textColor,
                            fontSize: SizeConfig.sp(12),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: SizeConfig.dh(20)),

            SizedBox(
              width: double.infinity,
              height: SizeConfig.dh(48),
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(
                  'Хадгалах',
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

class _AnimalTypeItem {
  final String label;
  final String value;
  final String emoji;

  const _AnimalTypeItem({
    required this.label,
    required this.value,
    required this.emoji,
  });
}
