import 'package:flutter/material.dart';
import '../../../viewmodels/home_viewmodel.dart';

class MealSelector extends StatelessWidget {
  final TipoRefeicao selectedMeal;
  final ValueChanged<TipoRefeicao> onMealChanged;

  const MealSelector({
    super.key,
    required this.selectedMeal,
    required this.onMealChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEF5),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildPill(
              label: 'Almoço',
              icon: Icons.wb_sunny_outlined,
              isSelected: selectedMeal == TipoRefeicao.almoco,
              onTap: () => onMealChanged(TipoRefeicao.almoco),
            ),
          ),
          Expanded(
            child: _buildPill(
              label: 'Jantar',
              icon: Icons.nightlight_outlined,
              isSelected: selectedMeal == TipoRefeicao.jantar,
              onTap: () => onMealChanged(TipoRefeicao.jantar),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003366) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF003366).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF5A6E85),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF5A6E85),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
