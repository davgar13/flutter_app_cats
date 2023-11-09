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
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('profile')
          .doc(currentUser.email)
          .get();

      if (profileSnapshot.exists) {
        setState(() {
          _profileData = profileSnapshot.data()! as Map<String, dynamic>;
        });
      } else {
        // Si el snapshot no existe, puedes usar el displayName de FirebaseAuth
        setState(() {
          _profileData = {
            'username': currentUser.displayName ?? 'Nombre no establecido',
            'email': currentUser.email ?? 'Email no establecido',
            // Añade otros campos con valores predeterminados si es necesario
          };
        });
      }
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
