import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/utilities/logs.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String redirectUrl;

  const PaymentWebViewScreen({super.key, required this.redirectUrl});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late InAppWebViewController _controller;
  late InAppWebView _webView;
  bool showProceedButton = false;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _webView = InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.redirectUrl))),
      onLoadStop: (controller, url) async{
        DevLogs.logSuccess(url.toString());


        // if (url.toString().contains("${municipalityController.selectedMunicipality.value!.endpoint}/payment/settle")) {
        //   // Parse the URL
        //   final uri = Uri.parse(url.toString());
        //
        //   final purchaseId = int.parse(uri.pathSegments.last);
        //
        //   DevLogs.logInfo(purchaseId.toString());
        //
        //   // await paymentController.fetchPurchaseDetailsAndStoreToCache(
        //   //   purchaseId: purchaseId,
        //   // ).then((history) {
        //   //   if (history.success) {
        //   //     CustomSnackBar.showSuccessSnackbar(message: 'Payment Successful');
        //   //   } else {
        //   //     CustomSnackBar.showErrorSnackbar(message: 'Payment Failed');
        //   //   }
        //   // }
        //   // );
        //
        //   setState(() {
        //     showProceedButton = true;
        //     isLoading = false; // Stop the loading indicator
        //   });
        // }
        //

        },
      onLoadStart: (controller, url) {
        setState(() {
          isLoading = true;
        });
      },
      onProgressChanged: (controller, progress) {
        if (progress == 100) {
          setState(() {
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _webView, // The WebView

            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),

            // If payment is successful, show the "Proceed to Home" button
            // if (showProceedButton)
            //   Positioned(
            //     bottom: 30,
            //     right: 36,
            //     left: 36,
            //     child: GeneralButton(
            //       onTap: () async {
            //         final cachedMunicipality = await municipalityController.checkCachedMunicipality();
            //         Get.offAllNamed(RoutesHelper.initialScreen, arguments: cachedMunicipality);
            //       },
            //       btnColor: Pallete.primary,
            //       width: Dimensions.screenWidth * .8,
            //       child: const Text(
            //         'Proceed to Home',
            //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
