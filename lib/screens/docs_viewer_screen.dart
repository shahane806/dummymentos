import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../constants/Apiconst.dart';
import '../models/document_model.dart';

class PdfViewer extends StatefulWidget {
  final String fileUrl;
  final DocumentModel documentModel;

  const PdfViewer({
    super.key,
    required this.fileUrl,
    required this.documentModel,
  });

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  void _navigateBack() {
    Navigator.pop(context); // Navigator.pushReplacement(
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBack();
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Document Viewer",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0XFF1998d5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _navigateBack,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.zoom_in, color: Colors.white),
              onPressed: () => _pdfViewerController.zoomLevel += 0.25,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out, color: Colors.white),
              onPressed: () => _pdfViewerController.zoomLevel -= 0.25,
            ),
          ],
        ),
        body: SfPdfViewer.network(
          Apiconst.Uri + "${widget.fileUrl}",
          controller: _pdfViewerController,
          canShowPaginationDialog: true,
          pageSpacing: 2.0,
          onDocumentLoaded: (details) {
            print("PDF Loaded: ${details.document.toString()}");
          },
          onDocumentLoadFailed: (details) {
            print(
                "Failed to load PDF: ${details.error} - ${details.description}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to load PDF: ${details.error}")),
            );
          },
        ),
      ),
    );
  }
}
