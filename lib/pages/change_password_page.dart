// Importación de dependencias necesarias
import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para la gestión de autenticación
import 'package:donut_app/utils/constants.dart'; // Importa constantes de la aplicación (colores, tamaños, etc.)
import 'package:donut_app/utils/validators.dart'; // Importa funciones de validación de formularios

// Definición de la clase ChangePasswordPage como un StatefulWidget
// Se usa StatefulWidget porque esta página necesita mantener estado (visibilidad de contraseñas, carga, etc.)
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key}); // Constructor con parámetro key opcional

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState(); // Crea el estado asociado a este widget
}

// Clase que mantiene el estado de ChangePasswordPage
class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>(); // Clave global para identificar y validar el formulario
  bool _isLoading = false; // Estado que controla si se está procesando una solicitud
  bool _isNewPasswordVisible = false; // Controla la visibilidad del campo de nueva contraseña
  bool _isConfirmPasswordVisible = false; // Controla la visibilidad del campo de confirmación

  // Controladores para los campos de texto del formulario
  final TextEditingController _newPasswordController = TextEditingController(); // Controlador para nueva contraseña
  final TextEditingController _confirmPasswordController = TextEditingController(); // Controlador para confirmación

  // Método para cambiar la contraseña del usuario
  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) { // Verifica si el formulario es válido
      setState(() => _isLoading = true); // Activa el indicador de carga

      try {
        final user = FirebaseAuth.instance.currentUser; // Obtiene el usuario actual
        if (user != null) { // Verifica que hay un usuario autenticado
          // Actualiza la contraseña en Firebase Auth
          await user.updatePassword(_newPasswordController.text.trim());

          if (mounted) { // Verifica que el widget sigue montado antes de actualizar la UI
            // Muestra mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Contraseña actualizada exitosamente')),
            );
            Navigator.of(context).pop(); // Regresa a la pantalla anterior
          }
        }
      } on FirebaseAuthException catch (e) { // Captura errores específicos de Firebase Auth
        String errorMessage = 'Error al cambiar la contraseña'; // Mensaje de error predeterminado
        if (e.code == 'requires-recent-login') {
          // Error específico cuando el usuario necesita volver a autenticarse
          errorMessage = 'Por favor, vuelve a autenticarte para cambiar tu contraseña';
        }

        if (mounted) { // Verifica que el widget sigue montado
          // Muestra mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } finally {
        // Este bloque se ejecuta siempre, independientemente de si hubo error o no
        if (mounted) { // Verifica que el widget sigue montado
          setState(() => _isLoading = false); // Desactiva el indicador de carga
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Estructura principal de la página
    return Scaffold(
      backgroundColor: appBackgroundColor, // Color de fondo definido en constants.dart
      appBar: AppBar(
        title: const Text(
          'Cambiar Contraseña', // Título de la barra de navegación
          style: TextStyle(
            color: Colors.white, // Texto en color blanco
            fontWeight: FontWeight.bold, // Texto en negrita
          ),
        ),
        backgroundColor: appPrimaryColor, // Color primario de la app para la AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Botón de regreso
          onPressed: () => Navigator.pop(context), // Acción de regresar a la pantalla anterior
        ),
      ),
      body: SingleChildScrollView(
        // Permite desplazamiento si el contenido es más grande que la pantalla
        padding: const EdgeInsets.all(kDefaultPadding), // Padding definido en constants.dart
        child: Form(
          key: _formKey, // Asigna la clave del formulario para validación
          child: Column(
            children: [
              const SizedBox(height: 40), // Espacio vertical

              // Ícono de cambio de contraseña
              const Icon(
                Icons.lock_reset, // Icono de restablecer contraseña
                size: 80, // Tamaño grande
                color: appPrimaryColor, // Color primario de la app
              ),
              const SizedBox(height: 20), // Espacio vertical

              // Título principal
              const Text(
                'Cambia tu contraseña',
                style: TextStyle(
                  fontSize: 24, // Tamaño de fuente grande
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
              ),
              const SizedBox(height: 10), // Espacio vertical pequeño

              // Subtítulo / instrucciones
              const Text(
                'Ingresa y confirma tu nueva contraseña',
                textAlign: TextAlign.center, // Texto centrado
                style: TextStyle(fontSize: 16), // Tamaño de fuente medio
              ),
              const SizedBox(height: 30), // Espacio vertical

              // Campo de entrada para la nueva contraseña
              TextFormField(
                controller: _newPasswordController, // Controlador del campo
                obscureText: !_isNewPasswordVisible, // Oculta el texto si _isNewPasswordVisible es false
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña', // Etiqueta del campo
                  prefixIcon: const Icon(Icons.lock), // Icono al inicio del campo
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                  ),
                  suffixIcon: IconButton(
                    // Botón para mostrar/ocultar contraseña
                    icon: Icon(
                      _isNewPasswordVisible
                          ? Icons.visibility // Icono cuando la contraseña es visible
                          : Icons.visibility_off, // Icono cuando la contraseña está oculta
                    ),
                    onPressed: () {
                      setState(() {
                        // Cambia el estado de visibilidad
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) => validateNewPassword(value), // Función de validación importada
              ),
              const SizedBox(height: 20), // Espacio vertical

              // Campo de entrada para confirmar la nueva contraseña
              TextFormField(
                controller: _confirmPasswordController, // Controlador del campo
                obscureText: !_isConfirmPasswordVisible, // Oculta el texto si _isConfirmPasswordVisible es false
                decoration: InputDecoration(
                  labelText: 'Confirmar nueva contraseña', // Etiqueta del campo
                  prefixIcon: const Icon(Icons.lock_outline), // Icono al inicio del campo
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                  ),
                  suffixIcon: IconButton(
                    // Botón para mostrar/ocultar contraseña
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility // Icono cuando la contraseña es visible
                          : Icons.visibility_off, // Icono cuando la contraseña está oculta
                    ),
                    onPressed: () {
                      setState(() {
                        // Cambia el estado de visibilidad
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) => validateConfirmPassword(
                  value, // Valor actual del campo
                  _newPasswordController.text.trim(), // Valor de la nueva contraseña para comparar
                ), // Función de validación importada
              ),
              const SizedBox(height: 30), // Espacio vertical

              // Botón de actualizar contraseña
              SizedBox(
                width: double.infinity, // Ocupa todo el ancho disponible
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword, // Desactiva el botón durante la carga
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appPrimaryColor, // Color de fondo del botón
                    foregroundColor: Colors.white, // Color del texto del botón
                    padding: const EdgeInsets.symmetric(vertical: 16), // Relleno vertical
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white) // Indicador de carga
                      : const Text(
                          'Actualizar Contraseña', // Texto del botón
                          style: TextStyle(fontSize: 16), // Tamaño de fuente medio
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