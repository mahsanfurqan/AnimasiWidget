import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'widgets/add_new_child_widget.dart';
import 'widgets/create_parent_account_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDE8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final panelWidth = constraints.maxWidth.clamp(320.0, 900.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CreateParentAccountWidget(
                      width: panelWidth,
                      totalStars: 5,
                      initialRating: 0,
                      onRatingChanged: (rating) {
                        debugPrint('Rating dipilih: $rating');
                      },
                    ),
                    const SizedBox(height: 16),
                    AddNewChildWidget(width: panelWidth),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
