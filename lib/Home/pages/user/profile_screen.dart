import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_cats/Home/pages/user/my_cats_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app_cats/login_pages/login_page.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  Map<String, dynamic> _profileData = {};

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _ciudadController = TextEditingController();
  TextEditingController _paisController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _imageController = TextEditingController();

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
        _usernameController.text = _profileData['username'] ?? '';
        _ciudadController.text = _profileData['ciudad'] ?? '';
        _paisController.text = _profileData['pais'] ?? '';
        _telefonoController.text = _profileData['telefono'] ?? '';
      });
    } else {
      setState(() {
        _profileData = {
          'username': 'No especificado',
          'email': _currentUser!.email,
          'ciudad': 'No especificado',
          'pais': 'No especificado',
          'telefono': 'No especificado',
        };
      });
    }
  }

  Future<void> updateProfile() async {
    try {
      Map<String, dynamic> updatedData = {};

      if (_usernameController.text.isNotEmpty) {
        updatedData['username'] = _usernameController.text;
      }

      if (_ciudadController.text.isNotEmpty) {
        updatedData['ciudad'] = _ciudadController.text;
      }

      if (_paisController.text.isNotEmpty) {
        updatedData['pais'] = _paisController.text;
      }

      if (_telefonoController.text.isNotEmpty) {
        updatedData['telefono'] = _telefonoController.text;
      }

      if (_imageController.text.isNotEmpty) {
        String imageUrl = await uploadImage(_imageController.text);
        updatedData['imagen_url'] = imageUrl;
      }

      await _firestore
          .collection('profile')
          .doc(_currentUser!.email)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado con éxito')),
      );
    } catch (e) {
      print('Error al actualizar el perfil: $e');
    }
  }

  Future<String> uploadImage(String imagePath) async {
    try {
      File file = File(imagePath);

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('profile_images')
          .child('${_currentUser!.email}_profile.jpg');

      await ref.putFile(file);

      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error al subir la imagen: $e');
      throw e;
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
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
          // Botón de cierre de sesión
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: _signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageController.text.isNotEmpty
                      ? FileImage(File(_imageController.text))
                          as ImageProvider<Object>?
                      : (_profileData['imagen_url'] != null
                          ? NetworkImage(_profileData['imagen_url']!)
                              as ImageProvider<Object>?
                          : null),
                  child: _imageController.text.isEmpty &&
                          _profileData['imagen_url'] == null
                      ? Icon(Icons.account_circle, size: 50)
                      : null,
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      setState(() {
                        _imageController.text = pickedFile.path;
                      });
                    }
                  },
                  child: Text(
                    'Cambiar Imagen',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 3.0,
                      spreadRadius: 0.0,
                    )
                  ],
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Nuevo Usuario'),
                    ),
                    TextFormField(
                      controller: _ciudadController,
                      decoration: InputDecoration(labelText: 'Nueva Ciudad'),
                    ),
                    TextFormField(
                      controller: _paisController,
                      decoration: InputDecoration(labelText: 'Nuevo País'),
                    ),
                    TextFormField(
                      controller: _telefonoController,
                      decoration: InputDecoration(labelText: 'Nuevo Teléfono'),
                    ),
                    if (_imageController.text.isNotEmpty)
                      Image.file(File(_imageController.text)),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: Text('Actualizar Perfil'),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
