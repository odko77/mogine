import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  final TextEditingController _codeCtrl = TextEditingController();

  bool _handled = false;
  bool _torchOn = false;

  @override
  void dispose() {
    _scannerController.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _goNext(String code) {
    final v = code.trim();
    if (v.isEmpty || _handled) return;

    _handled = true;
    context.push('/add-device-detail', extra: v).then((_) {
      _handled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: MyAppTheme.bgColor,
      appBar: AppBar(title: const Text('Төхөөрөмж нэмэх'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.dw(14)),
          child: Column(
            children: [
              Container(
                height: SizeConfig.dh(280),
                decoration: BoxDecoration(
                  color: MyAppTheme.cardColor,
                  borderRadius: BorderRadius.circular(SizeConfig.dw(18)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SizeConfig.dw(18)),
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: (capture) {
                          final barcodes = capture.barcodes;
                          if (barcodes.isEmpty) return;

                          final raw = barcodes.first.rawValue ?? '';
                          if (raw.isNotEmpty) {
                            _codeCtrl.text = raw;
                            _goNext(raw);
                          }
                        },
                      ),

                      Center(
                        child: Container(
                          width: SizeConfig.dw(200),
                          height: SizeConfig.dw(200),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MyAppTheme.secondaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(
                              SizeConfig.dw(16),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: SizeConfig.dh(12),
                        right: SizeConfig.dw(12),
                        child: InkWell(
                          onTap: () async {
                            await _scannerController.toggleTorch();
                            setState(() {
                              _torchOn = !_torchOn;
                            });
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: SizeConfig.dw(42),
                            height: SizeConfig.dw(42),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _torchOn ? Icons.flash_on : Icons.flash_off,
                              color: Colors.white,
                              size: SizeConfig.dw(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.dh(18)),

              Text(
                'QR код уншуулна уу',
                style: TextStyle(
                  color: MyAppTheme.textColor,
                  fontSize: SizeConfig.sp(15),
                  fontWeight: FontWeight.w800,
                ),
              ),

              SizedBox(height: SizeConfig.dh(8)),

              Text(
                'Хэрэв QR уншигдахгүй бол доорх талбарт төхөөрөмжийн кодыг гараар оруулна уу.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyAppTheme.grayColor,
                  fontSize: SizeConfig.sp(11),
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: SizeConfig.dh(18)),

              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.dw(14)),
                decoration: BoxDecoration(
                  color: MyAppTheme.cardColor,
                  borderRadius: BorderRadius.circular(SizeConfig.dw(14)),
                ),
                child: TextField(
                  controller: _codeCtrl,
                  style: TextStyle(
                    color: MyAppTheme.textColor,
                    fontSize: SizeConfig.sp(14),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ж: MNG-DEVICE-001',
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.dh(14)),

              SizedBox(
                width: double.infinity,
                height: SizeConfig.dh(48),
                child: ElevatedButton(
                  onPressed: () => _goNext(_codeCtrl.text),
                  child: Text(
                    'Үргэлжлүүлэх',
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
      ),
    );
  }
}
