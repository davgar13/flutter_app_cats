import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_cats/Home/pages/user/my_cats_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  Map<String, dynamic> _profileData = {};

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  
  Future<void> getCurrentUser() async {
    _currentUser = _auth.currentUser;

    if (_currentUser != null) {
      await getUserProfileData();
    }
  }

  Future<void> getUserProfileData() async {
    final DocumentSnapshot profileSnapshot =
        await _firestore.collection('profile').doc(_currentUser!.email).get();

    if (profileSnapshot.exists && profileSnapshot.data() != null) {
      setState(() {
        _profileData = profileSnapshot.data()! as Map<String, dynamic>;
      });
    } else {
      // Maneja el caso en que no existen datos del perfil, por ejemplo:
      setState(() {
        _profileData = {
          'username': 'No especificado',
          'email': _currentUser!.email,
          // Inicializa los otros campos que esperas encontrar en tu perfil.
        };
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.book_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MyCatsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileField(
              label: 'Usuario',
              value: _profileData['username'] ?? 'Ingresar dato',
            ),
            ProfileField(
              label: 'Email',
              value: _profileData['email'] ?? 'Ingresar dato',
            ),
            ProfileField(
              label: 'Ciudad',
              value: _profileData['ciudad'] ?? 'Ingresar dato',
            ),
            ProfileField(
              label: 'País',
              value: _profileData['pais'] ?? 'Ingresar dato',
            ),
            ProfileField(
              label: 'Teléfono',
              value: _profileData['telefono'] ?? 'Ingresar dato',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
