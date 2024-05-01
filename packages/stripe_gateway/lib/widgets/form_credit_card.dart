import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'loading_button.dart';

class FormCreditCard extends StatefulWidget {
  final void Function(List<dynamic>) checkout;
  final bool loading;
  final Map<String, dynamic> billing;
  final String currency;
  final String amount;
  final String pk;
  const FormCreditCard({
    Key? key,
    required this.checkout,
    required this.billing,
    required this.currency,
    required this.amount,
    required this.pk,
    this.loading = false,
  }) : super(key: key);

  @override
  State<FormCreditCard> createState() => _FormCreditCardState();
}

class _FormCreditCardState extends State<FormCreditCard> {
  final controller = CardFormEditController();

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});

  @override
  void didChangeDependencies() async {
    Stripe.publishableKey = widget.pk;
    await Stripe.instance.applySettings();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.blur(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: const Text('Stripe Payment'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              CardFormField(
                controller: controller,
                countryCode: widget.billing['country'],
              ),
              const SizedBox(height: 16),
              LoadingButton(
                onPressed: controller.details.complete == true ? _handlePayPress : null,
                text: 'Pay',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePayPress() async {
    controller.blur();
    if (!controller.details.complete) {
      return;
    }
    try {
      // 1. Gather customer billing information
      BillingDetails billingDetails = BillingDetails(
        email: widget.billing['email'],
        phone: widget.billing['phone'],
        address: Address(
          city: widget.billing['city'],
          country: widget.billing['country'],
          line1: widget.billing['address_1'],
          line2: widget.billing['address_2'],
          state: widget.billing['state'],
          postalCode: widget.billing['postcode'],
        ),
      ); // mocked data for tests

      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ));
      if (paymentMethod.id != '' && mounted) {
        Navigator.of(context).pop(paymentMethod.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        rethrow;
      }
    }
  }
}
