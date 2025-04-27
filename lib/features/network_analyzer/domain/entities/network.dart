import 'package:flutter/foundation.dart';
import 'security_level.dart';
import 'device.dart';

class Network {
  final String ssid;
  final String bssid;
  final String encryption;
  final int signalStrength;
  final int frequency;
  final int channel;
  final SecurityLevel securityLevel;

  // Optional properties
  final String? ipAddress;
  final String? bandwidth;
  final String? standard;
  final String? linkSpeed;
  final int? latency;
  final String? passwordStrength;
  final String? routerSecurityLevel;
  final List<String>? openPorts;
  final List<Device>? connectedDevices;

  const Network({
    required this.ssid,
    required this.bssid,
    required this.encryption,
    required this.signalStrength,
    required this.frequency,
    required this.channel,
    required this.securityLevel,
    this.ipAddress,
    this.bandwidth,
    this.standard,
    this.linkSpeed,
    this.latency,
    this.passwordStrength,
    this.routerSecurityLevel,
    this.openPorts,
    this.connectedDevices,
  });

  Network copyWith({
    String? ssid,
    String? bssid,
    String? encryption,
    int? signalStrength,
    int? frequency,
    int? channel,
    SecurityLevel? securityLevel,
    String? ipAddress,
    String? bandwidth,
    String? standard,
    String? linkSpeed,
    int? latency,
    String? passwordStrength,
    String? routerSecurityLevel,
    List<String>? openPorts,
    List<Device>? connectedDevices,
  }) {
    return Network(
      ssid: ssid ?? this.ssid,
      bssid: bssid ?? this.bssid,
      encryption: encryption ?? this.encryption,
      signalStrength: signalStrength ?? this.signalStrength,
      frequency: frequency ?? this.frequency,
      channel: channel ?? this.channel,
      securityLevel: securityLevel ?? this.securityLevel,
      ipAddress: ipAddress ?? this.ipAddress,
      bandwidth: bandwidth ?? this.bandwidth,
      standard: standard ?? this.standard,
      linkSpeed: linkSpeed ?? this.linkSpeed,
      latency: latency ?? this.latency,
      passwordStrength: passwordStrength ?? this.passwordStrength,
      routerSecurityLevel: routerSecurityLevel ?? this.routerSecurityLevel,
      openPorts: openPorts ?? this.openPorts,
      connectedDevices: connectedDevices ?? this.connectedDevices,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Network &&
        other.ssid == ssid &&
        other.bssid == bssid &&
        other.encryption == encryption &&
        other.signalStrength == signalStrength &&
        other.frequency == frequency &&
        other.channel == channel &&
        other.securityLevel == securityLevel &&
        other.ipAddress == ipAddress &&
        other.bandwidth == bandwidth &&
        other.standard == standard &&
        other.linkSpeed == linkSpeed &&
        other.latency == latency &&
        other.passwordStrength == passwordStrength &&
        other.routerSecurityLevel == routerSecurityLevel &&
        listEquals(other.openPorts, openPorts) &&
        listEquals(other.connectedDevices, connectedDevices);
  }

  @override
  int get hashCode {
    return ssid.hashCode ^
        bssid.hashCode ^
        encryption.hashCode ^
        signalStrength.hashCode ^
        frequency.hashCode ^
        channel.hashCode ^
        securityLevel.hashCode ^
        ipAddress.hashCode ^
        bandwidth.hashCode ^
        standard.hashCode ^
        linkSpeed.hashCode ^
        latency.hashCode ^
        passwordStrength.hashCode ^
        routerSecurityLevel.hashCode ^
        openPorts.hashCode ^
        connectedDevices.hashCode;
  }
}
