import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  double _totalAmount = 1000.0; // Example total amount
  double _gst = 18.0; // GST percentage
  double _discount = 0.0;

  void _applyCoupon() {
    setState(() {
      // Apply coupon logic here, for example:
      if (_couponController.text == 'DISCOUNT10') {
        _discount = _totalAmount * 0.1; // 10% discount
      } else {
        _discount = 0.0;
      }
    });
  }

  void _pay() {
    // Start PhonePe payment process here
    // You would typically use an SDK or API provided by PhonePe for this
    print('Starting PhonePe payment process...');
  }

  @override
  Widget build(BuildContext context) {
    double gstAmount = _totalAmount-(_totalAmount*100)/118;//(_totalAmount - _discount) * (_gst / 100);
    double finalAmount = (_totalAmount);// - _discount) + gstAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$${_totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(height: 32),
                    const Text('GST (18%)', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$${gstAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(height: 32),
                    const Text('Discount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$${_discount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(height: 32),
                    const Text('Final Amount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('\$${finalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _couponController,
              decoration: InputDecoration(
                labelText: 'Enter Coupon Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.local_offer, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _applyCoupon,
              icon: const Icon(FontAwesomeIcons.checkCircle, color: Colors.white),
              label: const Text('Apply Coupon', style: TextStyle(fontSize: 18,color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _pay,
              icon: const Icon(FontAwesomeIcons.creditCard, color: Colors.white),
              label: const Text('Pay with PhonePe', style: TextStyle(fontSize: 18,color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: CheckoutScreen(),
));
