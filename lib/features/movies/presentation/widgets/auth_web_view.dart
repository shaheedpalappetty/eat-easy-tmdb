// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AuthWebView extends StatelessWidget {
  final String url;

  const AuthWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authenticate")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        onLoadStop: (controller, url) {
          if (url != null && url.toString().contains('allow')) {
            Navigator.pop(context, true);
          } else if (url != null && url.toString().contains('deny')) {
            Navigator.pop(context, false);
          }
        },
        onLoadError: (controller, url, code, message) =>
            Navigator.pop(context, false),
      ),
    );
  }
}
