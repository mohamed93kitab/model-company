import 'package:bab_algharb/theme.dart';
import 'package:flutter/material.dart';
class VirtualScreen extends StatefulWidget {
  const VirtualScreen();

  @override
  State<VirtualScreen> createState() => _VirtualScreenState();
}

class _VirtualScreenState extends State<VirtualScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light_bg,
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Text("لا يمكنك إستخدام نسخة مزيفة من التطبيق!"),
      ),
    );
  }
}
