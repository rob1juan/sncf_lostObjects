import 'package:flutter/material.dart';
import 'home_page.dart';

class OnboardingPageModel {
  final String title;
  final String description;
  final String image;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.image,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
  });
}

class OnboardingPage extends StatefulWidget {
  final List<OnboardingPageModel> pages;

  const OnboardingPage({Key? key, required this.pages}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Store the currently visible page
  int _currentPage = 0;
  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

  // Define a list of colors for the background and text
  final List<Color> _bgColors = [
    Color(0xff73877B),
    Color(0xffBDBBB6),
    Color(0xffF5E4D7),
    Color(0xff839788),
    Color(0xffE5D1D0),
  ];
  final List<Color> _textColors = [
    Colors.white,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: _bgColors[_currentPage],
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // Pageview to render each page
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    // Change current page when pageview changes
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final _item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Image.asset(
                              _item.image,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  _item.title,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: _textColors[_currentPage],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: 280),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 8.0),
                                child: Text(
                                  _item.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: _textColors[_currentPage],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Current page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages
                    .map((item) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _currentPage == widget.pages.indexOf(item)
                              ? 20
                              : 4,
                          height: 4,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: _textColors[_currentPage],
                              borderRadius: BorderRadius.circular(10.0)),
                        ))
                    .toList(),
              ),

              // Bottom buttons
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle Skipping onboarding page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Text(
                        "Passer",
                        style: TextStyle(color: _textColors[_currentPage]),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_currentPage == widget.pages.length - 1) {
                          // This is the last page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } else {
                          _pageController.animateToPage(_currentPage + 1,
                              curve: Curves.easeInOutCubic,
                              duration: const Duration(milliseconds: 250));
                        }
                      },
                      child: Text(
                        _currentPage == widget.pages.length - 1
                            ? "Terminer"
                            : "Suivant",
                        style: TextStyle(color: _textColors[_currentPage]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
