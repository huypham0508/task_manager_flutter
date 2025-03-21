import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app_colors.dart';

class CustomSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool isSuccess = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.darkText),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                isSuccess ? Icons.check_rounded : Icons.error_rounded,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? AppColors.green : AppColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
