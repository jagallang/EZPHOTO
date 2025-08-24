import 'dart:html' as html;
import 'dart:convert';
import 'dart:typed_data';

void downloadImageOnWeb(Uint8List bytes, String filename) {
  final base64 = base64Encode(bytes);
  final dataUrl = 'data:image/png;base64,$base64';
  
  final anchor = html.AnchorElement()
    ..href = dataUrl
    ..download = filename
    ..style.display = 'none';
  
  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}