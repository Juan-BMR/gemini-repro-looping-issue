import '../entities/network.dart';

abstract class NetworkRepository {
  Future<List<Network>> getNetworks();
  Future<Network> analyzeNetworkSecurity(Network network);
}
