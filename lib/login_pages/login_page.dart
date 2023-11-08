import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_cats/Home/AppBar.dart';
import 'package:flutter_app_cats/login_pages/register_page.dart'; // Importa Firebase Auth

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: const Center(
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
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
              height: 300,
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
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.email,
                          size: 20,
                        ),
                        labelText: 'Email',
                      ),
                      validator: (String? value) {
                        return(value != null && value.contains('@')) ? 'Ingresa un Email valido.' : null;
                      },
                    ),
                    const SizedBox(height: 12.0),
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
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _login, // Llama a la función de inicio de sesión
                      child: const Text('Ingresar'),
                    ),
                    //const SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: const Text('Registrarse'),
                    ),
                  ],
                ),
              )
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
          ),
          
        ],
      )
    );
  }
}
