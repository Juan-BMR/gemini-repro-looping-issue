import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/network_security_report.dart' hide SecurityLevel;
import '../../domain/entities/security_level.dart';
import '../providers/network_security_providers.dart';
import '../widgets/network_item_card.dart';
import 'network_detail_screen.dart';
import '../../domain/entities/network.dart';

class NetworkAnalyzerScreen extends ConsumerWidget {
  const NetworkAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScanning = ref.watch(scanningNetworksProvider);
    final networksList = ref.watch(networksListProvider);
    final currentNetwork = ref.watch(currentNetworkProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Analyzer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isScanning
                ? null
                : () =>
                    ref.read(scanningNetworksProvider.notifier).state = true,
          ),
        ],
      ),
      body: Column(
        children: [
          // Current Network Status Card
          currentNetwork.when(
            data: (network) => _buildCurrentNetworkCard(context, network),
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          'Failed to get current network info',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Networks List
          Expanded(
            child: networksList.when(
              data: (networks) {
                if (networks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_find,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No networks found',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap refresh to scan again',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: networks.length,
                  itemBuilder: (context, index) {
                    final report = networks[index];
                    // Convert NetworkSecurityReport to Network for the detail screen
                    final securityLevel =
                        _convertSecurityLevel(report.securityLevel);
                    final network = Network(
                      ssid: report.ssid,
                      bssid: report.bssid,
                      encryption:
                          report.encryptionType.toString().split('.').last,
                      signalStrength: report.signalStrength,
                      frequency: report.frequency,
                      channel: report.channel,
                      securityLevel: securityLevel,
                    );

                    return NetworkItemCard(
                      network: report,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NetworkDetailScreen(network: network),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Scanning networks...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error scanning networks',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => ref.refresh(networksListProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to convert between different SecurityLevel enums
  SecurityLevel _convertSecurityLevel(dynamic originalLevel) {
    String levelName = originalLevel.toString().split('.').last;
    switch (levelName) {
      case 'critical':
        return SecurityLevel.critical;
      case 'vulnerable':
        return SecurityLevel.vulnerable;
      case 'acceptable':
        return SecurityLevel.acceptable;
      case 'secure':
        return SecurityLevel.secure;
      case 'optimal':
        return SecurityLevel.optimal;
      default:
        return SecurityLevel.vulnerable;
    }
  }

  Widget _buildCurrentNetworkCard(
      BuildContext context, NetworkSecurityReport report) {
    if (report.ssid == 'Not Connected') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.wifi_off,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12.0),
                const Text('Not connected to any network'),
              ],
            ),
          ),
        ),
      );
    }

    // Convert to Network if needed for detail screen
    final securityLevel = _convertSecurityLevel(report.securityLevel);
    final network = Network(
      ssid: report.ssid,
      bssid: report.bssid,
      encryption: report.encryptionType.toString().split('.').last,
      signalStrength: report.signalStrength,
      frequency: report.frequency,
      channel: report.channel,
      securityLevel: securityLevel,
    );

    final securityColor = _getSecurityColor(securityLevel);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NetworkDetailScreen(network: network),
            ),
          ),
          child: Column(
            children: [
              Container(
                color: securityColor.withOpacity(0.1),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.wifi,
                      color: securityColor,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Network',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            report.ssid.isEmpty
                                ? 'Hidden Network'
                                : report.ssid,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: securityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: securityColor.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        _getSecurityLevelText(securityLevel),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: securityColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(
                      context,
                      Icons.lock,
                      report.encryptionType
                          .toString()
                          .split('.')
                          .last
                          .toUpperCase(),
                    ),
                    _buildInfoItem(
                      context,
                      Icons.signal_cellular_alt,
                      '${report.signalStrength} dBm',
                    ),
                    _buildInfoItem(
                      context,
                      Icons.warning_amber_rounded,
                      '${report.vulnerabilities.length} issues',
                      color: report.vulnerabilities.isNotEmpty
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String text, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(
          icon,
          color: color ?? theme.colorScheme.onSurfaceVariant,
          size: 20.0,
        ),
        const SizedBox(height: 4.0),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color ?? theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Color _getSecurityColor(SecurityLevel level) {
    switch (level) {
      case SecurityLevel.critical:
        return Colors.red;
      case SecurityLevel.vulnerable:
        return Colors.orange;
      case SecurityLevel.acceptable:
        return Colors.yellow.shade800;
      case SecurityLevel.secure:
      case SecurityLevel.optimal:
        return Colors.green;
    }
  }

  String _getSecurityLevelText(SecurityLevel level) {
    switch (level) {
      case SecurityLevel.critical:
        return 'Critical';
      case SecurityLevel.vulnerable:
        return 'Vulnerable';
      case SecurityLevel.acceptable:
        return 'Acceptable';
      case SecurityLevel.secure:
        return 'Secure';
      case SecurityLevel.optimal:
        return 'Optimal';
    }
  }
}
