import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String?> encodeCvFile() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final String savedPath = '${directory.path}/saved_cv.pdf';
    final savedCvFile = File(savedPath);
    final Uint8List bytes = await savedCvFile.readAsBytes();
    return base64Encode(bytes);
  } catch (e) {
    return null;
  }
}