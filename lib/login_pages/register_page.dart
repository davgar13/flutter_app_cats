import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_cats/Home/AppBar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: const Center(
        child: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      // Registra el nuevo usuario
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Asegúrate de obtener el usuario recién registrado
      User? newUser = userCredential.user;

      // Actualiza el displayName del usuario recién registrado con el nombre de usuario proporcionado
      if (newUser != null) {
        await newUser.updateDisplayName(_usernameController.text);

        // Puede que necesites recargar el usuario para obtener la información actualizada
        await newUser.reload();
        newUser = FirebaseAuth.instance.currentUser;

        // Guarda los datos del usuario en la colección 'profile' de Firestore
        await FirebaseFirestore.instance
            .collection('profile')
            .doc(newUser!.email)
            .set({
          'username': _usernameController.text,
          'email': newUser.email,
          'ciudad': "",
          'image_url': "",
          'owner_Email': newUser.email, // Este es el correo del nuevo usuario
          'pais': "",
          'telefono': "",
        });


    


     // Navega a la pantalla de inicio (HomeScreen) aquí
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('Error: No se pudo obtener el nuevo usuario.');
      }
    } catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Image.asset('asset/images/MyCat.png'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 155, 20, 50),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  width: 250,
                  height: 290,
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.person,
                              size: 20,
                            ),
                            labelText: 'Nombre de Usuario'
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa un nombre de usuario.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.email,
                              size: 20,
                            ),
                            labelText: 'Email'
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa un email válido.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.lock, 
                              size: 20,
                              textDirection: TextDirection.ltr,
                            ),
                            labelText: 'Contraseña'
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa una contraseña.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: (){
                            _register();
                          }, // Llama a la función de registro
                          child: const Text('Registrar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(110, 50, 10, 50),
                child: Image.asset('asset/images/cat2.png',
                width: 150,
                height: 150,
              ),
            )
            ],
          )
        ],
      )
    );
  }
}
