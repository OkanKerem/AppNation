import 'package:flutter/material.dart';
import '../models/breed.dart';
import '../services/api_service.dart';
import 'splash_screen.dart'; // or your actual SettingsScreen
import 'settings_screen.dart';
// If you want caching later, you can import cached_network_image:
// import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  final List<Breed> breeds;

  const HomeScreen({Key? key, required this.breeds}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Breed> display;
  int _currentIndex = 0;
  final FocusNode _searchFocusNode = FocusNode();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    display = widget.breeds;
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filter(String text) {
    setState(() {
      display = widget.breeds
          .where((b) => b.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _showBreedBottomSheet(Breed breed) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool isLoading = false;
        String? imageUrl = breed.imageUrl;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 630,
              width: 343,
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 100,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  // Breed Image
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 343,
                      height: 343,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl ?? "https://placehold.co/343x343"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Close Button
                  Positioned(
                    left: 299,
                    top: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  ),
                  // Breed Name
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 355,
                    child: Text(
                      'Breed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF0054D3),
                        fontSize: 20,
                        fontFamily: 'Galano Grotesque',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 400,
                    child: Text(
                      breed.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Galano Grotesque',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.16,
                      ),
                    ),
                  ),
                  // Divider
                  Positioned(
                    left: 32,
                    top: 390,
                    child: Container(
                      width: 280,
                      height: 2,
                      decoration: BoxDecoration(color: const Color(0xFFF2F2F7)),
                    ),
                  ),
                  // Sub Breeds Section
                  if (breed.subBreeds.isNotEmpty) ...[
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 433,
                      child: Text(
                        'Sub Breed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF0054D3),
                          fontSize: 20,
                          fontFamily: 'Galano Grotesque',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.20,
                        ),
                      ),
                    ),
                    ...List.generate(
                      breed.subBreeds.length,
                      (index) => Positioned(
                        left: 0,
                        right: 0,
                        top: 478 + (index * 26),
                        child: Text(
                          breed.subBreeds[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Galano Grotesque',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.16,
                          ),
                        ),
                      ),
                    ),
                    // Divider
                    Positioned(
                      left: 32,
                      top: 468,
                      child: Container(
                        width: 279,
                        height: 2,
                        decoration: BoxDecoration(color: const Color(0xFFF2F2F7)),
                      ),
                    ),
                  ],
                  // Generate Button
                  Positioned(
                    left: 16,
                    top: 558,
                    child: Container(
                      width: 312,
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF0084FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          setModalState(() => isLoading = true);
                          try {
                            final url = await _apiService.getRandomImage(breed.name);
                            setModalState(() {
                              imageUrl = url;
                              isLoading = false;
                            });
                          } catch (e) {
                            setModalState(() => isLoading = false);
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Generate',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Galano Grotesque',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.09,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              // Breed grid
              Positioned(
                left: 16,
                top: 100,
                right: 16,
                bottom: 170,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: display.length,
                  itemBuilder: (_, i) {
                    final breed = display[i];
                    return GestureDetector(
                      onTap: () => _showBreedBottomSheet(breed),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFF2F2F7),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (breed.imageUrl != null)
                              Positioned.fill(
                                child: Image.network(
                                  breed.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error displaying image for ${breed.name}: $error');
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: Colors.black.withOpacity(0.24),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16)),
                                  ),
                                ),
                                child: Text(
                                  breed.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Search bar
              Positioned(
                left: 16,
                right: 16,
                bottom: 108,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 2,
                        color: Color(0xFFE5E5EA),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x28000000),
                        blurRadius: 16,
                        offset: Offset(0, 0),
                      )
                    ],
                  ),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    ),
                    onChanged: _filter,
                    maxLines: null, // Allow multiple lines
                    minLines: 1, // Start with one line
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.2, // Adjust line height for better appearance
                    ),
                  ),
                ),
              ),

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
                            'Dog Breeds',
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
                          onTap: () => setState(() => _currentIndex = 0),
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
                          onTap: () {
                            setState(() => _currentIndex = 1);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen()),
                            );
                          },
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
