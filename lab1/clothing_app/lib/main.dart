import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '211097',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const HomePage(title: '211097'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> clothes = [
    {
      'name': 'T-Shirt',
      'image':
          'https://img01.ztat.net/article/spp-media-p1/b1a8e89c637740db915d185a34cee9f1/f8b3e4fe8aa84a20877989dc6810cc0d.jpg?imwidth=1800',
      'description':
          'METAL VENT TECH SHORT-SLEEVE - Basic T-shirt - slate white',
      'price': 25.00,
    },
    {
      'name': 'Jeans',
      'image':
          'https://img01.ztat.net/article/spp-media-p1/0eb809c280794f10bc23c5a60fe81587/15c8c9322ebf4a42823c5dd4f72b2934.jpg?imwidth=1800&filter=packshot',
      'description': 'Pre-owned Slim fit jeans - brown',
      'price': 40.00,
    },
    {
      'name': 'Jacket',
      'image':
          'https://img01.ztat.net/article/spp-media-p1/62bd6372393e4e4abea67efb72809141/dbbe6b08d57840058e0e9b6dbced73e5.jpg?imwidth=1800',
      'description': 'Summer jacket - marl grey',
      'price': 294.00,
    },
    {
      'name': 'Sneakers',
      'image':
          'https://img01.ztat.net/article/spp-media-p1/553c5bd966ed3085afe815aed8fae88a/e3e7c98e73a1467a866815e8ffc1315e.jpg?imwidth=1800',
      'description': 'AIR FORCE 1 \'07 - Trainers - white',
      'price': 50.00,
    },
    {
      'name': 'Watch',
      'image':
          'https://img01.ztat.net/article/spp-media-p1/74c4ca93ddea34e782e89ead5805fc4c/73c7297d72614eff8a4f689523ec89b0.jpg?imwidth=1800&filter=packshot',
      'description': 'Tommy Hilfiger Chronograph watch',
      'price': 135.00,
    },
  ];

  void _addNewClothingItem() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    double? getPrice() {
      final numericString =
          priceController.text.replaceAll(RegExp(r'[^0-9\.]'), '');
      if (numericString.isEmpty) return 0;
      return double.tryParse(numericString);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Clothing Item"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  clothes.add({
                    'name': nameController.text,
                    'image': imageController.text.isEmpty
                        ? 'https://via.placeholder.com/150'
                        : imageController.text,
                    'description': descriptionController.text,
                    'price': getPrice(),
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: clothes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(item: clothes[index]),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      clothes[index]['image'],
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      clothes[index]['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewClothingItem,
        tooltip: 'Add New Clothing Item',
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(item['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                item['image'],
                height: 500,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Price: \$${item['price'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'You bought ${item['name']} for \$${item['price'].toStringAsFixed(2)}!')),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Buy Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
