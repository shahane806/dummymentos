// import 'package:flutter/material.dart';
// import 'package:byte_converter/byte_converter.dart';
// import 'package:scanningapp/models/document_model.dart';

// import '../screens/docs_viewer_screen.dart';
// import 'getdocs_icon.dart';

// Widget buildDocumentCard(DocumentModel document, BuildContext context) {
//   print("document -  ${document.path}");
//   return Card(
//     elevation: 4, // Reduced elevation for a flatter, modern look
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(12),
//     ),
//     color: Colors.white,
//     child: InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => PdfViewer(
//                       fileUrl: document.path,
//                       documentModel: document,
//                     )));
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Opening ${document.path.split('/')[7]}')),
//         );
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Center(
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color:
//                       Color(0XFF1998d5).withOpacity(0.1), // Subtle background
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   getDocumentIcon(document.path.split('/')[7]),
//                   size: 48,
//                   color: Color(0XFF1998d5),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               document.path.split('/')[7],
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 8),

//             // Size and Upload Date in a Column
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.description,
//                       size: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       ByteConverter((double.parse(document.size)))
//                           .toHumanReadable(SizeUnit.MB)
//                           .toString(),
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.calendar_today,
//                       size: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         document.uploadDate,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
