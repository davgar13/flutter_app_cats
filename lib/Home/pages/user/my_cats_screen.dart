import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_cats/Home/pages/post/cat_detail_screen.dart';

class MyCatsScreen extends StatefulWidget {
  @override
  _MyCatsScreenState createState() => _MyCatsScreenState();
}

class _MyCatsScreenState extends State<MyCatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  List<DocumentSnapshot> _myCats = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    _currentUser = _auth.currentUser;

    if (_currentUser != null) {
      await getMyCats();
    }
  }

  Future<void> getMyCats() async {
    final QuerySnapshot catsQuery = await _firestore
        .collection('gatos')
        .where('owner_Email', isEqualTo: _currentUser!.email)
        .get();

    setState(() {
      _myCats = catsQuery.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Gatos'),
      ),
      body: ListView.builder(
        itemCount: _myCats.length,
        itemBuilder: (context, index) {
          final catData = _myCats[index].data() as Map<String, dynamic>;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CatDetailScreen(catData: catData),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Dueño: ${catData['nombre_dueño']}'),
                  ),
                  if (catData['image_url'] != null &&
                      catData['image_url'].isNotEmpty)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.0)),
                      child: Image.network(
                        catData['image_url'],
                        width: double.infinity,
                        height: 200.0,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Icon(
                              Icons.error); // Or any placeholder you'd like
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre del Gato: ${catData['nombre']}'),
                        Text('Descripción: ${catData['descripcion']}'),
                        Text('Sexo: ${catData['sexo']}'),
                        Text('Edad: ${catData['edad']}'),
                        Text('Teléfono del Dueño: ${catData['telefono']}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
