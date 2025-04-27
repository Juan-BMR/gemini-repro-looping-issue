class Device {
  final String? name;
  final String? macAddress;
  final String? ipAddress;
  final String? deviceType;
  final bool? isConnected;
  final DateTime? lastSeen;
  final int? signalStrength;
  final String? manufacturer;

  const Device({
    this.name,
    this.macAddress,
    this.ipAddress,
    this.deviceType,
    this.isConnected,
    this.lastSeen,
    this.signalStrength,
    this.manufacturer,
  });

  Device copyWith({
    String? name,
    String? macAddress,
    String? ipAddress,
    String? deviceType,
    bool? isConnected,
    DateTime? lastSeen,
    int? signalStrength,
    String? manufacturer,
  }) {
    return Device(
      name: name ?? this.name,
      macAddress: macAddress ?? this.macAddress,
      ipAddress: ipAddress ?? this.ipAddress,
      deviceType: deviceType ?? this.deviceType,
      isConnected: isConnected ?? this.isConnected,
      lastSeen: lastSeen ?? this.lastSeen,
      signalStrength: signalStrength ?? this.signalStrength,
      manufacturer: manufacturer ?? this.manufacturer,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Device &&
        other.name == name &&
        other.macAddress == macAddress &&
        other.ipAddress == ipAddress &&
        other.deviceType == deviceType &&
        other.isConnected == isConnected &&
        other.lastSeen == lastSeen &&
        other.signalStrength == signalStrength &&
        other.manufacturer == manufacturer;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        macAddress.hashCode ^
        ipAddress.hashCode ^
        deviceType.hashCode ^
        isConnected.hashCode ^
        lastSeen.hashCode ^
        signalStrength.hashCode ^
        manufacturer.hashCode;
  }
}
