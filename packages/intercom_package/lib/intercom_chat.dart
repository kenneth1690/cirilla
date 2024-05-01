import 'package:flutter/material.dart';
import 'intercom_package.dart';
import 'utils/helper.dart';

/// Function to initialize the Intercom SDK.
///
/// First, you'll need to get your Intercom [appId].
/// [androidApiKey] is required if you want to use Intercom in Android.
/// [iosApiKey] is required if you want to use Intercom in iOS.
///
/// You can get these from Intercom settings:
/// * [Android](https://app.intercom.com/a/apps/_/settings/android)
/// * [iOS](https://app.intercom.com/a/apps/_/settings/ios)
///
/// Then, initialize Intercom in main method.
Future<void> intercomInitialize(String appId, {String? androidApiKey, String? iosApiKey}) async {
  await intercomInstance.initialize(
    appId,
    androidApiKey: androidApiKey,
    iosApiKey: iosApiKey,
  );
}

Future<void> displayMessageForOrderPrePopulated({required Map<String, dynamic> data}) async {
  Map<String, dynamic> orderData = getData(data, ['orderData'], {});
  Map<String, dynamic> billingData = getData(orderData, ['billing'], {});

  String orderId = '\n#${getData(orderData, ['id'], '')}';

  String firstName = getData(billingData, ['first_name'], '');
  String lastName = getData(billingData, ['last_name'], '');
  String name = '\nName : $firstName + $lastName';
  String billingEmail = '\nEmail : ${getData(billingData, ['email'], '')}';
  String billingPhone = '\nPhone : ${getData(billingData, ['phone'], '')}';

  String orderPrePopulated = 'Hi! I need help Related my order id $orderId $name $billingEmail $billingPhone';

  await intercomInstance.displayMessageComposer(orderPrePopulated);
}

/// Chat bubble icon
class IntercomChat extends StatefulWidget {
  final bool isLabelVisible;
  final Widget? widget;
  final Widget? label;
  final GestureTapCallback? onTap;
  final Decoration? decoration;
  final bool isLoginUnidentifiedUser;

  const IntercomChat({
    super.key,
    this.isLabelVisible = false,
    this.widget,
    this.label,
    this.onTap,
    this.decoration,
    this.isLoginUnidentifiedUser = true,
  });

  @override
  State<IntercomChat> createState() => _IntercomChatState();
}

class _IntercomChatState extends State<IntercomChat> {
  @override
  void initState() {
    super.initState();
    if (widget.isLoginUnidentifiedUser) {
      onLoginUnidentifiedUser();
    }
  }

  onLoginUnidentifiedUser() async {
    await intercomInstance.loginUnidentifiedUser();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onTap ??
          () async {
            await intercomInstance.displayMessenger();
          },
      child: Badge(
        isLabelVisible: widget.isLabelVisible,
        label: widget.label,
        child: Container(
          alignment: Alignment.center,
          width: 50,
          height: 50,
          decoration: widget.decoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
          child: widget.widget ?? const Icon(Icons.message),
        ),
      ),
    );
  }
}
