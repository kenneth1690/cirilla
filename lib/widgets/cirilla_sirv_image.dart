import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iframe_view/iframe_view.dart';
import 'cirilla_webview.dart';

class CirillaSirvImage extends StatefulWidget {
  final String video;

  const CirillaSirvImage({Key? key, required this.video}) : super(key: key);

  @override
  State<CirillaSirvImage> createState() => _CirillaSirvImageState();
}

class _CirillaSirvImageState extends State<CirillaSirvImage> {
  final _iframeViewPlugin = IframeView();

  Widget _build360Spin() {
    String html = """
    <script src="https://scripts.sirv.com/sirv.js"></script>
    <div class="Sirv" data-src="${widget.video}"></div>
    """;

    if (kIsWeb) {
      return FutureBuilder<Widget?>(
          future: _iframeViewPlugin.show(Uri.dataFromString(html, mimeType: 'text/html').toString()),
          builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return snapshot.data!;
            }
            return const SizedBox();
          });
    }

    return CirillaWebView(
      uri: Uri.dataFromString(html, mimeType: 'text/html'),
      isLoading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: _build360Spin(),
    );
  }
}
