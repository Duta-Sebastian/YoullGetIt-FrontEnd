import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youllgetit_flutter/widgets/profile/cv_upload_button.dart';

class CVUploadSection extends StatefulWidget {
  const CVUploadSection({super.key});

  @override
  CVUploadSectionState createState() => CVUploadSectionState();
}

class CVUploadSectionState extends State<CVUploadSection> {
  File? _cvFile;
  bool _isUploaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _retrieveSavedCV();
  }

  Future<void> _retrieveSavedCV() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final cvFile = File('${directory.path}/saved_cv.pdf');

      if (await cvFile.exists()) {
        if (mounted) {
          setState(() {
            _cvFile = cvFile;
            _isUploaded = true;
          });
        }
      }
    } catch (e) {
      _showSnackBar('Failed to retrieve saved CV: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
    setState(() {
      _isLoading = true;
    });

    try {
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeCV() async {
    if (_cvFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _cvFile?.delete();

      if (mounted) {
        setState(() {
          _cvFile = null;
          _isUploaded = false;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to remove CV: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          ? Center(child: CircularProgressIndicator())
          : (!_isUploaded || _cvFile == null)
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
              color: Color.fromRGBO(127, 127, 127, 1)),
        ),
        Text(
          'and get more accurate recommendations',
          style: TextStyle(color: Color.fromRGBO(187, 185, 185, 1)),
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
