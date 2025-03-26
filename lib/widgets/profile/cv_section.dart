import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/widgets/profile/cv_upload_button.dart';

class CVUploadSection extends StatefulWidget {
  const CVUploadSection({super.key});

  @override
  CVUploadSectionState createState() => CVUploadSectionState();
}

class CVUploadSectionState extends State<CVUploadSection> {
  File? _cvFile;
  bool _isUploaded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _retrieveSavedCV();
  }

  Future<void> _retrieveSavedCV() async {
    try {
      final cvModel = await DatabaseManager.getCv();
      
      if (cvModel != null) {
        final directory = await getApplicationDocumentsDirectory();
        final cvFile = File('${directory.path}/saved_cv.pdf');
        await cvFile.writeAsBytes(cvModel.cvData);

        if (mounted) {
          setState(() {
            _cvFile = cvFile;
            _isUploaded = true;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to retrieve saved CV: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      await _savePDF(File(result.files.single.path!));
    }
  }

  Future<void> _savePDF(File sourceFile) async {
    try {
      final Uint8List cvBytes = await sourceFile.readAsBytes();

      final cvModel = CvModel(
        cvData: cvBytes,
        lastChanged: DateTime.now(),
      );

      await DatabaseManager.updateCV(cvModel);

      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/saved_cv.pdf';
      await sourceFile.copy(filePath);

      if (mounted) {
        setState(() {
          _cvFile = File(filePath);
          _isUploaded = true;
        });
      }

      _showSnackBar('CV saved successfully');
    } catch (e) {
      _showSnackBar('Failed to save CV: $e');
    }
  }

  Future<void> _removeCV() async {
    try {
      await DatabaseManager.deleteCV();

      if (mounted) {
        setState(() {
          _cvFile = null;
          _isUploaded = false;
        });
      }

      _showSnackBar('CV removed successfully');
    } catch (e) {
      _showSnackBar('Failed to remove CV: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _cvFile == null || !_isUploaded
          ? _buildUploadSection()
          : _buildUploadedView(),
    );
  }

  Widget _buildUploadSection() {
    return Column(
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
    );
  }

  Widget _buildUploadedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 8),
            Text(
              'Your CV has been successfully uploaded!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(127, 127, 127, 1),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 400,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: _cvFile!.path.toLowerCase().endsWith('.pdf')
              ? SfPdfViewer.file(_cvFile!)
              : Text('Document preview not supported'),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.create),
            onPressed: () => _removeCV(),
          ),
        ),
      ],
    );
  }
}