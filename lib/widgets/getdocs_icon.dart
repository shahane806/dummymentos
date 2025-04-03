import 'package:flutter/material.dart';

IconData getDocumentIcon(String title,
    {Color? pdfColor, Color? docxColor, Color? docColor, Color? xlsxColor}) {
  if (title.toLowerCase().endsWith('.pdf')) {
    return Icons.picture_as_pdf;
  } else if (title.toLowerCase().endsWith('.doc')) {
    return Icons.description; // or Icons.text_snippet
  } else if (title.toLowerCase().endsWith('.docx')) {
    return Icons.description;
  } else if (title.toLowerCase().endsWith('.xlsx')) {
    return Icons.table_chart;
  } else if (title.toLowerCase().endsWith('.txt')) {
    return Icons.text_snippet;
  } else if (title.toLowerCase().endsWith('.png') ||
      title.toLowerCase().endsWith('.jpg') ||
      title.toLowerCase().endsWith('.jpeg')) {
    return Icons.image;
  } else if (title.toLowerCase().endsWith('.zip') ||
      title.toLowerCase().endsWith('.rar')) {
    return Icons.archive;
  } else if (title.toLowerCase().endsWith('.mp4') ||
      title.toLowerCase().endsWith('.avi') ||
      title.toLowerCase().endsWith('.mov')) {
    return Icons.movie;
  } else if (title.toLowerCase().endsWith('.mp3') ||
      title.toLowerCase().endsWith('.wav')) {
    return Icons.music_note;
  }
  return Icons.insert_drive_file; // Default icon
}

Color getDocumentIconColor(String title) {
  if (title.toLowerCase().endsWith('.pdf')) {
    return Colors.red;
  } else if (title.toLowerCase().endsWith('.doc')) {
    return Colors.blue;
  } else if (title.toLowerCase().endsWith('.docx')) {
    return Colors.blue;
  } else if (title.toLowerCase().endsWith('.xlsx')) {
    return Colors.green;
  } else if (title.toLowerCase().endsWith('.txt')) {
    return Colors.orange;
  } else if (title.toLowerCase().endsWith('.png') ||
      title.toLowerCase().endsWith('.jpg') ||
      title.toLowerCase().endsWith('.jpeg')) {
    return Colors.purple;
  } else if (title.toLowerCase().endsWith('.zip') ||
      title.toLowerCase().endsWith('.rar')) {
    return Colors.brown;
  } else if (title.toLowerCase().endsWith('.mp4') ||
      title.toLowerCase().endsWith('.avi') ||
      title.toLowerCase().endsWith('.mov')) {
    return Colors.deepPurpleAccent;
  } else if (title.toLowerCase().endsWith('.mp3') ||
      title.toLowerCase().endsWith('.wav')) {
    return Colors.lightBlue;
  }
  return Colors.grey; // Default color
}
