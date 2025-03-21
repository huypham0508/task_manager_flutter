import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final List<Color> colorOptions;
  final Function(Color) onColorSelected;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.colorOptions,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children:
          colorOptions.map((color) {
            return InkWell(
              onTap: () => onColorSelected(color),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: selectedColor == color ? 45 : 40,
                height: selectedColor == color ? 45 : 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow:
                      selectedColor == color
                          ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 3,
                            ),
                          ]
                          : [],
                  border: Border.all(
                    color:
                        selectedColor == color
                            ? Colors.black
                            : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
