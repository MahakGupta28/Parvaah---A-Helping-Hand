import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parvaah_helping_hand/src/constants/colors.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/donate.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/drawer.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/events.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/oneScreen.dart';
import 'package:parvaah_helping_hand/src/features/authentication/screens/contributor/sponsor.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static String routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _pageController
        .addListener(_pageListener); // Add listener to track page changes
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    setState(() {
      _currentIndex = _pageController.page!.round();
    });
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
                  DashboardScreenContent(
                    pageController: _pageController,
                    onJumpToDonate: _jumpToDonate,
                    onJumpToEvents: _jumpToEvents,
                  ),
                  const DonateScreen(),
                  const EventsScreen(),
                ],
              ),
            ),
          ],
        ),
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
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism),
              label: 'Volunteer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',
            ),
          ],
          backgroundColor: isDarkMode ? tPrimaryColor : Colors.white,
          selectedItemColor: isDarkMode ? Colors.amber : tPrimaryColor,
          unselectedItemColor: isDarkMode
              ? Colors.white
              : const Color.fromARGB(255, 152, 118, 157),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SponsorPersonScreen(),
              ),
            );
          },
          label: Text(
            'Sponsor a Person',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          icon: Icon(
            Icons.person_add_alt,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          backgroundColor: isDarkMode ? tPrimaryColor : tBgColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Show confirmation dialog when back button is pressed
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Perform logout action here
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; // Return false to prevent route from being popped
  }

  void _jumpToDonate() {
    setState(() {
      _currentIndex = 1;
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart,
      );
    });
  }

  void _jumpToEvents() {
    setState(() {
      _currentIndex = 2;
      _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart,
      );
    });
  }
}

class DashboardScreenContent extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onJumpToDonate;
  final VoidCallback onJumpToEvents;

  const DashboardScreenContent({
    Key? key,
    required this.pageController,
    required this.onJumpToDonate,
    required this.onJumpToEvents,
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
                      'Contributor',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Causes',
                  style: TextStyle(
                    color: isDarkMode ? Colors.yellow : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2.0),
                // Scrollable Row of Causes
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _CauseItem(
                        icon: Icons.school,
                        label: 'Education',
                        isDarkMode: isDarkMode,
                      ),
                      _CauseItem(
                        icon: Icons.warning,
                        label: 'Disaster',
                        isDarkMode: isDarkMode,
                      ),
                      _CauseItem(
                        icon: Icons.home,
                        label: 'Home',
                        isDarkMode: isDarkMode,
                      ),
                      _CauseItem(
                        icon: Icons.fastfood,
                        label: 'Food',
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Emergency Help
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Emergency Help',
                      style: TextStyle(
                        color: isDarkMode ? Colors.yellow : tPrimaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onJumpToDonate();
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: isDarkMode ? Colors.yellow : tAccentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(); // Display an empty container while waiting for data
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(
                            color: Colors
                                .red), // Optionally style the error message
                      );
                    }
                    final data = snapshot.data!.docs;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          data.length,
                          (index) {
                            final post = data[index];
                            return _EmergencyCauseItem(
                              image: post['imageURL'],
                              label: post['title'],
                              isDarkMode: isDarkMode,
                              onTap: () {
                                // Navigate to the corresponding screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OneScreen(
                                      postId: post.id,
                                      userId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            onJumpToEvents();
                          },
                          icon: Icon(
                            Icons.location_on,
                            size: 22,
                            color: isDarkMode ? Colors.white : tPrimaryColor,
                          ),
                          label: Text(
                            'Explore More',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : tPrimaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDarkMode ? Colors.black : tDashboardBg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CauseItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDarkMode;

  const _CauseItem({
    required this.icon,
    required this.label,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32.0,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyCauseItem extends StatelessWidget {
  final String image;
  final String label;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _EmergencyCauseItem({
    required this.image,
    required this.label,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12.0),
        width: 165.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                image,
                height: 160.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 6.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? tPrimaryColor
                    : const Color.fromARGB(255, 242, 243, 245),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
