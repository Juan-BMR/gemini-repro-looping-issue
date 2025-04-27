import 'package:equatable/equatable.dart';

/// Enum representing the risk level of a network connection
enum RiskLevel { low, medium, high, critical }

/// Class representing a network connection event
class ConnectionEvent extends Equatable {
  final String appName;
  final String packageName;
  final String protocol; // TCP, UDP, etc.
  final String sourceAddress;
  final int sourcePort;
  final String destinationAddress;
  final int destinationPort;
  final DateTime timestamp;
  final int dataSize; // in bytes
  final bool isOutbound;
  final bool isSecure; // HTTPS vs HTTP
  final bool isMalicious; // Known bad destination
  final bool isExpected; // Expected behavior for this app
  final RiskLevel riskLevel;

  const ConnectionEvent({
    required this.appName,
    required this.packageName,
    required this.protocol,
    required this.sourceAddress,
    required this.sourcePort,
    required this.destinationAddress,
    required this.destinationPort,
    required this.timestamp,
    required this.dataSize,
    required this.isOutbound,
    required this.isSecure,
    required this.isMalicious,
    required this.isExpected,
    required this.riskLevel,
  });

  /// Create a copy of this ConnectionEvent with modified properties
  ConnectionEvent copyWith({
    String? appName,
    String? packageName,
    String? protocol,
    String? sourceAddress,
    int? sourcePort,
    String? destinationAddress,
    int? destinationPort,
    DateTime? timestamp,
    int? dataSize,
    bool? isOutbound,
    bool? isSecure,
    bool? isMalicious,
    bool? isExpected,
    RiskLevel? riskLevel,
  }) {
    return ConnectionEvent(
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      protocol: protocol ?? this.protocol,
      sourceAddress: sourceAddress ?? this.sourceAddress,
      sourcePort: sourcePort ?? this.sourcePort,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      destinationPort: destinationPort ?? this.destinationPort,
      timestamp: timestamp ?? this.timestamp,
      dataSize: dataSize ?? this.dataSize,
      isOutbound: isOutbound ?? this.isOutbound,
      isSecure: isSecure ?? this.isSecure,
      isMalicious: isMalicious ?? this.isMalicious,
      isExpected: isExpected ?? this.isExpected,
      riskLevel: riskLevel ?? this.riskLevel,
    );
  }

  @override
  List<Object?> get props => [
        appName,
        packageName,
        protocol,
        sourceAddress,
        sourcePort,
        destinationAddress,
        destinationPort,
        timestamp,
        dataSize,
        isOutbound,
        isSecure,
        isMalicious,
        isExpected,
        riskLevel,
      ];
}

/// Class representing app data usage statistics
class AppDataUsageStats extends Equatable {
  final String appName;
  final String packageName;
  final int receivedBytes;
  final int sentBytes;
  final int totalBytes;
  final DateTime startTime;
  final DateTime endTime;

  const AppDataUsageStats({
    required this.appName,
    required this.packageName,
    required this.receivedBytes,
    required this.sentBytes,
    required this.totalBytes,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [
        appName,
        packageName,
        receivedBytes,
        sentBytes,
        totalBytes,
        startTime,
        endTime
      ];
}

/// Class representing app privacy concern
class PrivacyConcern extends Equatable {
  final String appName;
  final String packageName;
  final String concernType; // e.g., "location_tracking", "mic_access", etc.
  final String description;
  final RiskLevel riskLevel;
  final String recommendation;

  const PrivacyConcern({
    required this.appName,
    required this.packageName,
    required this.concernType,
    required this.description,
    required this.riskLevel,
    required this.recommendation,
  });

  @override
  List<Object?> get props => [
        appName,
        packageName,
        concernType,
        description,
        riskLevel,
        recommendation
      ];
}
