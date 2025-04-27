import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/network.dart';
import '../../domain/entities/security_level.dart';
import 'network_detail_screen.dart';

class NetworkListScreen extends ConsumerWidget {
  const NetworkListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, this would come from a provider
    final networks = _getMockNetworks();

    return Scaffold(
      appBar: AppBar(
        title: Text('WiFi Networks'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Would refresh networks in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Refreshing networks...')),
              );
            },
            tooltip: 'Refresh Networks',
          ),
        ],
      ),
      body: networks.isEmpty
          ? Center(child: Text('No networks found'))
          : ListView.builder(
              itemCount: networks.length,
              itemBuilder: (context, index) {
                final network = networks[index];
                return _buildNetworkListItem(context, network);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Starting manual scan...')),
          );
        },
        child: Icon(Icons.wifi_find),
        tooltip: 'Scan for Networks',
      ),
    );
  }

  Widget _buildNetworkListItem(BuildContext context, Network network) {
    final securityColor = _getSecurityColor(network.securityLevel);
    final signalIcon = _getSignalIcon(network.signalStrength);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NetworkDetailScreen(network: network),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                signalIcon,
                size: 36,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      network.ssid,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.security,
                          size: 16,
                          color: securityColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          network.encryption,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(' • '),
                        Text(
                          '${network.frequency} MHz',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${network.signalStrength} dBm',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ch ${network.channel}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSignalIcon(int signalStrength) {
    // WiFi signal strength is typically in negative dBm values
    // The closer to 0, the stronger the signal
    if (signalStrength > -50) {
      return Icons.signal_wifi_4_bar;
    } else if (signalStrength > -60) {
      return Icons.network_wifi;
    } else if (signalStrength > -70) {
      return Icons.signal_wifi_4_bar_lock;
    } else {
      return Icons.signal_wifi_0_bar;
    }
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
        return Colors.green;
      case SecurityLevel.optimal:
        return Colors.teal;
    }
  }

  // Mock data for demonstration purposes
  List<Network> _getMockNetworks() {
    return [
      Network(
        ssid: 'HomeNetwork',
        bssid: 'AA:BB:CC:DD:EE:FF',
        encryption: 'WPA2-PSK',
        signalStrength: -45,
        frequency: 5240,
        channel: 48,
        securityLevel: SecurityLevel.secure,
        ipAddress: '192.168.1.5',
        bandwidth: '80 MHz',
        standard: '802.11ac',
        linkSpeed: '867 Mbps',
        latency: 12,
        passwordStrength: 'Strong',
        routerSecurityLevel: 'Good',
        openPorts: [],
        connectedDevices: [],
      ),
      Network(
        ssid: 'CoffeeShopWiFi',
        bssid: 'FF:EE:DD:CC:BB:AA',
        encryption: 'WPA2-PSK',
        signalStrength: -65,
        frequency: 2437,
        channel: 6,
        securityLevel: SecurityLevel.acceptable,
        bandwidth: '20 MHz',
        standard: '802.11n',
      ),
      Network(
        ssid: 'GuestNetwork',
        bssid: '11:22:33:44:55:66',
        encryption: 'WPA-PSK',
        signalStrength: -58,
        frequency: 2412,
        channel: 1,
        securityLevel: SecurityLevel.vulnerable,
      ),
      Network(
        ssid: 'PublicWiFi',
        bssid: '66:55:44:33:22:11',
        encryption: 'Open',
        signalStrength: -72,
        frequency: 2437,
        channel: 6,
        securityLevel: SecurityLevel.critical,
      ),
      Network(
        ssid: 'SecurityPlus',
        bssid: 'AB:CD:EF:12:34:56',
        encryption: 'WPA3-PSK',
        signalStrength: -52,
        frequency: 5745,
        channel: 149,
        securityLevel: SecurityLevel.optimal,
        bandwidth: '160 MHz',
        standard: '802.11ax',
        linkSpeed: '2400 Mbps',
      ),
    ];
  }
}
