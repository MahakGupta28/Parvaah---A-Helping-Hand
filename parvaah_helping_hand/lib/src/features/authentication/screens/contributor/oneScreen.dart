import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/payment.dart';

class OneScreen extends StatefulWidget {
  final String postId;
  final String userId;
  const OneScreen({Key? key, required this.postId, required this.userId})
      : super(key: key);

  @override
  _OneScreenState createState() => _OneScreenState();
}

class _OneScreenState extends State<OneScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  String title = '';
  String subtitle = '';
  String causeDetails = '';
  String imageUrl = '';
  double totalAmount = 0.0;
  double collectedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _fetchDataFromFirestore();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      if (documentSnapshot.exists) {
        double fetchedTotalAmount = documentSnapshot['totalAmount'];
        if (fetchedTotalAmount > 0) {
          setState(() {
            title = documentSnapshot['title'];
            totalAmount = fetchedTotalAmount;
            subtitle = documentSnapshot['subtitle'];
            causeDetails = documentSnapshot['causeDetails'];
            imageUrl = documentSnapshot['imageURL'];
          });
          await _fetchCollectedAmount();
        } else {
          print('Fetched totalAmount is not greater than 0');
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _fetchCollectedAmount() async {
    try {
      // Fetch the payment document using the same document ID as the post
      DocumentSnapshot paymentSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .doc(widget.postId)
          .get();

      // Ensure that the payment document exists
      if (paymentSnapshot.exists) {
        // Get the collected amount from the payment document
        dynamic collectedAmountValue = paymentSnapshot['collectedAmount'];
        // Convert the fetched value to double
        double collectedAmount = collectedAmountValue is int
            ? collectedAmountValue.toDouble()
            : collectedAmountValue;

        setState(() {
          this.collectedAmount = collectedAmount;
        });
      }
    } catch (e) {
      print('Error fetching collected amount: $e');
    }
  }

  Future<void> _startAnimation() async {
    try {
      await _animationController.forward(from: 0.0);
    } on TickerCanceled {}
  }

  void _showPaymentSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment successful'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title, // Use the fetched subtitle
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : tPrimaryColor,
            ),
          ),
          backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display image with text and total amount
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          image: imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(
                                      imageUrl), // Use NetworkImage directly
                                  fit: BoxFit.cover,
                                )
                              : null, // Set to null if imageUrl is empty
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                                0.5), // Adjust the opacity as needed
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Total Amount: \₹${totalAmount.toString()}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Text about the importance of education
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          subtitle, // Use the fetched subtitle
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : tPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.justify,
                          causeDetails, // Use the fetched cause details
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isDarkMode ? Colors.yellowAccent : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Get.to(() => PaymentScreen(
                          postId: widget.postId, userId: widget.userId));
                      // After payment success, show snackbar
                      _showPaymentSuccessSnackBar();
                      // Fetch updated data
                      await _fetchDataFromFirestore();
                    },
                    icon: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animationController.value * 2.0 * 3.14,
                          child: Icon(
                            Icons.monetization_on,
                            size: 36,
                            color: isDarkMode ? Colors.white : tPrimaryColor,
                          ),
                        );
                      },
                    ),
                    label: Text(
                      'DONATE',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : tPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // LinearProgressIndicator for funds collected
                  LinearProgressIndicator(
                    value:
                        totalAmount > 0 ? collectedAmount / totalAmount : 0.0,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDarkMode ? tSecondaryColor : tPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Collected: ₹${collectedAmount.toString()}',
                    style: TextStyle(
                      fontSize: 17,
                      color: isDarkMode ? Colors.white : tPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: tDashboardBg,
      ),
    );
  }
}
