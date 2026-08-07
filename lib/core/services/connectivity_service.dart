import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Reports real internet reachability, not just "connected to a network"
/// (being on Wi-Fi doesn't guarantee that Wi-Fi has internet access).
/// Combines connectivity_plus (to react instantly when a network
/// interface appears/disappears) with an actual DNS lookup (to confirm
/// the network really reaches the internet).
class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get onStatusChange => _controller.stream;

  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _started = false;

  void start() {
    if (_started) return;
    _started = true;
    _sub = Connectivity().onConnectivityChanged.listen((_) => checkNow());
  }

  Future<bool> checkNow() async {
    bool result;
    try {
      final lookup = await InternetAddress.lookup('one.one.one.one')
          .timeout(const Duration(seconds: 5));
      result = lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      result = false;
    }
    if (!_controller.isClosed) _controller.add(result);
    return result;
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
