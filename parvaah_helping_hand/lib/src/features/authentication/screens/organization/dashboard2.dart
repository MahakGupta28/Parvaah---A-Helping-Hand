import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/drawer.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/addevents.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/displaypost.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/getupdates.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/addupdates.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/organization/postevents.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/welcome/welcome_sc.dart';

class OrganizationDashboardScreen extends StatefulWidget {
  const OrganizationDashboardScreen({Key? key}) : super(key: key);
  static String routeName = '/orgdashboard';

  @override
  _OrganizationDashboardScreenState createState() =>
      _OrganizationDashboardScreenState();
}

class _OrganizationDashboardScreenState
    extends State<OrganizationDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;
  int _currentIndex = 0;
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _getCurrentUserEmail();
  }

  void _getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDarkMode ? tAccentColor : tDashboardBg,
        appBar: AppBar(
          backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.menu_open_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        drawer: const DrawerScreen(),
        body: ListView(
          children: [
            SizedBox(
              height: mediaQuery.size.height,
              child: PageView(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                children: [
                  OrgDashScreenContent(
                      pageController: _pageController,
                      onJumpToUpdates: _jumpToUpdates,
                      onJumpToEvents: _jumpToEvents,
                      currentUserEmail: currentUserEmail ?? ''),
                  const PostEvents(),
                  const Getupdates(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutQuart,
              );
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'Posts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upload),
              label: 'Updates',
            ),
          ],
          backgroundColor: isDarkMode ? tPrimaryColor : Colors.white,
          selectedItemColor: isDarkMode
              ? Colors.amber
              : tPrimaryColor, // Set selected item color
          unselectedItemColor: isDarkMode
              ? Colors.white
              : const Color.fromARGB(
                  255, 152, 118, 157), // Set unselected item color
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    if (_currentIndex == 0 || _currentIndex == 1) {
      return FloatingActionButton(
        onPressed: () {
          if (_currentIndex == 0) {
            Get.to(Updates());
          } else if (_currentIndex == 1) {
            Get.to(const addEvents());
          }
        },
        backgroundColor: const Color.fromARGB(255, 244, 243, 243),
        child: const Icon(Icons.add),
      );
    } else {
      return const FloatingActionButton(
        onPressed: null, // No action for Getupdates screen
        backgroundColor: Colors.transparent,
      );
    }
  }

  Future<bool> _onWillPop() async {
    // Show confirmation dialog when back button is pressed
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to WelcomeScreen
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    WelcomeScreen.routeName,
                    (route) =>
                        false, // This prevents going back to the previous screen
                  );
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; // Return false to prevent route from being popped
  }

  void _jumpToEvents() {
    setState(() {
      _currentIndex = 1; // Index 1 corresponds to EventsScreen
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart,
      );
    });
  }

  void _jumpToUpdates() {
    setState(() {
      _currentIndex = 2; // Index 2 corresponds to Getupdates screen
      _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart,
      );
    });
  }
}

class OrgDashScreenContent extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onJumpToUpdates;
  final VoidCallback onJumpToEvents;
  final String currentUserEmail; // Add currentUserEmail property

  const OrgDashScreenContent({
    Key? key,
    required this.pageController,
    required this.onJumpToUpdates,
    required this.onJumpToEvents,
    required this.currentUserEmail, // Initialize currentUserEmail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode ? tPrimaryColor : tBgColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'PARVAAH',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : tPrimaryColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Text(
                      'Organization',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : tPrimaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 236, 233, 233),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black87,
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Filter posts based on the current user's email
              List<DocumentSnapshot> filteredPosts = [];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              // Iterate through all posts and filter based on currentUserEmail
              snapshot.data!.docs.forEach((post) {
                if (post['postedBy'] == currentUserEmail) {
                  filteredPosts.add(post);
                }
              });
              // Return ListView.builder with filteredPosts
              return ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  var post = filteredPosts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailsScreen(post: post),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  post['subtitle'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteDialog(context, post.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Do you really want to delete this post?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('posts').doc(postId).delete();
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
