import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/screens/recommendation_processing_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

class EntryUploadCvScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> answers;
  final bool isShortQuestionnaire;

  const EntryUploadCvScreen({
    super.key,
    required this.answers,
    required this.isShortQuestionnaire,
  });

  @override
  ConsumerState<EntryUploadCvScreen> createState() => StandaloneCVScreenState();
}

class StandaloneCVScreenState extends ConsumerState<EntryUploadCvScreen> {
  File? _tempCvFile;
  bool _isLoading = false;
  Map<String, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    _answers = widget.answers;
  }

  @override
  void dispose() {
    _deleteTempFile();
    super.dispose();
  }

  Future<void> _deleteTempFile() async {
    if (_tempCvFile != null && await _tempCvFile!.exists()) {
      try {
        await _tempCvFile!.delete();
      } catch (e) {
        debugPrint('Error deleting temp file: $e');
      } finally {
        setState(() {
          _tempCvFile = null;
        });
      }
    }
  }

  Future<void> _pickCV() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _deleteTempFile();

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final sourceFile = File(result.files.single.path!);
        
        final directory = await getTemporaryDirectory();
        final String filePath = '${directory.path}/temp_cv_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final tempFile = File(filePath);
        
        await sourceFile.copy(filePath);

        if (mounted) {
          setState(() {
            _tempCvFile = tempFile;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        _showSnackBar(localizations.uploadCvFailedToPick);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveAndContinue() async {
    if (!mounted) return;
    final localizations = AppLocalizations.of(context)!;
    if (_tempCvFile == null) {
      _showSnackBar(localizations.uploadCvPleaseUploadFirst);
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final Uint8List cvBytes = await _tempCvFile!.readAsBytes();

      final cvModel = CvModel(
        cvData: cvBytes,
        lastChanged: DateTime.now(),
      );
      await DatabaseManager.updateCV(cvModel);
      
      final directory = await getApplicationDocumentsDirectory();
      final String savedPath = '${directory.path}/saved_cv.pdf';
      final savedCvFile = File(savedPath);
      
      if (await savedCvFile.exists()) {
        await savedCvFile.delete();
      }
      
      await savedCvFile.writeAsBytes(cvBytes);
      
      if (mounted) {
        _showSnackBar(localizations.uploadCvSuccessfullySaved);
        
        await _deleteTempFile();
        _navigateToProcessingScreen(withCv: false);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(localizations.uploadCvFailedToSave);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _skipAndContinue() async {
    await _deleteTempFile();
    _navigateToProcessingScreen(withCv: false);
  }

  void _navigateToProcessingScreen({required bool withCv}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationProcessingScreen(
          withCv: true,
          answers: _answers,
          isShortQuestionnaire: widget.isShortQuestionnaire,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          localizations.uploadCvTitle,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.uploadCvOneLastStep,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.uploadCvDescription,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      _isLoading 
                          ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
                          : _tempCvFile == null
                              ? _buildUploadButton()
                              : _buildPreviewSection(),
                      
                      const SizedBox(height: 16),
                      
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.yellow.shade800,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                localizations.uploadCvHelpInfo,
                                style: TextStyle(
                                  color: Colors.yellow.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _skipAndContinue,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        localizations.uploadCvSkipForNow,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveAndContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _tempCvFile != null ? Colors.green : Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        localizations.uploadCvLetsGetIt,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: GestureDetector(
        onTap: _pickCV,
        child: Container(
          width: 220,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white, 
              width: 1,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: DottedBorder(
            color: const Color.fromRGBO(127, 127, 127, 1),
            strokeWidth: 1,
            dashPattern: [4, 4],
            borderType: BorderType.RRect,
            radius: Radius.circular(8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file,
                    color: Colors.grey[600],
                    size: 40,
                  ),
                  SizedBox(height: 12),
                  Text(
                    localizations.uploadCvUploadPdf,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  localizations.uploadCvReadyToUpload,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SfPdfViewer.file(_tempCvFile!),
          ),
        ),
        
        const SizedBox(height: 12),
        
        TextButton.icon(
          onPressed: _pickCV,
          icon: Icon(Icons.refresh, size: 18),
          label: Text(localizations.uploadCvChooseDifferentFile),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}