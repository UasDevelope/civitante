import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class RecaptchaWidget extends StatefulWidget {
  final Function(String) onVerified;

  const RecaptchaWidget({Key? key, required this.onVerified}) : super(key: key);

  @override
  _RecaptchaWidgetState createState() => _RecaptchaWidgetState();
}

class _RecaptchaWidgetState extends State<RecaptchaWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'flutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('Received from JS: ${message.message}');
          widget.onVerified(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => debugPrint('Loading progress: $progress%'),
          onPageStarted: (String url) => debugPrint('Page started: $url'),
          onPageFinished: (String url) {
            debugPrint('Page finished: $url');
            _controller.runJavaScript('''
              if (typeof grecaptcha === 'undefined') {
                window.flutterChannel.postMessage('error:recaptcha_not_loaded');
              }
            ''');
          },
          onWebResourceError: (WebResourceError error) => debugPrint('Web error: ${error.description}, code: ${error.errorCode}'),
          onHttpError: (HttpResponseError error) => debugPrint('HTTP error: ${error.response?.statusCode}'),
        ),
      )
      ..loadRequest(Uri.dataFromString(
        '''
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script src="https://www.google.com/recaptcha/api.js?onload=onRecaptchaLoad" async defer></script>
          </head>
          <body>
            <form action="" method="POST">
              <div class="g-recaptcha" 
                   data-sitekey="6LeXYfEqAAAAAOwhKVmaj4H_RXXmwdJCM7IS3MxL" 
                   data-callback="verifyCaptcha"
                   data-size="normal">
              </div>
            </form>
            <script>
              function onRecaptchaLoad() {
                console.log('reCAPTCHA loaded');
              }
              
              function verifyCaptcha(response) {
                window.flutterChannel.postMessage(response);
              }
              
              window.onerror = function(message, source, lineno, colno, error) {
                window.flutterChannel.postMessage('error:js_error:' + message);
              };
            </script>
          </body>
        </html>
        ''',
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: WebViewWidget(controller: _controller),
    );
  }
}