import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityMonitorWidget extends StatefulWidget {
  final VoidCallback? onConnectionLost;
  final VoidCallback? onConnectionRestored;
  final Widget child;

  const ConnectivityMonitorWidget({
    Key? key,
    required this.child,
    this.onConnectionLost,
    this.onConnectionRestored,
  }) : super(key: key);

  @override
  State<ConnectivityMonitorWidget> createState() => _ConnectivityMonitorWidgetState();
}


class _ConnectivityMonitorWidgetState extends State<ConnectivityMonitorWidget> {
  final Connectivity _connectivity = Connectivity();
  late ConnectivityResult _connectionStatus;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      ConnectivityResult result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      _updateConnectionStatus(ConnectivityResult.none);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final bool isNowConnected = result != ConnectivityResult.none;

    if (!isNowConnected) {
      // 👇 Trigger the external callback if provided
      widget.onConnectionLost?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection')),
      );
    }

    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Optionally replace this with SizedBox.shrink() if you don't want to show text
    return Text('Connection status: $_connectionStatus');
  }
}
