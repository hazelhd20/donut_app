import 'package:flutter/material.dart';
import 'package:donut_app/utils/constants.dart';
import 'package:donut_app/utils/validators.dart';
import 'package:donut_app/pages/phone_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isEmail = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (isEmail) {
          // Email registration
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: emailPhoneController.text.trim(), 
                password: passwordController.text
              );
          
          // Send email verification
          await userCredential.user?.sendEmailVerification();
          
          _showVerificationDialog('Se ha enviado un correo de verificación');
        } else {
          // Phone number registration
          // Format phone number if needed (e.g., +52 for Mexico)
          String formattedPhoneNumber = '+52${emailPhoneController.text.trim()}';
          
          // Navigate to phone verification screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneVerificationScreen(
                phoneNumber: formattedPhoneNumber
              ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'El correo electrónico ya está registrado';
            break;
          case 'invalid-phone-number':
            errorMessage = 'Número de teléfono inválido';
            break;
          default:
            errorMessage = 'Error de registro: ${e.message}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showVerificationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verificación de Correo'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to login
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

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
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: const [
                      Icon(Icons.person_add, size: 80, color: appPrimaryColor),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre completo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: validateName,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: emailPhoneController,
                  decoration: InputDecoration(
                    labelText: isEmail ? "Correo electrónico" : "Número de teléfono",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(isEmail ? Icons.email : Icons.phone),
                    hintText: isEmail ? "ejemplo@correo.com" : "10 dígitos",
                  ),
                  keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.phone,
                  validator: (value) => validateEmailOrPhone(value, isEmail),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isEmail = !isEmail;
                      });
                    },
                    child: Text(isEmail ? "Usar número de teléfono" : "Usar correo electrónico"),
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: validatePassword,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _register,
                    style: FilledButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Registrarse", style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text(
                      "¿Ya tienes una cuenta? Inicia sesión",
                      style: TextStyle(color: appPrimaryColor),
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