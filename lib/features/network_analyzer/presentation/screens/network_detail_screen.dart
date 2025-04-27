import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/network.dart';
import '../../domain/entities/security_level.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class NetworkDetailScreen extends ConsumerWidget {
  final Network network;

  const NetworkDetailScreen({
    super.key,
    required this.network,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.security),
            onPressed: () => _showSecurityAnalysisDialog(context),
            tooltip: 'Security Analysis',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNetworkInfoCard(),
            SizedBox(height: 16),
            _buildSecurityInfoCard(),
            SizedBox(height: 16),
            _buildPerformanceCard(),
            SizedBox(height: 16),
            _buildWifiChannelAnalyzerCard(),
            SizedBox(height: 16),
            _buildTrafficMonitoringCard(),
            SizedBox(height: 16),
            _buildNetworkTopologyCard(),
            SizedBox(height: 16),
            _buildConnectedDevicesSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNetworkActionsMenu(context),
        child: Icon(Icons.more_vert),
        tooltip: 'Network Actions',
      ),
    );
  }

  Widget _buildNetworkInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Network Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _buildInfoRow('SSID', network.ssid),
            _buildInfoRow('BSSID', network.bssid),
            _buildInfoRow('IP Address', network.ipAddress ?? 'Not connected'),
            _buildInfoRow('Signal Strength', '${network.signalStrength} dBm'),
            _buildInfoRow('Frequency', '${network.frequency} MHz'),
            _buildInfoRow('Encryption', network.encryption),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityInfoCard() {
    final securityLevel = network.securityLevel;
    final securityColor = _getSecurityColor(securityLevel);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security Assessment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Row(
              children: [
                Icon(Icons.security, color: securityColor, size: 36),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getSecurityLevelName(securityLevel),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: securityColor),
                    ),
                    Text(_getSecurityDescription(securityLevel)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildSecurityRecommendations(securityLevel),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _buildInfoRow('Channel', '${network.channel}'),
            _buildInfoRow('Bandwidth', network.bandwidth ?? 'Unknown'),
            _buildInfoRow('Standard', network.standard ?? 'Unknown'),
            _buildInfoRow('Link Speed', network.linkSpeed ?? 'Unknown'),
            if (network.latency != null)
              _buildInfoRow('Latency', '${network.latency} ms'),
          ],
        ),
      ),
    );
  }

  Widget _buildWifiChannelAnalyzerCard() {
    // Mock data for nearby networks - in a real app this would come from a scan
    final List<Map<String, dynamic>> nearbyNetworks = [
      {
        'ssid': network.ssid,
        'channel': network.channel,
        'signalStrength': network.signalStrength,
        'isCurrentNetwork': true,
      },
      {
        'ssid': 'Neighbor_Network_1',
        'channel':
            network.channel - 1 > 0 ? network.channel - 1 : network.channel + 2,
        'signalStrength': -65,
        'isCurrentNetwork': false,
      },
      {
        'ssid': 'Neighbor_Network_2',
        'channel': network.channel + 1 <= 13
            ? network.channel + 1
            : network.channel - 2,
        'signalStrength': -72,
        'isCurrentNetwork': false,
      },
      {
        'ssid': 'Neighbor_Network_3',
        'channel':
            network.channel - 3 > 0 ? network.channel - 3 : network.channel + 5,
        'signalStrength': -56,
        'isCurrentNetwork': false,
      },
      {
        'ssid': 'Neighbor_Network_4',
        'channel': network.channel + 4 <= 13
            ? network.channel + 4
            : network.channel - 4,
        'signalStrength': -80,
        'isCurrentNetwork': false,
      },
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WiFi Channel Analysis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: ChannelAnalyzerPainter(
                  networks: nearbyNetworks,
                  currentChannel: network.channel,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Channel Interference Analysis',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildChannelInterferenceTable(nearbyNetworks),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Your network is on channel ${network.channel}, which has ${_getChannelCongestionText(nearbyNetworks)} channel congestion.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showChannelRecommendationDialog(context, nearbyNetworks);
                  },
                  child: Text('Optimize'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelInterferenceTable(List<Map<String, dynamic>> networks) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Network',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Ch', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Signal', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Interference',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        ...networks.map((network) {
          // Calculate interference level based on channel proximity and signal strength
          final int channelDiff =
              (network['channel'] - this.network.channel).abs();
          final String interference =
              _calculateInterference(channelDiff, network['signalStrength']);

          return TableRow(
            decoration: network['isCurrentNetwork']
                ? BoxDecoration(color: Colors.blue.withOpacity(0.1))
                : null,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  network['ssid'],
                  style: network['isCurrentNetwork']
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${network['channel']}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSignalStrengthIndicator(network['signalStrength']),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(interference),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSignalStrengthIndicator(int signalStrength) {
    int bars = 1;
    if (signalStrength > -50)
      bars = 4;
    else if (signalStrength > -65)
      bars = 3;
    else if (signalStrength > -80) bars = 2;

    Color color =
        bars >= 3 ? Colors.green : (bars == 2 ? Colors.orange : Colors.red);

    return Row(
      children: [
        Text('${signalStrength} dBm'),
        SizedBox(width: 4),
        Icon(Icons.signal_wifi_4_bar, color: color, size: 16),
      ],
    );
  }

  String _calculateInterference(int channelDiff, int signalStrength) {
    if (channelDiff == 0) {
      if (signalStrength > -60)
        return 'High';
      else if (signalStrength > -75)
        return 'Medium';
      else
        return 'Low';
    } else if (channelDiff <= 3) {
      if (signalStrength > -65)
        return 'Medium';
      else
        return 'Low';
    } else {
      return 'Minimal';
    }
  }

  String _getChannelCongestionText(List<Map<String, dynamic>> networks) {
    // Count networks that might interfere (same channel or adjacent channels)
    int interfering = 0;
    for (var network in networks) {
      if (!network['isCurrentNetwork']) {
        int channelDiff = (network['channel'] - this.network.channel).abs();
        if (channelDiff <= 3) interfering++;
      }
    }

    if (interfering == 0)
      return 'minimal';
    else if (interfering == 1)
      return 'low';
    else if (interfering == 2)
      return 'moderate';
    else
      return 'high';
  }

  void _showChannelRecommendationDialog(
      BuildContext context, List<Map<String, dynamic>> networks) {
    // Calculate best channels (simplified algorithm)
    List<int> channelScores = List.generate(13, (i) => 0);

    // Score each channel based on interference from nearby networks
    for (int channel = 1; channel <= 13; channel++) {
      for (var network in networks) {
        int networkChannel = network['channel'];
        int signalStrength = network['signalStrength'];
        int channelDiff = (channel - networkChannel).abs();

        // Calculate interference score
        int interferenceScore = 0;
        if (channelDiff == 0) {
          interferenceScore = 10;
        } else if (channelDiff == 1) {
          interferenceScore = 7;
        } else if (channelDiff == 2) {
          interferenceScore = 5;
        } else if (channelDiff == 3) {
          interferenceScore = 3;
        } else if (channelDiff == 4) {
          interferenceScore = 1;
        }

        // Adjust for signal strength
        if (signalStrength > -60) {
          interferenceScore *= 2;
        } else if (signalStrength < -80) {
          interferenceScore = (interferenceScore * 0.5).round();
        }

        channelScores[channel - 1] += interferenceScore;
      }
    }

    // Find channels with lowest scores (least interference)
    List<int> bestChannels = [];
    int minScore = channelScores.reduce(math.min);
    for (int i = 0; i < channelScores.length; i++) {
      if (channelScores[i] == minScore) {
        bestChannels.add(i + 1);
      }
    }

    // Standard recommended non-overlapping channels
    List<int> standardRecommended = [1, 6, 11];

    // Filter to recommend standard channels if they're good options
    List<int> recommendedChannels =
        bestChannels.where((ch) => standardRecommended.contains(ch)).toList();

    // If no standard channels are good, use the best calculated ones
    if (recommendedChannels.isEmpty) {
      recommendedChannels =
          bestChannels.sublist(0, math.min(3, bestChannels.length));
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Channel Recommendations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your current network is on channel ${network.channel}.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Based on analysis of nearby networks, these channels would have less interference:',
            ),
            SizedBox(height: 16),
            ...recommendedChannels.map((channel) {
              return ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Channel $channel'),
                dense: true,
              );
            }).toList(),
            SizedBox(height: 8),
            Text(
              'Note: You will need to log into your router\'s admin interface to change the WiFi channel.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrafficMonitoringCard() {
    // Mock data - in a real app this would come from a provider
    final List<FlSpot> downloadData = [
      FlSpot(0, 3.4),
      FlSpot(2.6, 3.5),
      FlSpot(4.9, 5),
      FlSpot(6.8, 2.5),
      FlSpot(8, 4.5),
      FlSpot(9.5, 3),
      FlSpot(11, 4),
    ];

    final List<FlSpot> uploadData = [
      FlSpot(0, 2),
      FlSpot(2.6, 2.3),
      FlSpot(4.9, 2.8),
      FlSpot(6.8, 1.5),
      FlSpot(8, 2.9),
      FlSpot(9.5, 2.1),
      FlSpot(11, 1.8),
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Traffic Monitoring',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTrafficStat(
                    'Downloaded', '2.4 GB', Icons.download, Colors.blue),
                _buildTrafficStat(
                    'Uploaded', '0.8 GB', Icons.upload, Colors.orange),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 4,
                        getTitlesWidget: (value, meta) {
                          String text = '';
                          if (value.toInt() == 0) {
                            text = '12h ago';
                          } else if (value.toInt() == 6) {
                            text = '6h ago';
                          } else if (value.toInt() == 11) {
                            text = 'Now';
                          }

                          return Text(text);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 6,
                  lineBarsData: [
                    _createLineData(downloadData, Colors.blue),
                    _createLineData(uploadData, Colors.orange),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Download', Colors.blue),
                SizedBox(width: 20),
                _buildLegendItem('Upload', Colors.orange),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow('Current Download', '3.5 Mbps'),
            _buildInfoRow('Current Upload', '1.2 Mbps'),
            _buildInfoRow('Peak Download', '18.2 Mbps'),
            _buildInfoRow('Peak Upload', '5.8 Mbps'),
            _buildInfoRow('Today\'s Usage', '3.2 GB'),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficStat(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  LineChartBarData _createLineData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.2)),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildNetworkTopologyCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Network Topology',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 8),
            Center(
              child: Container(
                height: 320,
                width: double.infinity,
                child: CustomPaint(
                  painter: NetworkTopologyPainter(
                    devices: network.connectedDevices ?? [],
                    routerName: network.ssid,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopologyLegendItem('Router', Colors.red),
                SizedBox(width: 16),
                _buildTopologyLegendItem('Mobile Device', Colors.blue),
                SizedBox(width: 16),
                _buildTopologyLegendItem('Computer', Colors.green),
                SizedBox(width: 16),
                _buildTopologyLegendItem('IoT Device', Colors.purple),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // In a real app, this would refresh the topology
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Refreshing network topology')),
                );
              },
              icon: Icon(Icons.refresh),
              label: Text('Refresh Topology'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopologyLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildConnectedDevicesSection() {
    // This would typically come from a provider in a real app
    final connectedDevices = network.connectedDevices ?? [];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connected Devices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            connectedDevices.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('No connected devices detected'),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: connectedDevices.length,
                    itemBuilder: (context, index) {
                      final device = connectedDevices[index];
                      return ListTile(
                        leading: Icon(Icons.devices),
                        title: Text(device.name ?? 'Unknown Device'),
                        subtitle: Text(device.macAddress ?? 'Unknown MAC'),
                        trailing: Text(device.ipAddress ?? ''),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildSecurityRecommendations(SecurityLevel level) {
    List<String> recommendations = [];

    switch (level) {
      case SecurityLevel.critical:
        recommendations = [
          'Update router firmware immediately',
          'Change default passwords',
          'Enable WPA3 encryption if available',
          'Disable WPS',
          'Create a guest network for visitors',
        ];
        break;
      case SecurityLevel.vulnerable:
        recommendations = [
          'Update to WPA3 encryption if available',
          'Strengthen network password',
          'Enable MAC address filtering',
          'Consider updating router firmware',
        ];
        break;
      case SecurityLevel.acceptable:
        recommendations = [
          'Consider updating to WPA3 encryption',
          'Enable network firewall',
          'Review connected devices regularly',
        ];
        break;
      case SecurityLevel.secure:
        recommendations = [
          'Continue monitoring for new security advisories',
          'Consider automating firmware updates',
        ];
        break;
      case SecurityLevel.optimal:
        recommendations = [
          'Maintain current security posture',
          'Continue regular security audits',
        ];
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ...recommendations
            .map((rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline, size: 16),
                      SizedBox(width: 8),
                      Expanded(child: Text(rec)),
                    ],
                  ),
                ))
            .toList(),
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
        return Colors.green;
      case SecurityLevel.optimal:
        return Colors.teal;
    }
  }

  String _getSecurityLevelName(SecurityLevel level) {
    switch (level) {
      case SecurityLevel.critical:
        return 'Critical Risk';
      case SecurityLevel.vulnerable:
        return 'Vulnerable';
      case SecurityLevel.acceptable:
        return 'Acceptable';
      case SecurityLevel.secure:
        return 'Secure';
      case SecurityLevel.optimal:
        return 'Optimal Security';
    }
  }

  String _getSecurityDescription(SecurityLevel level) {
    switch (level) {
      case SecurityLevel.critical:
        return 'Serious security issues detected';
      case SecurityLevel.vulnerable:
        return 'Known vulnerabilities present';
      case SecurityLevel.acceptable:
        return 'Basic security measures in place';
      case SecurityLevel.secure:
        return 'Good security configuration';
      case SecurityLevel.optimal:
        return 'Best security practices implemented';
    }
  }

  void _showSecurityAnalysisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Security Analysis'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detailed security analysis for ${network.ssid}:'),
              SizedBox(height: 16),
              _buildSecurityAnalysisItem(
                'Encryption',
                _getEncryptionRating(network.encryption),
                _getEncryptionComment(network.encryption),
              ),
              _buildSecurityAnalysisItem(
                'Password Strength',
                network.passwordStrength ?? 'Unknown',
                _getPasswordStrengthComment(network.passwordStrength),
              ),
              _buildSecurityAnalysisItem(
                'Router Configuration',
                network.routerSecurityLevel ?? 'Unknown',
                'Based on known vulnerabilities for this router model',
              ),
              _buildSecurityAnalysisItem(
                'Open Ports',
                network.openPorts != null
                    ? '${network.openPorts!.length} open ports'
                    : 'Unknown',
                network.openPorts != null && network.openPorts!.isNotEmpty
                    ? 'Some open ports may present security risks'
                    : 'No unnecessarily open ports detected',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // This would trigger a detailed scan in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Detailed scan started')),
              );
            },
            child: Text('Run Detailed Scan'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityAnalysisItem(
      String title, String rating, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Rating: $rating'),
          Text(
            comment,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  String _getEncryptionRating(String encryption) {
    if (encryption.contains('WPA3')) {
      return 'Excellent';
    } else if (encryption.contains('WPA2')) {
      return 'Good';
    } else if (encryption.contains('WPA')) {
      return 'Fair';
    } else if (encryption.contains('WEP')) {
      return 'Poor';
    } else {
      return 'Unknown';
    }
  }

  String _getEncryptionComment(String encryption) {
    if (encryption.contains('WPA3')) {
      return 'WPA3 provides the strongest currently available encryption';
    } else if (encryption.contains('WPA2')) {
      return 'WPA2 provides good security but consider upgrading to WPA3 if available';
    } else if (encryption.contains('WPA')) {
      return 'Original WPA has known vulnerabilities, upgrade recommended';
    } else if (encryption.contains('WEP')) {
      return 'WEP is easily cracked and should be replaced immediately';
    } else if (encryption.contains('Open') || encryption.contains('None')) {
      return 'Open networks provide no security and are not recommended';
    } else {
      return 'Unable to determine encryption security';
    }
  }

  String _getPasswordStrengthComment(String? strength) {
    if (strength == null) return 'Password strength unknown';

    switch (strength.toLowerCase()) {
      case 'very strong':
        return 'Excellent password that would be extremely difficult to crack';
      case 'strong':
        return 'Good password that provides solid protection';
      case 'medium':
        return 'Acceptable password, but could be strengthened';
      case 'weak':
        return 'This password could be vulnerable to brute force attacks';
      case 'very weak':
        return 'This password is easily crackable and should be changed immediately';
      default:
        return 'Password strength assessment unavailable';
    }
  }

  void _showNetworkActionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.wifi_lock),
              title: Text('Security Scan'),
              onTap: () {
                Navigator.pop(context);
                // Would trigger security scan in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Security scan initiated')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.speed),
              title: Text('Speed Test'),
              onTap: () {
                Navigator.pop(context);
                // Would trigger speed test in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Speed test initiated')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.devices),
              title: Text('View Connected Devices'),
              onTap: () {
                Navigator.pop(context);
                // Would show detailed device list in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Loading connected devices')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Connection History'),
              onTap: () {
                Navigator.pop(context);
                // Would show connection history in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Loading connection history')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// New class for network topology visualization
class NetworkTopologyPainter extends CustomPainter {
  final List<dynamic> devices;
  final String routerName;

  NetworkTopologyPainter({
    required this.devices,
    required this.routerName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 3 : size.height / 3;

    // Draw router in the center
    _drawDevice(canvas, center, 'Router\n$routerName', Colors.red, 28);

    // If no devices, show only router
    if (devices.isEmpty) return;

    // Draw devices in a circle around the router
    double angleStep = 2 * 3.14159 / devices.length;
    for (int i = 0; i < devices.length; i++) {
      final device = devices[i];
      double angle = i * angleStep;

      // Calculate position on the circle
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      final position = Offset(x, y);

      // Determine device type and color
      String deviceType = device.deviceType ?? 'Unknown';
      Color deviceColor = _getDeviceColor(deviceType);
      String deviceLabel =
          '${device.name ?? 'Unknown'}\n${device.ipAddress ?? ''}';

      // Draw device
      _drawDevice(canvas, position, deviceLabel, deviceColor, 18);

      // Draw line connecting to router
      final paint = Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      // Draw signal strength indicator based on signal strength
      int bars = 1;
      if (device.signalStrength != null) {
        if (device.signalStrength! > -50)
          bars = 4;
        else if (device.signalStrength! > -65)
          bars = 3;
        else if (device.signalStrength! > -80) bars = 2;
      }

      _drawWifiConnection(canvas, center, position, bars, paint);
    }
  }

  void _drawDevice(Canvas canvas, Offset position, String label, Color color,
      double circleRadius) {
    // Draw circle for device
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, circleRadius, circlePaint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(position, circleRadius, borderPaint);

    // Draw label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: 100);
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy + circleRadius + 8,
      ),
    );
  }

  void _drawWifiConnection(
      Canvas canvas, Offset start, Offset end, int signalBars, Paint paint) {
    // Draw line connecting the devices
    canvas.drawLine(start, end, paint);

    // Calculate midpoint for signal indicator
    final midpoint = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2,
    );

    // Draw signal strength indicator
    final barWidth = 3.0;
    final barGap = 2.0;
    final baseHeight = 6.0;
    final startX = midpoint.dx - ((barWidth * 4) + (barGap * 3)) / 2;

    for (int i = 0; i < 4; i++) {
      final barHeight = baseHeight + (i * 3);
      final barPaint = Paint()
        ..color = i < signalBars ? Colors.green : Colors.grey.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(
          startX + (i * (barWidth + barGap)),
          midpoint.dy - barHeight / 2,
          barWidth,
          barHeight,
        ),
        barPaint,
      );
    }
  }

  Color _getDeviceColor(String deviceType) {
    deviceType = deviceType.toLowerCase();
    if (deviceType.contains('mobile') || deviceType.contains('phone')) {
      return Colors.blue;
    } else if (deviceType.contains('computer') ||
        deviceType.contains('laptop')) {
      return Colors.green;
    } else if (deviceType.contains('iot') || deviceType.contains('smart')) {
      return Colors.purple;
    } else {
      return Colors.orange;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Add a new class for WiFi channel analyzer visualization
class ChannelAnalyzerPainter extends CustomPainter {
  final List<Map<String, dynamic>> networks;
  final int currentChannel;

  ChannelAnalyzerPainter({
    required this.networks,
    required this.currentChannel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double bottom = height - 30;
    final double channelWidth = width / 14; // 13 channels + margin

    // Draw baseline
    final baselinePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, bottom),
      Offset(width, bottom),
      baselinePaint,
    );

    // Draw channel numbers
    for (int i = 1; i <= 13; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: currentChannel == i ? Colors.blue : Colors.black,
            fontWeight:
                currentChannel == i ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(i * channelWidth - textPainter.width / 2, bottom + 5),
      );

      // Draw channel marker
      if (currentChannel == i) {
        final markerPaint = Paint()
          ..color = Colors.blue
          ..strokeWidth = 2;

        canvas.drawLine(
          Offset(i * channelWidth, bottom - 5),
          Offset(i * channelWidth, bottom + 5),
          markerPaint,
        );
      }
    }

    // Draw network signal distributions
    for (final network in networks) {
      final int channel = network['channel'];
      final int signalStrength = network['signalStrength'];
      final bool isCurrentNetwork = network['isCurrentNetwork'];

      // Normalize signal strength to height (-30 dBm to -90 dBm)
      final double normalizedStrength =
          ((signalStrength + 90) / 60) * (bottom - 40);

      // Choose color based on whether this is the current network
      final color =
          isCurrentNetwork ? Colors.blue : Colors.red.withOpacity(0.7);

      // Draw signal distribution curve (bell curve around the channel)
      final curvePath = Path();
      final peakX = channel * channelWidth;
      final peakY = bottom - normalizedStrength;

      curvePath.moveTo(peakX - 3 * channelWidth, bottom);

      // Add points to form the curve
      for (double x = -3.0; x <= 3.0; x += 0.1) {
        // Bell curve formula
        final double y = math.exp(-(x * x) / 2);
        final double curveX = peakX + x * channelWidth;
        final double curveY = bottom - y * normalizedStrength;

        if (x == -3.0) {
          curvePath.moveTo(curveX, curveY);
        } else {
          curvePath.lineTo(curveX, curveY);
        }
      }

      curvePath.lineTo(peakX + 3 * channelWidth, bottom);
      curvePath.close();

      final paint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawPath(curvePath, paint);

      // Draw peak line
      final peakPaint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(peakX, bottom),
        Offset(peakX, peakY),
        peakPaint,
      );

      // Draw network name
      final textPainter = TextPainter(
        text: TextSpan(
          text: network['ssid'],
          style: TextStyle(
            color: color,
            fontSize: isCurrentNetwork ? 12 : 10,
            fontWeight: isCurrentNetwork ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          peakX - textPainter.width / 2,
          peakY - textPainter.height - 5,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
