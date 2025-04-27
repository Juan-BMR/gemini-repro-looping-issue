import '../../domain/entities/network_security_report.dart';

class SecurityVulnerabilityModel extends SecurityVulnerability {
  const SecurityVulnerabilityModel({
    required String title,
    required String description,
    required String risk,
    required String impact,
  }) : super(
          title: title,
          description: description,
          risk: risk,
          impact: impact,
        );

  factory SecurityVulnerabilityModel.fromJson(Map<String, dynamic> json) {
    return SecurityVulnerabilityModel(
      title: json['title'],
      description: json['description'],
      risk: json['risk'],
      impact: json['impact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'risk': risk,
      'impact': impact,
    };
  }
}

class SecurityRecommendationModel extends SecurityRecommendation {
  const SecurityRecommendationModel({
    required String title,
    required String description,
    required String benefit,
    required int priority,
  }) : super(
          title: title,
          description: description,
          benefit: benefit,
          priority: priority,
        );

  factory SecurityRecommendationModel.fromJson(Map<String, dynamic> json) {
    return SecurityRecommendationModel(
      title: json['title'],
      description: json['description'],
      benefit: json['benefit'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'benefit': benefit,
      'priority': priority,
    };
  }
}

class NetworkSecurityReportModel extends NetworkSecurityReport {
  const NetworkSecurityReportModel({
    required String ssid,
    required String bssid,
    required int signalStrength,
    required int frequency,
    required int channel,
    required EncryptionType encryptionType,
    required SecurityLevel securityLevel,
    required List<SecurityVulnerability> vulnerabilities,
    required List<SecurityRecommendation> recommendations,
  }) : super(
          ssid: ssid,
          bssid: bssid,
          signalStrength: signalStrength,
          frequency: frequency,
          channel: channel,
          encryptionType: encryptionType,
          securityLevel: securityLevel,
          vulnerabilities: vulnerabilities,
          recommendations: recommendations,
        );

  factory NetworkSecurityReportModel.fromJson(Map<String, dynamic> json) {
    return NetworkSecurityReportModel(
      ssid: json['ssid'],
      bssid: json['bssid'],
      signalStrength: json['signalStrength'],
      frequency: json['frequency'],
      channel: json['channel'],
      encryptionType: _encryptionTypeFromString(json['encryptionType']),
      securityLevel: _securityLevelFromString(json['securityLevel']),
      vulnerabilities: (json['vulnerabilities'] as List)
          .map((v) => SecurityVulnerabilityModel.fromJson(v))
          .toList(),
      recommendations: (json['recommendations'] as List)
          .map((r) => SecurityRecommendationModel.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'bssid': bssid,
      'signalStrength': signalStrength,
      'frequency': frequency,
      'channel': channel,
      'encryptionType': encryptionType.toString().split('.').last,
      'securityLevel': securityLevel.toString().split('.').last,
      'vulnerabilities': (vulnerabilities as List<SecurityVulnerabilityModel>)
          .map((v) => v.toJson())
          .toList(),
      'recommendations': (recommendations as List<SecurityRecommendationModel>)
          .map((r) => r.toJson())
          .toList(),
    };
  }

  factory NetworkSecurityReportModel.fromWiFiAccessPoint(dynamic accessPoint) {
    // Map from WiFi access point to our model
    // This would need to be implemented based on the specific WiFi scanning library
    final String ssid = accessPoint.ssid ?? 'Unknown';
    final String bssid = accessPoint.bssid ?? '00:00:00:00:00:00';
    final int signalStrength = accessPoint.level ?? -100;
    final int frequency = accessPoint.frequency ?? 2400;

    // Calculate channel from frequency
    final int channel = _calculateChannelFromFrequency(frequency);

    // Determine encryption type
    final EncryptionType encryptionType = _determineEncryptionType(accessPoint);

    // Determine security level
    final SecurityLevel securityLevel = _determineSecurityLevel(encryptionType);

    // Generate security vulnerabilities
    final List<SecurityVulnerability> vulnerabilities =
        _generateVulnerabilities(encryptionType, signalStrength);

    // Generate recommendations
    final List<SecurityRecommendation> recommendations =
        _generateRecommendations(encryptionType, signalStrength);

    return NetworkSecurityReportModel(
      ssid: ssid,
      bssid: bssid,
      signalStrength: signalStrength,
      frequency: frequency,
      channel: channel,
      encryptionType: encryptionType,
      securityLevel: securityLevel,
      vulnerabilities: vulnerabilities,
      recommendations: recommendations,
    );
  }

  static int _calculateChannelFromFrequency(int frequency) {
    // IEEE 802.11 channel calculation
    if (frequency >= 2412 && frequency <= 2484) {
      // 2.4 GHz band
      return ((frequency - 2412) ~/ 5) + 1;
    } else if (frequency >= 5170 && frequency <= 5825) {
      // 5 GHz band
      return ((frequency - 5170) ~/ 5) + 34;
    } else {
      // Default to channel 1 if unknown
      return 1;
    }
  }

  static EncryptionType _determineEncryptionType(dynamic accessPoint) {
    // This would need to be implemented based on the specific WiFi scanning library
    // For now, return a placeholder value
    final String capabilities = accessPoint.capabilities ?? '';

    if (capabilities.contains('WPA3')) {
      return EncryptionType.wpa3;
    } else if (capabilities.contains('WPA2')) {
      return EncryptionType.wpa2;
    } else if (capabilities.contains('WPA')) {
      return EncryptionType.wpa;
    } else if (capabilities.contains('WEP')) {
      return EncryptionType.wep;
    } else if (capabilities.contains('ESS')) {
      return EncryptionType.none;
    } else {
      return EncryptionType.unknown;
    }
  }

  static SecurityLevel _determineSecurityLevel(EncryptionType encryptionType) {
    switch (encryptionType) {
      case EncryptionType.none:
        return SecurityLevel.critical;
      case EncryptionType.wep:
        return SecurityLevel.critical;
      case EncryptionType.wpa:
        return SecurityLevel.vulnerable;
      case EncryptionType.wpa2:
        return SecurityLevel.acceptable;
      case EncryptionType.wpa3:
        return SecurityLevel.optimal;
      case EncryptionType.unknown:
        return SecurityLevel.vulnerable;
    }
  }

  static List<SecurityVulnerability> _generateVulnerabilities(
      EncryptionType encryptionType, int signalStrength) {
    final List<SecurityVulnerability> vulnerabilities = [];

    switch (encryptionType) {
      case EncryptionType.none:
        vulnerabilities.add(const SecurityVulnerabilityModel(
          title: 'No Encryption',
          description:
              'This network does not use any encryption, making all data transmitted over it visible to anyone within range.',
          risk: 'High',
          impact:
              'Data transmitted over this network can be easily intercepted and read by attackers.',
        ));
        break;
      case EncryptionType.wep:
        vulnerabilities.add(const SecurityVulnerabilityModel(
          title: 'WEP Encryption',
          description:
              'This network uses WEP encryption, which has been broken and is considered insecure since 2001.',
          risk: 'High',
          impact:
              'WEP encryption can be cracked in minutes with readily available tools, exposing all network traffic.',
        ));
        break;
      case EncryptionType.wpa:
        vulnerabilities.add(const SecurityVulnerabilityModel(
          title: 'WPA Encryption',
          description:
              'This network uses first-generation WPA encryption, which has known vulnerabilities.',
          risk: 'Medium',
          impact:
              'WPA can be compromised using dictionary attacks against weak passwords.',
        ));
        break;
      case EncryptionType.wpa2:
        if (signalStrength > -55) {
          // Strong signal
          vulnerabilities.add(const SecurityVulnerabilityModel(
            title: 'Strong Signal',
            description:
                'This network has a very strong signal that extends beyond necessary boundaries.',
            risk: 'Low',
            impact:
                'Strong signals can be accessed from further away, potentially allowing attackers to target the network from a distance.',
          ));
        }
        break;
      case EncryptionType.wpa3:
        // WPA3 has no major vulnerabilities to report
        break;
      case EncryptionType.unknown:
        vulnerabilities.add(const SecurityVulnerabilityModel(
          title: 'Unknown Encryption',
          description:
              'The encryption method for this network could not be determined.',
          risk: 'Unknown',
          impact:
              'Without knowing the encryption method, security risks cannot be properly assessed.',
        ));
        break;
    }

    return vulnerabilities;
  }

  static List<SecurityRecommendation> _generateRecommendations(
      EncryptionType encryptionType, int signalStrength) {
    final List<SecurityRecommendation> recommendations = [];

    switch (encryptionType) {
      case EncryptionType.none:
        recommendations.add(const SecurityRecommendationModel(
          title: 'Enable Encryption',
          description:
              'Configure the router to use WPA2 or WPA3 encryption with a strong password.',
          benefit:
              'Prevents unauthorized access and protects data transmitted over the network.',
          priority: 1,
        ));
        break;
      case EncryptionType.wep:
        recommendations.add(const SecurityRecommendationModel(
          title: 'Upgrade Encryption',
          description: 'Replace WEP encryption with WPA2 or preferably WPA3.',
          benefit:
              'Modern encryption standards provide significantly better protection against attacks.',
          priority: 1,
        ));
        break;
      case EncryptionType.wpa:
        recommendations.add(const SecurityRecommendationModel(
          title: 'Upgrade to WPA2/WPA3',
          description:
              'Update your router firmware if possible and configure it to use WPA2 or WPA3 instead of WPA.',
          benefit:
              'Later encryption standards fix vulnerabilities present in WPA.',
          priority: 2,
        ));
        break;
      case EncryptionType.wpa2:
        recommendations.add(const SecurityRecommendationModel(
          title: 'Use Strong Password',
          description:
              'Ensure your WPA2 password is at least 12 characters long with a mix of letters, numbers, and symbols.',
          benefit:
              'Prevents dictionary and brute force attacks against your network password.',
          priority: 3,
        ));
        if (signalStrength > -55) {
          // Strong signal
          recommendations.add(const SecurityRecommendationModel(
            title: 'Adjust Signal Strength',
            description:
                'If possible, reduce the transmit power of your router to limit signal range.',
            benefit:
                'Reduces the distance from which attackers can attempt to access your network.',
            priority: 4,
          ));
        }
        break;
      case EncryptionType.wpa3:
        recommendations.add(const SecurityRecommendationModel(
          title: 'Keep Router Updated',
          description:
              'Ensure your router firmware is regularly updated to receive security patches.',
          benefit: 'Protects against newly discovered vulnerabilities.',
          priority: 3,
        ));
        break;
      case EncryptionType.unknown:
        recommendations.add(const SecurityRecommendationModel(
          title: 'Verify Network Security',
          description:
              'Check router settings to confirm it uses strong encryption (WPA2/WPA3).',
          benefit:
              'Ensures your network has adequate protection against unauthorized access.',
          priority: 2,
        ));
        break;
    }

    return recommendations;
  }

  static EncryptionType _encryptionTypeFromString(String value) {
    return EncryptionType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => EncryptionType.unknown,
    );
  }

  static SecurityLevel _securityLevelFromString(String value) {
    return SecurityLevel.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => SecurityLevel.vulnerable,
    );
  }
}
