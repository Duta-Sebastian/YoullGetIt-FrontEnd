import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/services/notification_manager.dart';
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
  StreamSubscription? _cvUpdateSubscription;

  @override
  void initState() {
    super.initState();
    
    // Subscribe to CV update notifications
    _cvUpdateSubscription = NotificationManager.instance.onCvUpdated.listen((_) {
      debugPrint('CVUploadSection: Received CV update notification');
      _retrieveSavedCV();
    });
    
    // Initial load
    _retrieveSavedCV();
  }

  @override
  void dispose() {
    // Cancel subscription when widget is disposed
    _cvUpdateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _retrieveSavedCV() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final cvModel = await DatabaseManager.getCv();
      
      if (cvModel != null && cvModel.cvData.isNotEmpty) {
        // Release current file if it exists
        if (_cvFile != null) {
          setState(() {
            _cvFile = null;
          });
          await Future.delayed(Duration(milliseconds: 100));
        }
        
        final directory = await getApplicationDocumentsDirectory();
        final cvFile = File('${directory.path}/saved_cv.pdf');
        
        // Create or overwrite the file
        await cvFile.writeAsBytes(cvModel.cvData);

        if (mounted) {
          setState(() {
            _cvFile = cvFile;
            _isUploaded = true;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _cvFile = null;
            _isUploaded = false;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error retrieving saved CV: $e');
      if (mounted) {
        _showSnackBar('Failed to retrieve saved CV: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickCV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        await _savePDF(File(result.files.single.path!));
      }
    } catch (e) {
      debugPrint('Error picking CV: $e');
      _showSnackBar('Failed to pick CV: $e');
    }
  }

  Future<void> _savePDF(File sourceFile) async {
    try {
      // Read the PDF file
      final Uint8List cvBytes = await sourceFile.readAsBytes();

      // Create CV model
      final cvModel = CvModel(
        cvData: cvBytes,
        lastChanged: DateTime.now(),
      );

      // Update database
      await DatabaseManager.updateCV(cvModel);

      // Release current file if it exists
      if (_cvFile != null) {
        setState(() {
          _cvFile = null;
          _isLoading = true;
        });
        await Future.delayed(Duration(milliseconds: 100));
      }

      // Save to file system
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/saved_cv.pdf';
      final cvFile = File(filePath);
      
      if (await cvFile.exists()) {
        await cvFile.delete();
      }
      await sourceFile.copy(filePath);

      if (mounted) {
        setState(() {
          _cvFile = cvFile;
          _isUploaded = true;
          _isLoading = false;
        });
      }

      _showSnackBar('CV saved successfully');
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      _showSnackBar('Failed to save CV: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeCV() async {
    try {
      // Delete from database
      await DatabaseManager.deleteCV();

      // Release current file reference
      if (mounted) {
        setState(() {
          _cvFile = null;
          _isUploaded = false;
        });
      }

      _showSnackBar('CV removed successfully');
    } catch (e) {
      debugPrint('Error removing CV: $e');
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
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceAround,
          children: [
            SizedBox(width: 8),
            Text(
              'Your CV has been successfully uploaded!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(127, 127, 127, 1),
              ),
              softWrap: true,
            ),
          ],
        ),
        SizedBox(height: 16),
        Center(
          child: SizedBox(
            height: 400,
            width: width * 0.75,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
              ),
              child: _cvFile != null && _cvFile!.path.toLowerCase().endsWith('.pdf')
                ? SfPdfViewer.file(_cvFile!)
                : Text('Document preview not supported'),
            ),
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