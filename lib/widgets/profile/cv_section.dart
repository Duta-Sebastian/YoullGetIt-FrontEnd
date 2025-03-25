import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/widgets/profile/cv_upload_button.dart';

class CVUploadSection extends StatefulWidget {
  const CVUploadSection({super.key});

  @override
  CVUploadSectionState createState() => CVUploadSectionState();
}

class CVUploadSectionState extends State<CVUploadSection> {
  File? _cvFile;

  Future<void> _pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _cvFile = File(result.files.single.path!);
      });
      
      // Here you would typically implement file upload logic
      // For example, sending the file to a server
      _uploadCV();
    }
  }

  void _uploadCV() {
    if (_cvFile != null) {
      // Implement your CV upload logic here
      // This could involve sending the file to a backend service
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CV Uploaded: ${_cvFile!.path.split('/').last}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
       child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload your CV',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(127, 127, 127, 1)
              ),
            ),
            Text(
              'and get more accurate recommendations',
              style: TextStyle(
                color: Color.fromRGBO(187, 185, 185, 1)
              ),
            ),
            SizedBox(height: 16),
            CVUploadButton(
              onPressed: _pickCV,
              fileName: _cvFile?.path.split('/').last,
            ),
          ],
        ),
      );
  }
}