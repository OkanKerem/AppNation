import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Start both operations in parallel
      final breedsFuture = _apiService.fetchAllBreeds();
      
      // Wait for breeds to be fetched
      final breeds = await breedsFuture;

      // Load images for all breeds in parallel
      await Future.wait(
        breeds.map((breed) async {
          try {
            final imageUrl = await _apiService.getRandomImage(breed.name);
            if (imageUrl != null) {
              breed.imageUrl = imageUrl;
            }
          } catch (e) {
            print('Error loading image for ${breed.name}: $e');
          }
        }),
      );

      // Add a small delay to ensure smooth transition
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(breeds: breeds),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // Show error dialog if initialization fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to load data: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 64,
          height: 64,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/Images/Bg_photo.png"),
              fit: BoxFit.cover,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
