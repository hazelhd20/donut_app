import 'package:donut_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:donut_app/utils/constants.dart';
import 'package:donut_app/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Pantalla de registro como un StatefulWidget
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Variable para controlar la visibilidad de la contraseña
  bool _isPasswordVisible = false;

  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variables de estado para manejar la carga
  bool _isLoading = false;

  // Clave global para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Método para registrar un nuevo usuario
  void _register() async {
    // Valida el formulario antes de proceder
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Registro de usuario con correo electrónico y contraseña en Firebase
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            );

        // ✅ Agregar esto para guardar el nombre en el perfil
        await userCredential.user?.updateDisplayName(
          nameController.text.trim(),
        );

        // Enviar correo de verificación
        await userCredential.user?.sendEmailVerification();

        // Muestra un diálogo de verificación
        _showVerificationDialog('Se ha enviado un correo de verificación');
      } on FirebaseAuthException catch (e) {
        // Manejo de errores de registro
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'El correo electrónico ya está registrado';
            break;
          default:
            errorMessage = 'Error de registro: ${e.message}';
        }

        // Muestra un SnackBar con el mensaje de error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } finally {
        // Finaliza el estado de carga
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Método para mostrar un diálogo de verificación de correo
  void _showVerificationDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Verificación de Correo'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.of(context).pop(); // Regresa a la pantalla de login
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );
  }

  // Cambios en el método build del _RegisterScreenState
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                // Encabezado mejorado
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: appPrimaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_add,
                          size: 60,
                          color: appPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Crea tu cuenta",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: appPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Completa el formulario para registrarte",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Campo de nombre
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre completo",
                    floatingLabelStyle: TextStyle(color: appPrimaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appPrimaryColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey.shade600),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: validateName,
                ),
                const SizedBox(height: 20),

                // Campo de email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    floatingLabelStyle: TextStyle(color: appPrimaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appPrimaryColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.grey.shade600),
                    hintText: "ejemplo@correo.com",
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => validateEmail(value),
                ),
                const SizedBox(height: 20),

                // Campo de contraseña
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    floatingLabelStyle: TextStyle(color: appPrimaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appPrimaryColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: validatePassword,
                ),
                const SizedBox(height: 30),

                // Botón de registro
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      shadowColor: appPrimaryColor.withOpacity(0.3),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              "Registrarse",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 25),

                // Enlace a login
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "¿Ya tienes una cuenta? ",
                        style: TextStyle(color: Colors.grey.shade600),
                        children: const [
                          TextSpan(
                            text: "Inicia sesión",
                            style: TextStyle(
                              color: appPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
