import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/api/endpoints/auth.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController otpCtrl = TextEditingController();

  bool _loading = false;
  bool _otpVisible = false;
  String? _errorText;

  String? _requestId;

  @override
  void dispose() {
    phoneCtrl.dispose();
    otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendLogin() async {
    final phone = phoneCtrl.text.trim();
    if (phone.isEmpty) {
      setState(() => _errorText = 'Утасны дугаараа оруулна уу');
      return;
    }

    setState(() {
      _loading = true;
      _errorText = null;
    });

    final res = await AuthApi.login({"phone_number": phone});

    if (!mounted) return;

    if (res.success) {
      setState(() {
        _otpVisible = true;

        // backend data: { request_id: "...", ... } гэж үзэв
        _requestId = res.data?["request_id"]?.toString();
      });

      otpCtrl.text = res.data?['otp_code']?.toString() ?? '';
    } else {
      setState(() {
        _errorText = res.error ?? res.warning ?? res.info ?? "Алдаа гарлаа";
      });
    }

    setState(() => _loading = false);
  }

  Future<void> _verifyOtp() async {
    final phone = phoneCtrl.text.trim();
    final otp = otpCtrl.text.trim();

    if (otp.isEmpty) {
      setState(() => _errorText = 'OTP кодоо оруулна уу');
      return;
    }

    setState(() {
      _loading = true;
      _errorText = null;
    });

    final res = await AuthApi.verifyOtp({
      "phone_number": phone,
      "otp_code": otp,
      if (_requestId != null) "request_id": _requestId,
    });

    if (!mounted) return;

    if (res.success) {
      // backend data: { token: "...", user: {...} } гэх мэт гэж үзэв
      final token = res.data?["token"]?.toString();

      if (token != null) {
        final ok = await ref.read(authProvider.notifier).login(token);

        if (!mounted) return;

        if (ok) {
          context.go('/home');
        } else {
          setState(() {
            _errorText = "Хэрэглэгчийн мэдээлэл авахад алдаа гарлаа";
          });
        }
      }

      // TODO: token хадгалах + navigation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Амжилттай нэвтэрлээ${token != null ? " ✅" : ""}"),
        ),
      );
    } else {
      setState(() {
        _errorText = res.error ?? res.warning ?? res.info ?? "OTP буруу байна";
      });
    }

    setState(() => _loading = false);
  }

  void _resetOtp() {
    setState(() {
      _otpVisible = false;
      _requestId = null;
      _errorText = null;
      otpCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomHeight = _otpVisible
        ? screenHeight *
              0.60 // OTP үед өндөр
        : screenHeight * 0.45; // Энгийн үед

    final imageBottomHeight = -(screenHeight * (_otpVisible ? 0.4 : 0.3));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background Image
          Transform.translate(
            offset: Offset(0, imageBottomHeight),
            child: Image.asset('assets/login_bg.png', fit: BoxFit.cover),
          ),

          /// Overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, MyAppTheme.backdropColor],
              ),
            ),
          ),

          /// Bottom curved panel
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: _TopRoundClipper(curveHeight: SizeConfig.dh(60)),
              child: Container(
                height: bottomHeight,
                width: double.infinity,
                color: theme.colorScheme.background,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      SizeConfig.dw(22),
                      SizeConfig.dh(50),
                      SizeConfig.dw(22),
                      SizeConfig.dh(18),
                    ),
                    child: Column(
                      children: [
                        /// Logo
                        Image.asset(
                          'assets/logo.png',
                          height: SizeConfig.dh(40),
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: SizeConfig.dh(24)),

                        /// Phone label
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Утасны дугаар",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: MyAppTheme.grayColor,
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.sp(12),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.dh(10)),

                        /// Phone input
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(
                              SizeConfig.dw(14),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.dw(14),
                          ),
                          child: TextField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.phone,
                            enabled: !_otpVisible && !_loading,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.sp(16),
                            ),
                            decoration: InputDecoration(
                              hintText: "________",
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: MyAppTheme.grayColor.withOpacity(0.4),
                                fontSize: SizeConfig.sp(16),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        /// OTP input (login success үед гарна)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _otpVisible
                              ? Padding(
                                  key: const ValueKey('otp'),
                                  padding: EdgeInsets.only(
                                    top: SizeConfig.dh(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "OTP код",
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: MyAppTheme.grayColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: SizeConfig.sp(12),
                                              ),
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.dh(10)),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: theme.cardColor,
                                          borderRadius: BorderRadius.circular(
                                            SizeConfig.dw(14),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.dw(14),
                                        ),
                                        child: TextField(
                                          controller: otpCtrl,
                                          keyboardType: TextInputType.number,
                                          maxLength: 6,
                                          enabled: !_loading,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: SizeConfig.sp(16),
                                              ),
                                          decoration: InputDecoration(
                                            counterText: "",
                                            hintText: "______",
                                            hintStyle: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: MyAppTheme.grayColor
                                                      .withOpacity(0.4),
                                                  fontSize: SizeConfig.sp(16),
                                                ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.dh(6)),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton(
                                          onPressed: _loading
                                              ? null
                                              : _resetOtp,
                                          child: const Text("Дугаар солих"),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(key: ValueKey('no-otp')),
                        ),

                        /// Error text
                        if (_errorText != null) ...[
                          SizedBox(height: SizeConfig.dh(10)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _errorText!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.redAccent,
                                fontSize: SizeConfig.sp(12),
                              ),
                            ),
                          ),
                        ],

                        const Spacer(),

                        /// Button
                        SizedBox(
                          width: double.infinity,
                          height: SizeConfig.dh(48),
                          child: ElevatedButton(
                            onPressed: _loading
                                ? null
                                : (_otpVisible ? _verifyOtp : _sendLogin),
                            child: _loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _otpVisible ? "Баталгаажуулах" : "Нэвтрэх",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: SizeConfig.sp(15),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopRoundClipper extends CustomClipper<Path> {
  final double curveHeight;
  _TopRoundClipper({required this.curveHeight});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, curveHeight);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width, curveHeight);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _TopRoundClipper oldClipper) =>
      oldClipper.curveHeight != curveHeight;
}
