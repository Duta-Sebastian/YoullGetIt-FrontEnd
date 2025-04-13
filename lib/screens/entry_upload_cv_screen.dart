import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youllgetit_flutter/models/cv_model.dart';
import 'package:youllgetit_flutter/providers/job_provider.dart';
import 'package:youllgetit_flutter/screens/home_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';
import 'package:youllgetit_flutter/utils/first_time_checker.dart';

class EntryUploadCvScreen extends ConsumerStatefulWidget {
  const EntryUploadCvScreen({super.key});

  @override
  ConsumerState<EntryUploadCvScreen> createState() => _StandaloneCVScreenState();
}

class _StandaloneCVScreenState extends ConsumerState<EntryUploadCvScreen> {
  File? _tempCvFile;
  bool _isLoading = false;

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

        setState(() {
          _tempCvFile = tempFile;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to pick CV file');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAndContinue() async {
    if (_tempCvFile == null) {
      _showSnackBar('Please upload your CV first');
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
      
      _showSnackBar('CV successfully saved');
      
      await _deleteTempFile();
      await setFirstTimeOpening();
      ref.read(jobProvider.notifier).fetchJobs(10);
      _navigateToHomeScreen();
    } catch (e) {
      _showSnackBar('Failed to save CV');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _skipAndContinue() async {
    await _deleteTempFile();
    await setFirstTimeOpening();
    ref.read(jobProvider.notifier).fetchJobs(10);
    _navigateToHomeScreen();
  }

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Your CV',
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
                        'One last step',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload your CV to help us match you with relevant internships',
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
                                'This helps us understand your skills and experience better',
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
                        'Skip it for now',
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
                      child: const Text(
                        'Let\'s Get It',
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
                    'Upload your CV (PDF)',
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
                  'CV ready to upload',
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
          label: Text('Choose a different file'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}