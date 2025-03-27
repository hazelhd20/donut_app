// utils/validators.dart

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ingrese su nombre completo';
  }
  if (value.length < 2) {
    return 'El nombre debe tener al menos 2 caracteres';
  }
  // Basic regex to allow names with spaces and letters
  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
    return 'Ingrese un nombre válido';
  }
  return null;
}

String? validateEmailOrPhone(String? value, bool isEmail) {
  if (value == null || value.isEmpty) {
    return isEmail ? 'Ingrese un correo válido' : 'Ingrese un número de teléfono válido';
  }
  
  if (isEmail) {
    // More comprehensive email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
  } else {
    // Basic phone number validation (adjust regex as needed)
    final phoneRegex = RegExp(r'^[+]?[\d\s-]{10,14}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Ingrese un número de teléfono válido';
    }
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ingrese una contraseña';
  }
  
  // More robust password validation
  if (value.length < 8) {
    return 'La contraseña debe tener al menos 8 caracteres';
  }
  
  // Check for at least one uppercase, one lowercase, and one number
  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
    return 'La contraseña debe contener mayúsculas, minúsculas y números';
  }
  
  return null;
}