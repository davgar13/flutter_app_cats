import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          return ListTile(
            title: Text('Nombre del Gato: ${catData['nombre']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Raza: ${catData['raza']}'),
                Text('Edad: ${catData['edad']}'),
                Text('Sexo: ${catData['sexo']}'),
                Text('Teléfono: ${catData['telefono']}'),
                Text('Nombre del Dueño: ${catData['nombre_dueño']}'),
                Text('Descripción: ${catData['descripcion']}'),
                // Mostrar la imagen del gato si está disponible
                if (catData['image_url'] != null)
                  Image.network(catData['image_url']),
              ],
            ),
          );
        },
      ),
    );
  }
}
