import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../home/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
      body: HomePage(),
    );
  }
}
