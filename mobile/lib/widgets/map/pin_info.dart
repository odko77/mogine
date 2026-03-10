import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/providers/point_provider.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class PinTrackerSheet extends ConsumerStatefulWidget {
  final LatLng latLng;

  const PinTrackerSheet({super.key, required this.latLng});

  @override
  ConsumerState<PinTrackerSheet> createState() => _PinTrackerSheetState();
}

class _PinTrackerSheetState extends ConsumerState<PinTrackerSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(mapPointsProvider.notifier)
        .add(widget.latLng, _controller.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        // margin: EdgeInsets.all(SizeConfig.dw(12)),
        padding: EdgeInsets.all(SizeConfig.dw(12)),
        decoration: BoxDecoration(
          color: MyAppTheme.bgColor,
          borderRadius: BorderRadius.circular(SizeConfig.dw(20)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: SizeConfig.dw(40),
                height: SizeConfig.dh(4),
                margin: EdgeInsets.only(bottom: SizeConfig.dh(12)),
                decoration: BoxDecoration(
                  color: MyAppTheme.grayColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // ── Гарчиг мөр ──────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: SizeConfig.dw(56),
                    height: SizeConfig.dw(56),
                    decoration: BoxDecoration(
                      color: MyAppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: MyAppTheme.secondaryColor,
                      size: SizeConfig.dw(28),
                    ),
                  ),

                  SizedBox(width: SizeConfig.dw(10)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Шинэ цэг',
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
                              Icons.swap_vert,
                              size: SizeConfig.dw(14),
                              color: MyAppTheme.secondaryColor,
                            ),
                            SizedBox(width: SizeConfig.dw(4)),
                            Text(
                              'Өргөрөг: ${widget.latLng.latitude.toStringAsFixed(6)}',
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
                              Icons.swap_horiz,
                              size: SizeConfig.dw(14),
                              color: MyAppTheme.secondaryColor,
                            ),
                            SizedBox(width: SizeConfig.dw(4)),
                            Text(
                              'Уртраг: ${widget.latLng.longitude.toStringAsFixed(6)}',
                              style: TextStyle(
                                color: MyAppTheme.grayColor,
                                fontSize: SizeConfig.sp(11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.dh(16)),

              // ── Нэр оруулах ─────────────────────────────────────────────
              TextFormField(
                controller: _controller,
                autofocus: false,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                style: TextStyle(
                  color: MyAppTheme.textColor,
                  fontSize: SizeConfig.sp(13),
                ),
                decoration: InputDecoration(
                  labelText: 'Цэгийн нэр',
                  labelStyle: TextStyle(
                    color: MyAppTheme.grayColor,
                    fontSize: SizeConfig.sp(13),
                  ),
                  hintText: 'Жишээ: Гэр, Офис...',
                  hintStyle: TextStyle(
                    color: MyAppTheme.grayColor.withOpacity(0.5),
                    fontSize: SizeConfig.sp(13),
                  ),
                  prefixIcon: Icon(
                    Icons.label_outline,
                    color: MyAppTheme.secondaryColor,
                    size: SizeConfig.dw(18),
                  ),
                  filled: true,
                  fillColor: MyAppTheme.primaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
                    borderSide: BorderSide(
                      color: MyAppTheme.secondaryColor,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
                    borderSide: const BorderSide(color: Colors.redAccent),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.dw(12)),
                    borderSide: const BorderSide(color: Colors.redAccent),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Нэр оруулна уу' : null,
              ),

              SizedBox(height: SizeConfig.dh(12)),

              // ── Товчнууд ─────────────────────────────────────────────────
              Row(
                children: [
                  // Хаах
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MyAppTheme.textColor,
                        side: BorderSide(
                          color: MyAppTheme.grayColor.withOpacity(0.3),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.dh(13),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.dw(12),
                          ),
                        ),
                      ),
                      child: const Text('Хаах'),
                    ),
                  ),

                  SizedBox(width: SizeConfig.dw(10)),

                  // Хадгалах
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: MyAppTheme.secondaryColor,
                        foregroundColor: MyAppTheme.bgColor,
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.dh(13),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.dw(12),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.save_outlined, size: SizeConfig.dw(18)),
                      label: const Text('Хадгалах'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
