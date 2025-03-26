import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CVUploadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? fileName;

  const CVUploadButton({
    super.key,
    required this.onPressed,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 150,
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
              color: Colors.white,
              spreadRadius: 0,
              blurRadius: 0,
            )
          ],
          shape: BoxShape.rectangle,
        ),
        child: DottedBorder(
          color: const Color.fromRGBO(127, 127, 127, 1),
          strokeWidth: 1,
          dashPattern: [4, 4],
          borderType: BorderType.RRect,
          radius: Radius.circular(8),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  fileName != null ? Icons.check_circle : Icons.upload_file,
                  color: fileName != null ? Colors.green : Colors.grey[600],
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  fileName ?? 'Upload CV',
                  style: TextStyle(
                    color: fileName != null ? Colors.green[700] : Colors.grey[600],
                    fontWeight: fileName != null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
