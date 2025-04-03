import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanningapp/bloc/dropdown_category/dropdown_bloc.dart';
import 'package:scanningapp/bloc/dropdown_category/dropdown_event.dart';
import 'package:scanningapp/bloc/dropdown_category/dropdown_state.dart';
import 'package:scanningapp/bloc/password_protector_bloc/password_protector_bloc.dart';
import 'package:scanningapp/bloc/password_protector_bloc/password_protector_event.dart';
import 'package:scanningapp/bloc/password_protector_bloc/password_protector_state.dart';
import 'package:scanningapp/constants/enums.dart';
import '../bloc/upload_docs/upload_docs_bloc.dart';
import '../bloc/upload_docs/upload_docs_event.dart';
import '../bloc/upload_docs/upload_docs_state.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/snackbarhelper.dart';

class UploadDocumentTab extends StatefulWidget {
  @override
  _UploadDocumentTabState createState() => _UploadDocumentTabState();
}

class _UploadDocumentTabState extends State<UploadDocumentTab> {
  String? selectedSection;
  String? selectedState;
  String? selectedDistrict;
  String? selectedTaluka;
  String? selectedDocumentFormat;
  String? selectedDocumentType;
  String? documentFormats;
  String? documenttypes;

  TextEditingController remarked = TextEditingController();
  TextEditingController password = TextEditingController();

  PlatformFile? selectedFile;

  @override
  void initState() {
    super.initState();
    context.read<DropdownBloc>().add(LoadSections());
    context.read<DropdownBloc>().add(LoadState());
    context.read<DropdownBloc>().add(LoadDocumentTypes());
    context.read<DropdownBloc>().add(LoadDocumentformats());
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'doc', 'docx'],
        withData: true,
      );

      if (result != null) {
        setState(() {
          selectedFile = result.files.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return ColorfulSafeArea(
      color: Color.fromARGB(134, 25, 153, 213),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'UPLOAD DOCUMENTS',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18.0),
          ),
          backgroundColor: Color(0XFF1998d5),
          elevation: 4,
          iconTheme: IconThemeData(color: Colors.white),
        ),
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
                        context.read<DropdownBloc>().add(LoadDistrict(value!));
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
              _buildFilePickerCard(height)
            ],
          ),
        ),
      ),
    );
  }

  // void _showPasswordDialog() {}

  Widget _buildFilePickerCard(double height) {
    return Column(
      children: [
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
        InkWell(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0XFF1998d5), width: 1.5),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedFile?.name ?? 'Tap to Select a File',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selectedFile == null ? Colors.grey : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.upload_file,
                  color: Color(0XFF1998d5),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: height / 35),
        Container(
          padding: EdgeInsets.all(16), // Padding for spacing
          decoration: BoxDecoration(
            color: Colors.white, // White background
            borderRadius: BorderRadius.circular(10), // Rounded corners
            border: Border.all(
              color: Colors.blueAccent, // Blue border
              width: 2, // Border width
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.1), // Light blue shadow
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Slight elevation
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Is this file password protected?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Bold text for emphasis
                  color: Colors.black87, // Darker color for better visibility
                ),
              ),
              SizedBox(height: 12), // More spacing for better layout
              BlocBuilder<PasswordProtectorBloc, PasswordProtectorState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: state.ispassprotected,
                            activeColor: Colors.blueAccent
                                .withOpacity(0.2), // Blue when selected
                            onChanged: (value) {
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevent closing without action
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Enter Password for the File"),
                                    content: TextField(
                                      controller: password,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: "Enter Password",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<PasswordProtectorBloc>()
                                              .add(PasswordProtectorEvent(
                                                  ispassprotect: false));
                                          Navigator.of(context)
                                              .pop(); // Close dialog
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (password.text.isEmpty ||
                                              password.text.toString() == '') {
                                            Snackbarhelper.showsnackbar(
                                                context,
                                                'enter the password',
                                                Colors.red,
                                                1);
                                          } else {
                                            context
                                                .read<PasswordProtectorBloc>()
                                                .add(PasswordProtectorEvent(
                                                    ispassprotect: value));
                                            Snackbarhelper.showsnackbar(
                                                context,
                                                'Password attach Successfully',
                                                Colors.green,
                                                1);
                                            Navigator.of(context).pop();
                                          }
                                          // Close dialog
                                        },
                                        child: Text("Save"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(width: 20), // Space between radio buttons
                      Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: state.ispassprotected,
                            activeColor: Colors.blueAccent,
                            onChanged: (value) {
                              context.read<PasswordProtectorBloc>().add(
                                  PasswordProtectorEvent(ispassprotect: value));

                              password.text = '';
                              remarked.text = '';
                            },
                          ),
                          Text(
                            "No",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              TextField(
                controller: remarked,
                decoration: InputDecoration(
                  labelText: "Enter Remark",
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height / 35),
        BlocListener<UploadDocsBloc, UploadDocsState>(
          listener: (context, state) {
            if (state.uploadDocStatus == UploadDocStatus.success) {
              Snackbarhelper.showsnackbar(
                context,
                "Document Uploaded Successfully",
                Color(0XFF1998d5),
                1,
              );
            }
          },
          child: BlocBuilder<UploadDocsBloc, UploadDocsState>(
            builder: (context, state) {
              print("password.text ${password.text}");
              return ElevatedButton(
                onPressed: () {
                  if (selectedSection == null ||
                      selectedDistrict == null ||
                      selectedTaluka == null ||
                      selectedDocumentFormat == null ||
                      selectedDocumentType == null ||
                      selectedFile == null) {
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
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                  size:
                                      40.0, // Add a warning icon for visual emphasis
                                ),
                                Text(
                                  'Please select all fields before proceeding.',
                                  textAlign:
                                      TextAlign.center, // Center the text
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight
                                        .w500, // Slightly lighter weight for content
                                    // Add line height for better readability
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 24.0),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .blue, // Blue background for the button
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Rounded corners for the button
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.2),
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
                        });
                  } else {
                    context.read<UploadDocsBloc>().add(UploadDocsEvent(
                        section: selectedSection.toString(),
                        state: selectedState.toString(),
                        district: selectedDistrict.toString(),
                        taluka: selectedTaluka.toString(),
                        docformat: selectedDocumentFormat.toString(),
                        doctype: selectedDocumentType.toString(),
                        password: password.text,
                        remarked: remarked.text,
                        docId: DateTime.now().millisecondsSinceEpoch.toString(),
                        documentFile: selectedFile!));
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
                child: state.uploadDocStatus == UploadDocStatus.loading
                    ? SizedBox(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3.0,
                        ),
                      )
                    : Text('Upload Documents'),
              );
            },
          ),
        )
      ],
    );
  }
}
