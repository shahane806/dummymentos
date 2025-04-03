// Helper method to assign icons based on file extension
import 'package:flutter/material.dart';

IconData getDocumentIcon(String title) {
  if (title.toLowerCase().endsWith('.pdf')) {
    return Icons.picture_as_pdf;
  } else if (title.toLowerCase().endsWith('.docx')) {
    return Icons.description;
  } else if (title.toLowerCase().endsWith('.xlsx')) {
    return Icons.table_chart;
  }
  return Icons.insert_drive_file; // Default icon
}
