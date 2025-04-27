import 'package:equatable/equatable.dart';

/// Enum representing the security level of a WiFi network
enum SecurityLevel {
  critical, // No security or WEP
  vulnerable, // WPA with known vulnerabilities
  acceptable, // WPA2 with standard configuration
  secure, // WPA2/WPA3 with strong configuration
  optimal // WPA3 with all security features enabled
}

/// Enum representing the encryption type of a WiFi network
enum EncryptionType { none, wep, wpa, wpa2, wpa3, unknown }

/// Class representing a WiFi network security vulnerability
class SecurityVulnerability extends Equatable {
  final String title;
  final String description;
  final String risk;
  final String impact;

  const SecurityVulnerability({
    required this.title,
    required this.description,
    required this.risk,
    required this.impact,
  });

  @override
  List<Object?> get props => [title, description, risk, impact];
}

/// Class representing a security recommendation for a WiFi network
class SecurityRecommendation extends Equatable {
  final String title;
  final String description;
  final String benefit;
  final int priority; // 1-5, where 1 is highest priority

  const SecurityRecommendation({
    required this.title,
    required this.description,
    required this.benefit,
    required this.priority,
  });

  @override
  List<Object?> get props => [title, description, benefit, priority];
}

/// Class representing the security report for a WiFi network
class NetworkSecurityReport extends Equatable {
  final String ssid;
  final String bssid;
  final int signalStrength; // in dBm
  final int frequency; // in MHz
  final int channel;
  final EncryptionType encryptionType;
  final SecurityLevel securityLevel;
  final List<SecurityVulnerability> vulnerabilities;
  final List<SecurityRecommendation> recommendations;

  const NetworkSecurityReport({
    required this.ssid,
    required this.bssid,
    required this.signalStrength,
    required this.frequency,
    required this.channel,
    required this.encryptionType,
    required this.securityLevel,
    required this.vulnerabilities,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [
        ssid,
        bssid,
        signalStrength,
        frequency,
        channel,
        encryptionType,
        securityLevel,
        vulnerabilities,
        recommendations
      ];
}
