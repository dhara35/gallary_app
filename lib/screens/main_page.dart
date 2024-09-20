import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pink Gradient Theme',
      theme: ThemeData(
        textTheme: GoogleFonts.fredokaOneTextTheme(), // Fredoka font theme
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatelessWidget {
  // List of quote image URLs from Google
  final List<String> imageQuotes = [
    "https://www.peakpx.com/en/hd-wallpaper-desktop-kztnr",
    "https://wallpapercave.com/wp/wp5439265.jpg",
    "https://wallpapercave.com/wp/wp7665059.jpg",
    "https://wallpapercave.com/wp/wp6627032.jpg",
    "https://www.pinterest.com/pin/70087337932791996/",
    "https://www.pxfuel.com/en/query?q=pink+quotes",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)], // Pink gradient
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Add SizedBox for padding between AppBar and category buttons
          SizedBox(height: 16.0), // Adjust this value to control the space

          // Category tabs at the top
          Container(
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: imageQuotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageQuotes[index]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 176, 90, 118),
        backgroundColor: const Color.fromARGB(255, 176, 90, 118),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;

  const CategoryButton({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)], // Pink gradient
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 2.0), // Adjust vertical padding here
          child: Center(
            // Center the text vertically
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14, // Optional: Adjust font size if needed
              ),
            ),
          ),
        ),
      ),
    );
  }
}
