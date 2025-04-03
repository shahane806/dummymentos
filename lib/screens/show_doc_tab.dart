import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanningapp/widgets/dropdown_widget.dart';
import 'package:scanningapp/screens/display_documentlist_screen.dart';
import '../bloc/dropdown_category/dropdown_bloc.dart';
import '../bloc/dropdown_category/dropdown_event.dart';
import '../bloc/dropdown_category/dropdown_state.dart';

class ShowDocumentsTab extends StatefulWidget {
  @override
  _ShowDocumentsTabState createState() => _ShowDocumentsTabState();
}

class _ShowDocumentsTabState extends State<ShowDocumentsTab> {
  String? selectedSection;
  String? selectedState;
  String? selectedDistrict;
  String? selectedTaluka;
  String? selectedDocumentFormat;
  String? selectedDocumentType;
  String? documentFormats;
  String? documenttypes;

  @override
  void initState() {
    super.initState();
    context.read<DropdownBloc>().add(LoadSections());
    context.read<DropdownBloc>().add(LoadState());
    context.read<DropdownBloc>().add(LoadDocumentTypes());
    context.read<DropdownBloc>().add(LoadDocumentformats());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ColorfulSafeArea(
      color: Color.fromARGB(134, 25, 153, 213),
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'SHOW DOCUMENTS',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18.0),
            ),
            backgroundColor: Color(0XFF1998d5),
            elevation: 4,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          // drawer: Drawer(
          //   child: ListView(
          //     padding: EdgeInsets.zero,
          //     children: [
          //       DrawerHeader(
          //         decoration: BoxDecoration(
          //           color: Color(0XFF1998d5),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             CircleAvatar(
          //               radius: 40,
          //               backgroundColor: Colors.white,
          //               child: Image.asset(
          //                 "assets/splashLogo.png",
          //                 fit: BoxFit
          //                     .cover, // Ensures the full image fits without cropping
          //                 width:
          //                     60, // Smaller than the diameter (2 * radius = 80)
          //                 height:
          //                     60, // Smaller than the diameter (2 * radius = 80)
          //               ),
          //             ),
          //             SizedBox(height: height / 40),
          //             Text(
          //               'Doc Management',
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 20,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //           ],
          //         ),
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.list),
          //         title: Text('Show Documents'),
          //         onTap: () {
          //           Navigator.pop(context);
          //         },
          //       ),
          //       Divider(),
          //       ListTile(
          //         leading: Icon(Icons.upload_file),
          //         title: Text('Upload Document'),
          //         onTap: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => UploadDocumentTab()));
          //         },
          //       ),
          //       Divider(),
          //       ListTile(
          //         leading: Icon(Icons.folder),
          //         title: Text('Show directory'),
          //         onTap: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => FileExplorerApp()));
          //         },
          //       ),
          //       Divider(),
          //       ListTile(
          //         leading: Icon(Icons.logout),
          //         title: Text('Logout'),
          //         onTap: () async {
          //           SharedPreferences prefs =
          //               await SharedPreferences.getInstance();
          //           await prefs.clear();
          //           Navigator.pushReplacement(context,
          //               MaterialPageRoute(builder: (context) => LoginScreen()));
          //         },
          //       ),
          //       Divider(),
          //     ],
          //   ),
          // ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<DropdownBloc, DropdownState>(
                  builder: (context, state) {
                    return buildDropdown(
                        label: 'Select Section',
                        value: selectedSection,
                        items: state.section,
                        onChanged: (value) {
                          setState(() {
                            selectedSection = value;
                          });
                        },
                        isLoading: state.isSectionLoading);
                  },
                ),
                SizedBox(height: height / 35),
                BlocBuilder<DropdownBloc, DropdownState>(
                  builder: (context, state) {
                    return buildDropdown(
                        label: 'Select State',
                        value: selectedState,
                        items: state.states,
                        onChanged: (value) {
                          context
                              .read<DropdownBloc>()
                              .add(LoadDistrict(value!));
                          setState(() {
                            selectedState = value;
                          });
                        },
                        isLoading: state.isStateLoading);
                  },
                ),
                SizedBox(height: height / 35),
                BlocBuilder<DropdownBloc, DropdownState>(
                  builder: (context, state) {
                    return buildDropdown(
                        label: 'Select District',
                        value: selectedDistrict,
                        items: state.district,
                        onChanged: (value) {
                          context.read<DropdownBloc>().add(LoadTaluka(value!));
                          setState(() {
                            selectedDistrict = value;
                          });
                        },
                        isLoading: state.isDistrictLoading);
                  },
                ),
                SizedBox(height: height / 35),
                BlocBuilder<DropdownBloc, DropdownState>(
                  builder: (context, state) {
                    return buildDropdown(
                        label: 'Select Taluka',
                        value: selectedTaluka,
                        items: state.taluka,
                        onChanged: (value) {
                          setState(() {
                            selectedTaluka = value;
                          });
                        },
                        isLoading: state.isTalukaLoading);
                  },
                ),
                SizedBox(height: height / 35),
                BlocBuilder<DropdownBloc, DropdownState>(
                  builder: (context, state) {
                    return buildDropdown(
                        label: 'Select Document Format',
                        value: selectedDocumentFormat,
                        items: state.documentFormat,
                        onChanged: (value) {
                          setState(() {
                            selectedDocumentFormat = value;
                          });
                        },
                        isLoading: state.isDocumentFormatLoading);
                  },
                ),
                SizedBox(height: height / 35),
                BlocBuilder<DropdownBloc, DropdownState>(
                  builder: (context, state) {
                    return buildDropdown(
                        label: 'Select Document Type',
                        value: selectedDocumentType,
                        items: state.documentType,
                        onChanged: (value) {
                          setState(() {
                            selectedDocumentType = value;
                          });
                        },
                        isLoading: state.isDocumentTypeLoading);
                  },
                ),
                SizedBox(height: height / 35),
                ElevatedButton(
                  onPressed: () {
                    if (selectedDistrict != null &&
                        selectedTaluka != null &&
                        selectedDocumentFormat != null &&
                        selectedDocumentType != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DocumentListScreen(
                                    state: selectedState,
                                    selectedSection: selectedSection,
                                    selectedDistrict: selectedDistrict,
                                    selectedTaluka: selectedTaluka,
                                    selectedDocumentFormat:
                                        selectedDocumentFormat,
                                    selectedDocumentType: selectedDocumentType,
                                  )));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors
                                .white, // Set a clean white background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16.0), // Rounded corners
                            ),
                            title: Text(
                              'All Fields Required',
                              textAlign: TextAlign.center, // Center the title
                              style: TextStyle(
                                color: Colors.red, // Red color to signify error
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0, // Larger size for prominence
                                letterSpacing:
                                    1.2, // Add a little spacing for more elegance
                              ),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange,
                                    size:
                                        40.0, // Add a warning icon for visual emphasis
                                  ),
                                  SizedBox(height: height / 45),
                                  Text(
                                    'Please select all fields before proceeding.',
                                    textAlign:
                                        TextAlign.center, // Center the text
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight
                                          .w500, // Slightly lighter weight for content
                                      height:
                                          1.5, // Add line height for better readability
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 24.0),
                                  decoration: BoxDecoration(
                                    color: Color(
                                        0XFF1998d5), // Blue background for the button
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Rounded corners for the button
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0XFF1998d5).withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(
                                            0, 2), // Subtle shadow effect
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          16.0, // Adjust the font size for the button text
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0XFF1998d5), // Text color
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                    ),
                    textStyle: TextStyle(
                      fontSize: 18.0, // Text size
                      fontWeight: FontWeight.bold, // Text weight
                    ),
                  ),
                  child: Text('Load Documents'),
                ),
              ],
            ),
          )),
    );
  }
}
