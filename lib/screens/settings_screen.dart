import 'package:flutter/material.dart';
import '../services/platform_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _osVersion = 'Loading...';
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadOSVersion();
  }

  Future<void> _loadOSVersion() async {
    final version = await PlatformService.getOSVersion();
    setState(() {
      _osVersion = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Color(0xFFF2F2F7)),
        child: Stack(
          children: [
            // App bar
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(height: 50, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Center(
                        child: Text(
                          'Settings',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Galano Grotesque',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Settings content
            Positioned(
              left: 0,
              top: 100,
              right: 0,
              bottom: 98,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Help
                    Container(
                      width: 343,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.help_outline, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 279,
                            child: Text(
                              'Help',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Galano Grotesque',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, size: 16),
                        ],
                      ),
                    ),
                    // Rate Us
                    Container(
                      width: 343,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.star_outline, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 279,
                            child: Text(
                              'Rate Us',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Galano Grotesque',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, size: 16),
                        ],
                      ),
                    ),
                    // Share with Friends
                    Container(
                      width: 343,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.share_outlined, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 279,
                            child: Text(
                              'Share with Friends',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Galano Grotesque',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, size: 16),
                        ],
                      ),
                    ),
                    // Terms of Use
                    Container(
                      width: 343,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.description_outlined, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 279,
                            child: Text(
                              'Terms of Use',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Galano Grotesque',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, size: 16),
                        ],
                      ),
                    ),
                    // Privacy Policy
                    Container(
                      width: 343,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.privacy_tip_outlined, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 279,
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Galano Grotesque',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, size: 16),
                        ],
                      ),
                    ),
                    // OS Version
                    Container(
                      width: 343,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.info_outline, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 238,
                            child: Text(
                              'OS Version',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Galano Grotesque',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.16,
                              ),
                            ),
                          ),
                          Text(
                            _osVersion,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0x993C3C43),
                              fontSize: 13,
                              fontFamily: 'Galano Grotesque',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    // Home icon
                    Positioned(
                      left: 77,
                      top: 16,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _currentIndex = 0);
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.home,
                                color: _currentIndex == 0
                                    ? const Color(0xFF0054D3)
                                    : Colors.black),
                            const SizedBox(height: 4),
                            Text(
                              'Home',
                              style: TextStyle(
                                color: _currentIndex == 0
                                    ? const Color(0xFF0054D3)
                                    : Colors.black,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Settings icon
                    Positioned(
                      left: 255,
                      top: 16,
                      child: GestureDetector(
                        onTap: () => setState(() => _currentIndex = 1),
                        child: Column(
                          children: [
                            Icon(Icons.settings,
                                color: _currentIndex == 1
                                    ? const Color(0xFF0054D3)
                                    : Colors.black),
                            const SizedBox(height: 4),
                            Text(
                              'Settings',
                              style: TextStyle(
                                color: _currentIndex == 1
                                    ? const Color(0xFF0054D3)
                                    : Colors.black,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Divider and indicator
                    const Positioned(
                      left: 187,
                      top: 24,
                      child: SizedBox(
                        width: 2,
                        height: 24,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Color(0xFFD1D1D6)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 122,
                      top: 78,
                      child: Container(
                        width: 132,
                        height: 4,
                        decoration: ShapeDecoration(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 