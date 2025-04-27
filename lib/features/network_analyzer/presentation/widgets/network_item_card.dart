import 'package:flutter/material.dart';
import '../../domain/entities/network_security_report.dart';

class NetworkItemCard extends StatelessWidget {
  final NetworkSecurityReport network;
  final VoidCallback onTap;

  const NetworkItemCard({
    super.key,
    required this.network,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      network.ssid.isEmpty ? 'Hidden Network' : network.ssid,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildSecurityBadge(context),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  _buildSignalIcon(),
                  const SizedBox(width: 8.0),
                  Text('${network.signalStrength} dBm'),
                  const SizedBox(width: 16.0),
                  Text('Ch ${network.channel}'),
                  const SizedBox(width: 16.0),
                  Text('${_formatFrequency(network.frequency)}'),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.lock,
                    size: 16.0,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.7),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    _encryptionTypeText(network.encryptionType),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withOpacity(0.7),
                        ),
                  ),
                ],
              ),
              if (network.vulnerabilities.isNotEmpty) ...[
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16.0,
                      color: _getVulnerabilitiesColor(context),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '${network.vulnerabilities.length} ${network.vulnerabilities.length == 1 ? 'vulnerability' : 'vulnerabilities'} detected',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _getVulnerabilitiesColor(context),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityBadge(BuildContext context) {
    Color color;
    String text;

    switch (network.securityLevel) {
      case SecurityLevel.critical:
        color = Colors.red;
        text = 'Critical';
        break;
      case SecurityLevel.vulnerable:
        color = Colors.orange;
        text = 'Vulnerable';
        break;
      case SecurityLevel.acceptable:
        color = Colors.blue;
        text = 'Acceptable';
        break;
      case SecurityLevel.secure:
        color = Colors.green;
        text = 'Secure';
        break;
      case SecurityLevel.optimal:
        color = Colors.green;
        text = 'Optimal';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSignalIcon() {
    IconData iconData;

    // Signal strength categories
    if (network.signalStrength > -50) {
      iconData = Icons.signal_wifi_4_bar;
    } else if (network.signalStrength > -70) {
      iconData = Icons.network_wifi_3_bar;
    } else if (network.signalStrength > -80) {
      iconData = Icons.network_wifi_2_bar;
    } else if (network.signalStrength > -90) {
      iconData = Icons.network_wifi_1_bar;
    } else {
      iconData = Icons.signal_wifi_0_bar;
    }

    return Icon(
      iconData,
      size: 16.0,
    );
  }

  String _encryptionTypeText(EncryptionType type) {
    switch (type) {
      case EncryptionType.none:
        return 'Open (No Encryption)';
      case EncryptionType.wep:
        return 'WEP';
      case EncryptionType.wpa:
        return 'WPA';
      case EncryptionType.wpa2:
        return 'WPA2';
      case EncryptionType.wpa3:
        return 'WPA3';
      case EncryptionType.unknown:
        return 'Unknown';
    }
  }

  String _formatFrequency(int frequency) {
    if (frequency > 5000) {
      return '5 GHz';
    } else if (frequency > 2000) {
      return '2.4 GHz';
    } else {
      return '$frequency MHz';
    }
  }

  Color _getVulnerabilitiesColor(BuildContext context) {
    switch (network.securityLevel) {
      case SecurityLevel.critical:
        return Colors.red;
      case SecurityLevel.vulnerable:
        return Colors.orange;
      case SecurityLevel.acceptable:
      case SecurityLevel.secure:
      case SecurityLevel.optimal:
        return Colors.blue;
    }
  }
}
