import 'package:donut_app/utils/constants.dart';
import 'package:donut_app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Pantalla de recuperación de contraseña como un StatefulWidget
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Controlador para el campo de texto de correo electrónico
  final TextEditingController _emailController = TextEditingController();
  
  // Indicador de estado de carga
  bool _isLoading = false;
  
  // Clave global para el formulario, permite validación
  final _formKey = GlobalKey<FormState>();

  // Método asíncrono para restablecer la contraseña
  Future<void> _resetPassword() async {
    // Valida el formulario antes de proceder
    if (_formKey.currentState!.validate()) {
      // Establece el estado de carga a verdadero
      setState(() => _isLoading = true);
      
      try {
        // Envía un correo de restablecimiento de contraseña usando Firebase
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim()
        );
        
        // Verifica si el widget está montado para evitar errores
        if (mounted) {
          // Muestra un diálogo de éxito
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Restablecer Contraseña'),
              // Muestra un mensaje con el correo electrónico ingresado
              content: Text('Se ha enviado un enlace de recuperación a ${_emailController.text}. Revisa tu correo electrónico.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                    Navigator.of(context).pop(); // Regresa a la pantalla de inicio de sesión
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Manejo de diferentes tipos de errores de Firebase
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No se encontró un usuario con este correo electrónico';
            break;
          case 'invalid-email':
            errorMessage = 'Correo electrónico inválido';
            break;
          default:
            errorMessage = 'Error al restablecer contraseña: ${e.message}';
        }

        // Muestra un SnackBar con el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        // Establece el estado de carga a falso al finalizar
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo de la pantalla
      backgroundColor: appBackgroundColor,
      
      // Barra de aplicación personalizada
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        backgroundColor: appPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      
      // Contenido de la pantalla con desplazamiento
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Ícono de candado reset
              const Icon(
                Icons.lock_reset,
                size: 80,
                color: appPrimaryColor,
              ),
              const SizedBox(height: 20),
              
              // Títulos y descripciones
              const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ingresa tu correo electrónico para recibir instrucciones de recuperación',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              
              // Campo de texto para el correo electrónico
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Validación del correo electrónico
                validator: (value) => validateEmail(value),
              ),
              const SizedBox(height: 30),
              
              // Botón de envío con estado de carga
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Deshabilita el botón durante la carga
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Enviar enlace de recuperación',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Botón para volver a la pantalla de inicio de sesión
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Volver al inicio de sesión',
                  style: TextStyle(color: appPrimaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}