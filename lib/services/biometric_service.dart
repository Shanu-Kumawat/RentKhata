/// Biometric authentication service.
library;

import 'package:local_auth/local_auth.dart';

/// Device biometric support status.
enum BiometricSupport {
  /// Biometrics available and enrolled
  available,

  /// Device doesn't support biometrics
  notAvailable,

  /// Biometrics supported but not enrolled
  notEnrolled,
}

/// Result of biometric authentication attempt.
enum BiometricResult {
  /// Authentication successful
  success,

  /// Authentication failed (wrong fingerprint etc.)
  failed,

  /// User cancelled authentication
  cancelled,

  /// Biometrics not available on device
  notAvailable,
}

/// Service for device biometric authentication.
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports and has biometrics enrolled.
  Future<BiometricSupport> checkBiometricSupport() async {
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        return BiometricSupport.notAvailable;
      }

      final availableBiometrics = await _auth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return BiometricSupport.notEnrolled;
      }

      return BiometricSupport.available;
    } catch (e) {
      return BiometricSupport.notAvailable;
    }
  }

  /// Get list of available biometric types on device.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Authenticate user with biometrics.
  ///
  /// [reason] is shown to user in the biometric prompt.
  /// Returns [BiometricResult] indicating success/failure.
  Future<BiometricResult> authenticate({
    String reason = 'Authenticate to access RentKhata',
  }) async {
    try {
      final support = await checkBiometricSupport();
      if (support != BiometricSupport.available) {
        return BiometricResult.notAvailable;
      }

      final success = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN/pattern fallback
        ),
      );

      return success ? BiometricResult.success : BiometricResult.failed;
    } catch (e) {
      // User cancelled or other error
      return BiometricResult.cancelled;
    }
  }

  /// Stop any ongoing authentication.
  Future<void> stopAuthentication() async {
    await _auth.stopAuthentication();
  }
}
