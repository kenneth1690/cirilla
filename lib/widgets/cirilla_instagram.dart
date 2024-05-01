import 'package:flutter/cupertino.dart';
import 'cirilla_webview.dart';

class CirillaInstagram extends StatefulWidget {
  final String id;

  const CirillaInstagram({Key? key, required this.id}) : super(key: key);

  @override
  State<CirillaInstagram> createState() => _CirillaInstagramState();
}

class _CirillaInstagramState extends State<CirillaInstagram> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 625,
      child: CirillaWebView(
        uri: Uri.dataFromString(
          '<iframe frameBorder="0" height="100%" width="100%" src="https://www.instagram.com/p/${widget.id}/embed/"></iframe>',
          mimeType: 'text/html',
        ),
        isLoading: false,
      ),
    );
  }
}
