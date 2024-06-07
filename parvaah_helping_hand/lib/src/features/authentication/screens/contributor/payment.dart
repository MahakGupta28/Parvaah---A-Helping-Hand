import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:parvaah_helping_hand/src/constants/image_string.dart';

class PaymentScreen extends StatefulWidget {
  final String postId;
  final String userId;

  const PaymentScreen({Key? key, required this.postId, required this.userId})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();
  String postTitle = '';
  String userFullName = '';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    fetchPostTitle();
    fetchUserFullName();
  }

  void fetchPostTitle() async {
    try {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();
      setState(() {
        postTitle = postSnapshot['title'];
      });
    } catch (e) {
      print('Error fetching post title: $e');
    }
  }

  void fetchUserFullName() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      setState(() {
        userFullName = userSnapshot['email'];
      });
    } catch (e) {
      print('Error fetching user full name: $e');
    }
  }

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_NIGLhPLHQxcHqq',
      'amount': amount,
      'name': 'Parvaah',
      'prefill': {
        'contact': '8090783441',
        'email': 'khushibisht2319@gmail.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response.paymentId);
    showSnackbar('Payment successful');

    // Save data to Firestore
    savePaymentData(amtController.text);
  }

 Future<void> savePaymentData(String amount) async {
  try {
    // Check if a document with the title already exists
    DocumentReference paymentRef = FirebaseFirestore.instance
        .collection('payments')
        .doc(postTitle);

    DocumentSnapshot docSnapshot = await paymentRef.get();

    if (docSnapshot.exists) {
      // If document exists, update the existing document
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      // Get the current collected amount
      double currentCollectedAmount = data['collectedAmount'] ?? 0.0;

      // Update the collected amount by adding the new payment amount
      await paymentRef.update({
        'collectedAmount': currentCollectedAmount + double.parse(amount),
        // Store individual user donations separately without overwriting
        '${userFullName}': double.parse(amount),
      });

      // Update the collected amount in the posts collection
      await updatePostsCollection(postTitle, currentCollectedAmount + double.parse(amount));
    } else {
      // If document doesn't exist, create a new document with the title as its ID
      await paymentRef.set({
        // Set the initial collected amount as the new payment amount
        'collectedAmount': double.parse(amount),
        // Store individual user donations separately
        '${userFullName}': double.parse(amount),
      });

      // Update the collected amount in the posts collection
      await updatePostsCollection(postTitle, double.parse(amount));
    }
  } catch (e) {
    print('Error saving payment data: $e');
  }
}

Future<void> updatePostsCollection(String postId, double collectedAmount) async {
  try {
    // Update the collected amount in the posts collection
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update({'collectedAmount': collectedAmount});
  } catch (e) {
    print('Error updating posts collection: $e');
  }
}

  void handlePaymentError(PaymentFailureResponse response) {
    print(response.message!);
    showSnackbar('Payment failed');
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print(response.walletName!);
    showSnackbar('External wallet: ${response.walletName}');
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tDashboardBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              tWelcomeScreen,
              height: 200,
              width: 350,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Every contribution, big or small, helps build a brighter future",
              style: TextStyle(
                  color: tPrimaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.black,
                autofocus: false,
                style: const TextStyle(color: tPrimaryColor),
                decoration: const InputDecoration(
                  labelText: "Enter amount",
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: tPrimaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                ),
                controller: amtController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount to be paid';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (amtController.text.toString().isNotEmpty) {
                  setState(() {
                    int amount = int.parse(amtController.text.toString());
                    openCheckout(amount);
                  });
                }
              },
              icon: const Icon(Icons.lock),
              label: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Proceed to donate',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: tPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
