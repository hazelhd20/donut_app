// Importación de paquetes necesarios
import 'package:donut_app/utils/constants.dart'; // Constantes de la aplicación como colores y valores predefinidos
import 'package:donut_app/utils/validators.dart'; // Funciones para validar formularios
import 'package:flutter/material.dart'; // Framework de Flutter para UI
import 'package:firebase_auth/firebase_auth.dart'; // Paquete de autenticación de Firebase

// Widget principal de la pantalla de recuperación de contraseña (StatefulWidget porque maneja estados)
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key}); // Constructor que acepta una key opcional

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState(); // Crea la instancia del estado
}

// Clase que maneja el estado de la pantalla de recuperación de contraseña
class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController(); // Controlador para el campo de correo electrónico
  bool _isLoading = false; // Estado para controlar cuando se está procesando la solicitud
  final _formKey = GlobalKey<FormState>(); // Clave global para identificar y validar el formulario

  // Método asíncrono para restablecer la contraseña
  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) { // Verifica si el formulario es válido
      setState(() => _isLoading = true); // Actualiza el estado a "cargando"

      try {
        // Envía solicitud a Firebase para restablecer la contraseña
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim() // Elimina espacios innecesarios del email
        );

        if (mounted) { // Verifica si el widget sigue en el árbol de widgets para evitar errores
          // Muestra un diálogo de confirmación
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Restablecer Contraseña'), // Título del diálogo
              content: Text('Se ha enviado un enlace de recuperación a ${_emailController.text}. Revisa tu correo electrónico.'), // Mensaje con el correo usado
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                    Navigator.of(context).pop(); // Regresa a la pantalla anterior
                  },
                  child: const Text('Aceptar'), // Texto del botón
                ),
              ],
            ),
          );
        }
      } on FirebaseAuthException catch (e) { // Captura excepciones específicas de Firebase Auth
        String errorMessage;
        // Manejo de diferentes códigos de error
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

        // Muestra mensaje de error en un Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() => _isLoading = false); // Restablece el estado de carga independientemente del resultado
      }
    }
  }

  @override
  Widget build(BuildContext context) { // Método que construye la interfaz de usuario
    return Scaffold(
      backgroundColor: appBackgroundColor, // Color de fondo definido en constants.dart
      appBar: AppBar( // Barra superior de la aplicación
        title: const Text(
          'Recuperar Contraseña',
          style: TextStyle(
            color: Colors.white, // Color blanco para el texto
            fontWeight: FontWeight.bold, // Texto en negrita
          ),
        ),
        backgroundColor: appPrimaryColor, // Color principal definido en constants.dart
        leading: IconButton( // Botón de retroceso en la esquina superior izquierda
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(), // Regresa a la pantalla anterior
        ),
      ),
      body: SingleChildScrollView( // Permite desplazamiento para evitar problemas con el teclado
        padding: const EdgeInsets.all(kDefaultPadding), // Padding estándar definido en constants.dart
        child: Form( // Formulario para manejo de validaciones
          key: _formKey, // Clave global para identificar este formulario
          child: Column( // Organiza los widgets verticalmente
            children: [
              const SizedBox(height: 40), // Espacio vertical

              const Icon( // Icono ilustrativo
                Icons.lock_reset, // Icono de reinicio de contraseña
                size: 80, // Tamaño grande
                color: appPrimaryColor, // Color principal de la app
              ),
              const SizedBox(height: 20), // Espacio vertical

              const Text( // Título principal
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  fontSize: 24, // Tamaño de fuente grande
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
              ),
              const SizedBox(height: 10), // Espacio vertical
              const Text( // Texto descriptivo
                'Ingresa tu correo electrónico para recibir instrucciones de recuperación',
                textAlign: TextAlign.center, // Centrado horizontal
                style: TextStyle(fontSize: 16), // Tamaño de fuente mediano
              ),
              const SizedBox(height: 30), // Espacio vertical

              TextFormField( // Campo de entrada para el correo
                controller: _emailController, // Controlador para acceder al valor
                keyboardType: TextInputType.emailAddress, // Teclado optimizado para emails
                decoration: InputDecoration( // Estilo del campo
                  labelText: 'Correo electrónico', // Etiqueta del campo
                  prefixIcon: const Icon(Icons.email), // Icono de correo al inicio
                  border: OutlineInputBorder( // Borde redondeado
                    borderRadius: BorderRadius.circular(10), // Radio de las esquinas
                  ),
                ),
                validator: (value) => validateEmail(value), // Función de validación de email importada
              ),
              const SizedBox(height: 30), // Espacio vertical

              SizedBox( // Contenedor para el botón con ancho completo
                width: double.infinity, // Ocupa todo el ancho disponible
                child: ElevatedButton( // Botón elevado (con sombra)
                  onPressed: _isLoading ? null : _resetPassword, // Si está cargando, deshabilita el botón
                  style: ElevatedButton.styleFrom( // Estilo del botón
                    backgroundColor: appPrimaryColor, // Color de fondo
                    foregroundColor: Colors.white, // Color del texto
                    padding: const EdgeInsets.symmetric(vertical: 16), // Padding vertical
                    shape: RoundedRectangleBorder( // Forma redondeada
                      borderRadius: BorderRadius.circular(10), // Radio de las esquinas
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white) // Muestra indicador de carga
                      : const Text( // Texto del botón
                          'Enviar enlace de recuperación',
                          style: TextStyle(fontSize: 16), // Tamaño de fuente mediano
                        ),
                ),
              ),
              const SizedBox(height: 20), // Espacio vertical final
            ],
          ),
        ),
      ),
    );
  }
}