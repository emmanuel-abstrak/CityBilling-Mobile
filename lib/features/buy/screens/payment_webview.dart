import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:utility_token_app/config/routes/router.dart';
import 'package:utility_token_app/core/constants/color_constants.dart';
import 'package:utility_token_app/core/constants/url_constants.dart';
import 'package:utility_token_app/core/utils/dimensions.dart';
import 'package:utility_token_app/core/utils/logs.dart';
import 'package:utility_token_app/features/municipalities/state/municipalities_controller.dart';
import 'package:utility_token_app/widgets/custom_button/general_button.dart';
import 'package:utility_token_app/widgets/snackbar/custom_snackbar.dart';

import '../../../core/constants/image_asset_constants.dart';

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
  final MunicipalityController municipalityController = Get.find<MunicipalityController>();

  @override
  void initState() {
    super.initState();
    _webView = InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.redirectUrl))),
      onLoadStop: (controller, url) {
        DevLogs.logSuccess(url.toString());
        if (url.toString().contains("https://api-masvingo.abstrak.agency/payment/settle")) {
          CustomSnackBar.showSuccessSnackbar(message: 'Payment Successful');
          setState(() {
            showProceedButton = true;
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
            _webView,

            if(showProceedButton)Positioned(
              bottom: 0,
              right: 36,
              left: 36,
              child: GeneralButton(
                onTap: ()async{
                  final cachedMunicipality = await municipalityController.checkCachedMunicipality();

                  Get.offAllNamed(RoutesHelper.initialScreen, arguments: cachedMunicipality);
                },
                btnColor: Pallete.primary,
                width: Dimensions.screenWidth * .8,
                child: const Text(
                  'Proceed to Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
