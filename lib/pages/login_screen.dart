import 'package:donut_app/pages/forgot_password_screen.dart';
import 'package:donut_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:donut_app/utils/constants.dart';
import 'package:donut_app/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Pantalla de inicio de sesión como un StatefulWidget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables de estado para controlar la visibilidad de la contraseña y el estado de carga
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  
  // Clave global para validar el formulario
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para los campos de texto de correo electrónico y contraseña
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Verifica si el usuario ya está logged in al iniciar la pantalla
    _checkIfUserIsLoggedIn();
  }

  // Método para verificar si hay un usuario ya autenticado
  void _checkIfUserIsLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // Si el usuario está logged in y verificado, redirige a la página de inicio
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false, // Elimina todas las rutas anteriores
        );
      });
    }
  }

  // Método para iniciar sesión con correo electrónico y contraseña
  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      // Establece el estado de carga
      setState(() => _isLoading = true);
      try {
        // Intenta iniciar sesión con Firebase
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            );

        // Verifica si el correo electrónico está verificado
        if (!userCredential.user!.emailVerified) {
          // Si no está verificado, envía un nuevo enlace de verificación
          await userCredential.user!.sendEmailVerification();
          _showVerificationDialog();
          return;
        }

        // Redirige a la página de inicio
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        // Manejo de errores de autenticación
        String errorMessage = 'Error de inicio de sesión';
        if (e.code == 'user-not-found') {
          errorMessage = 'No se encontró un usuario con este correo';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Contraseña incorrecta';
        }

        // Muestra un SnackBar con el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage))
        );
      } finally {
        // Finaliza el estado de carga
        setState(() => _isLoading = false);
      }
    }
  }

  // Método para mostrar un diálogo de verificación de correo
  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verificación de Correo'),
        content: const Text(
          'Por favor verifica tu correo electrónico. Se ha enviado un nuevo enlace de verificación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // Método para iniciar sesión con Google
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // Inicia el flujo de inicio de sesión de Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      // Obtiene los detalles de autenticación de Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crea una credencial de Firebase con los tokens de Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión en Firebase con la credencial de Google
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Redirige a la página de inicio
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage())
      );
    } catch (e) {
      // Muestra un SnackBar en caso de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error con Google Sign-In: $e'))
      );
    } finally {
      // Finaliza el estado de carga
      setState(() => _isLoading = false);
    }
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Ícono de candado
                const Icon(Icons.lock, size: 80, color: appPrimaryColor),
                const SizedBox(height: 20),
                
                // Campo de texto para correo electrónico
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => validateEmail(value),
                ),
                const SizedBox(height: 15),
                
                // Campo de texto para contraseña
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    // Botón para mostrar/ocultar contraseña
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                const SizedBox(height: 10),
                
                // Enlace para recuperar contraseña
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(color: appPrimaryColor),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Botón de inicio de sesión
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _signInWithEmailAndPassword,
                    style: FilledButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Iniciar sesión",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Separador "o"
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("o"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Botón de inicio de sesión con Google
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    icon: Image.asset(
                      'lib/assets/icons/google.png',
                      height: 24,
                    ),
                    label: const Text("Iniciar sesión con Google"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}