import 'package:flutter/material.dart';

Widget buildDropdown(
    {required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isLoading = false}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color(0xFFE0E0E0), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Color(0xFFE0E0E0).withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        hint: Row(
          children: [
            if (isLoading)
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF78909C),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: Color(0xFF2196F3),
          size: 24,
        ),
        style: TextStyle(
          color: Color(0xFF263238),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        items: isLoading
            ? []
            : items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
        dropdownColor: Colors.white,
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
