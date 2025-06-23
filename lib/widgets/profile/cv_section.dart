import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/services/job_api.dart';
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
        final localizations = AppLocalizations.of(context)!;
        _showSnackBar('${localizations.cvRetrieveError}: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickCV() async {
    final localizations = AppLocalizations.of(context)!;
    
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
      if (mounted) {
        _showSnackBar('${localizations.cvPickError}: $e');
      }
    }
  }

  // New method for editing/replacing CV directly
  Future<void> _editCV() async {
    final localizations = AppLocalizations.of(context)!;
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        await _savePDF(File(result.files.single.path!));
        if (mounted) {
          _showSnackBar(localizations.cvUpdateSuccess);
        }
      }
    } catch (e) {
      debugPrint('Error updating CV: $e');
      if (mounted) {
        _showSnackBar('${localizations.cvUpdateError}: $e');
      }
    }
  }

  Future<void> _savePDF(File sourceFile) async {
    final localizations = AppLocalizations.of(context)!;
    
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
      await JobApi.uploadUserInformation( true, null);

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
        _showSnackBar(localizations.cvSaveSuccess);
      }
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      if (mounted) {
        _showSnackBar('${localizations.cvSaveError}: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeCV() async {
    final localizations = AppLocalizations.of(context)!;
    
    try {
      // Delete from database
      await DatabaseManager.deleteCV();

      // Release current file reference
      if (mounted) {
        setState(() {
          _cvFile = null;
          _isUploaded = false;
        });
        _showSnackBar(localizations.cvRemoveSuccess);
      }
    } catch (e) {
      debugPrint('Error removing CV: $e');
      if (mounted) {
        _showSnackBar('${localizations.cvRemoveError}: $e');
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
        ? const Center(child: CircularProgressIndicator()) 
        : _cvFile == null || !_isUploaded
          ? _buildUploadSection()
          : _buildUploadedView(),
    );
  }

  Widget _buildUploadSection() {
    final localizations = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.profileUploadCvTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(127, 127, 127, 1)
          ),
        ),
        Text(
          localizations.uploadCvSubtitle,
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
    final localizations = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceAround,
          children: [
            SizedBox(width: 8),
            Text(
              localizations.cvUploadSuccess,
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
                ? SfPdfViewer.file(
                    _cvFile!,
                    scrollDirection: PdfScrollDirection.horizontal,
                    canShowPageLoadingIndicator: false,
                    canShowPaginationDialog: false,
                    canShowSignaturePadDialog: false,
                    canShowScrollHead: false,
                    canShowScrollStatus: false,
                  )
                : Text(localizations.documentPreviewNotSupported),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFFFFDE15)),
              onPressed: _editCV,
              tooltip: localizations.replaceCvTooltip,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _removeCV,
              tooltip: localizations.deleteCvTooltip,
            ),
          ],
        ),
      ],
    );
  }
}