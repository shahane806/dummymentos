// import 'package:flutter/material.dart';
// import 'show_doc_tab.dart';
// import 'upload_doc_tab.dart';

// class DocumentScreen extends StatefulWidget {
//   @override
//   _DocumentScreenState createState() => _DocumentScreenState();
// }

// class _DocumentScreenState extends State<DocumentScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Doc Management',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//         elevation: 4,
//         iconTheme: IconThemeData(color: Colors.white),
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           indicatorColor: Colors.white,
//           tabs: const [
//             Tab(text: 'Show Documents'),
//             Tab(text: 'Upload Document'),
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blueAccent),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Doc Management',
//                     style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.upload_file),
//               title: Text('Upload Document'),
//               onTap: () {
//                 _tabController.animateTo(1);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.list),
//               title: Text('Show Documents'),
//               onTap: () {
//                 _tabController.animateTo(0);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         physics: NeverScrollableScrollPhysics(), // Prevents laggy swipes
//         children: [
//           ShowDocumentsTab(),
//           UploadDocumentTab(),
//         ],
//       ),
//     );
//   }
// }
