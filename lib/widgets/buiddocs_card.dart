import 'dart:io';

import 'package:flutter/material.dart';
import 'package:byte_converter/byte_converter.dart';
import 'package:scanningapp/constants/Apiconst.dart';
import 'package:scanningapp/models/document_model.dart';

import 'getdocs_icon.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

import 'package:http/http.dart' as http;

import 'snackbarhelper.dart';

Future<void> openFile(String filePath, BuildContext context) async {
  await OpenFilex.open(filePath);
}

Future<void> downloadAndOpenFile(String fileUrl, BuildContext context) async {
  try {
    var status = await Permission.manageExternalStorage
        .request(); // Use Permission.storage
    if (status.isGranted) {
      final response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        var filePath = "";
        if (fileUrl.toLowerCase().endsWith('.pdf')) {
          filePath =
              '${directory.path}/document.pdf'; // Construct local file path
        } else if (fileUrl.toLowerCase().endsWith('.doc')) {
          filePath =
              '${directory.path}/document.doc'; // Construct local file path
        } else if (fileUrl.toLowerCase().endsWith('.xlsx')) {
          filePath =
              '${directory.path}/document.xlsx'; // Construct local file path
        } else if (fileUrl.toLowerCase().endsWith('.jpg')) {
          filePath =
              '${directory.path}/document.jpg'; // Construct local file path
        }
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        openFile(filePath, context);
      } else {
        Snackbarhelper.showsnackbar(
            context, "Download failed", Colors.red, 3); // More specific error
      }
    } else {
      Snackbarhelper.showsnackbar(
          context, "Storage permission denied", Colors.red, 3);
    }
  } catch (e) {
    print('Error downloading file: $e');
    Snackbarhelper.showsnackbar(
        context, "Error downloading file", Colors.red, 3);
  }
}

Widget buildDocumentCard(DocumentModel document, BuildContext context) {
  return Card(
    elevation: 4, // Reduced elevation for a flatter, modern look
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: Colors.white,
    child: InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PdfViewer(
        //               fileUrl: document.path,
        //               documentModel: document,
        //             )));
        downloadAndOpenFile(Apiconst.Uri + "${document.path}", context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${document.path.split('/')[7]}')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Make Column take only necessary space
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0XFF1998d5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      getDocumentIcon(document.path.split('/')[7]),
                      size: 48,
                      color: getDocumentIconColor(document.path.split('/')[7]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              document.path.split('/')[7],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Size and Upload Date in a Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.description,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      ByteConverter((double.parse(document.size)))
                          .toHumanReadable(SizeUnit.MB)
                          .toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        document.uploadDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
