import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallary_app/services/api_service.dart';
import 'package:image_gallary_app/widgets/category_button.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pink Gradient Theme',
      theme: ThemeData(
        textTheme: GoogleFonts.fredokaTextTheme(),
      ),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> imageDetails = [];
  bool isLoading = false;
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchImages();

    // Add scroll listener for infinite scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchImages(); // Fetch more images when reaching the bottom
      }
    });
  }

  Future<void> fetchImages() async {
    if (isLoading) return; // Prevent multiple fetches
    setState(() {
      isLoading = true;
    });

    try {
      final images = await apiService.fetchImages();
      setState(() {
        imageDetails.addAll(images); // Update to store detailed image info
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          _buildCategoryButtons(),
          _buildImageGrid(),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'My Gallery',
        style: GoogleFonts.fredoka(
          textStyle: const TextStyle(
            fontSize: 25, // Adjust size if needed
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 242, 241, 240),
          ),
        ),
      ),
      centerTitle: true, // Center the title
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)], // Pink gradient
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CategoryButton(label: 'Popular'),
          CategoryButton(label: 'Motivational'),
          CategoryButton(label: 'Inspiration'),
          CategoryButton(label: 'Life'),
          CategoryButton(label: 'Love'),
          CategoryButton(label: 'Happiness'),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: imageDetails.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: imageDetails.length,
                itemBuilder: (context, index) {
                  return _buildImageCard(index);
                },
              ),
      ),
    );
  }

  Widget _buildImageCard(int index) {
    final color = _getColorFromIndex(index);
    final imageDetailsItem = imageDetails[index];

    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageDetailsItem['urls']['regular']),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          IconButton(
            onPressed: () => _showImageDetails(imageDetailsItem),
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }

  void _showImageDetails(Map<String, dynamic> imageDetails) {
    String imageUrl = imageDetails['urls']['regular'];
    String altDescription =
        imageDetails['alt_description'] ?? 'No description available';
    int likes = imageDetails['likes'];
    String photographer = imageDetails['user']?['name'] ?? 'Unknown';
    String photographerProfileUrl =
        imageDetails['user']?['links']?['html'] ?? '';

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align items to the left
              children: [
                Text(
                  'Image Details',
                  style: GoogleFonts.fredoka(fontSize: 24),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildDetailRow('Description:', altDescription),
                const SizedBox(height: 10),
                _buildDetailRow('Likes:', '$likes'),
                const SizedBox(height: 5),
                _buildDetailRow('Photographer:', photographer),
                if (photographerProfileUrl
                    .isNotEmpty) // Check if URL is not empty
                  TextButton(
                    onPressed: () {
                      launchUrl(
                          Uri.parse(photographerProfileUrl)); // Use uri parsing
                    },
                    child: const Text('View Profile'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              const TextStyle(fontWeight: FontWeight.bold), // Make label bold
        ),
        const SizedBox(width: 8), // Space between label and value
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: const Color.fromARGB(255, 176, 90, 118),
      unselectedItemColor:
          const Color.fromARGB(255, 176, 90, 118), // Set unselected color
      backgroundColor: const Color.fromARGB(255, 176, 90, 118),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '', // Label is empty
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: '', // Label is empty
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: '', // Label is empty
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '', // Label is empty
        ),
      ],
      showSelectedLabels: false, // Hide selected labels
      showUnselectedLabels: false, // Hide unselected labels
    );
  }

  // Function to get color based on index for color wheel effect
  Color _getColorFromIndex(int index) {
    const colors = [
      Color(0xFFFF5F6D), // Pink
      Color(0xFFFFC371), // Orange
    ];
    return colors[index % colors.length];
  }
}
