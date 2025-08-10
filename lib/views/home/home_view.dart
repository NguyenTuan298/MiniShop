import 'package:flutter/material.dart';
import 'package:minishop/utils/theme.dart';
import 'package:minishop/widgets/news_card.dart';
import 'package:minishop/widgets/welcome_banner.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Image.asset('assets/images/logo.png'), // Thay bằng logo của bạn
        ),
        leadingWidth: 50,
        title: const Text("Minishop"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeBanner(),
              const SizedBox(height: 24),
              const Text(
                'Tin nổi bật',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              const NewsCard(),
            ],
          ),
        ),
      ),
    );
  }
}