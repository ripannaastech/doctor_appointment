// import 'dart:convert';
// import 'package:signalr_core/signalr_core.dart';
//
// import '../shared_preferance/shared_preferance.dart';
//
// class SignalRService {
//   HubConnection? _connection;
//
//   // Callback to notify the controller
//   void Function(Map<String, dynamic> data)? onRideRequestReceived;
//
//   bool get isConnected => _connection?.state == HubConnectionState.connected;
//   final _prefs = SharedPrefs();
//   Future<void> init() async {
//     if (isConnected) return;
//     final userData = await _prefs.getUser();
//     final driverId = userData?['typeSpecificId'] ?? userData?['id'];
//
//     print("testDbID$driverId");
//
//     _connection = HubConnectionBuilder()
//         .withUrl(
//       'http://74.208.201.247:443/api/v1/rideHub?userId=$driverId&userType=driver',
//     )
//         .withAutomaticReconnect()
//         .build();
//
//    // print('Message from server: $_connection');
//
//     _connection!.on('RideRequestReceived', (args) {
//       print('Message from server: $args');
//
//       _connection!.onreconnecting((error) {
//         print('SignalR reconnecting 🔄: $error');
//       });
//
//       _connection!.onreconnected((connectionId) {
//         print('SignalR reconnected ✅: $connectionId');
//       });
//
//       // Parse args if needed
//       Map<String, dynamic> data;
//       if (args != null && args.isNotEmpty) {
//         // args[0] usually contains the actual data
//
//
//         if (args[0] is Map) {
//           data = Map<String, dynamic>.from(args[0]);
//         } else if (args[0] is String) {
//           data = Map<String, dynamic>.from(
//               jsonDecode(args[0] as String));
//         } else {
//           data = {};
//         }
//
//         onRideRequestReceived?.call(data);
//       //   if (rideRequest.TargetDriverId && rideRequest.TargetDriverId !== this.driverId) {
//       //     this.addLog(⚠️ Request for different driver (${rideRequest.TargetDriverId}), ignoring, 'warning');
//       // return; // Driver 1031 will ignore this message
//       // }
//         // Trigger the callback
//
//       }
//     });
//
//     await _connection!.start();
//     print('SignalR Connected');
//   }
//
//   Future<void> stop() async {
//     if (_connection == null) return;
//
//     await _connection!.stop();
//     _connection = null;
//     print('SignalR Disconnected');
//   }
// }
