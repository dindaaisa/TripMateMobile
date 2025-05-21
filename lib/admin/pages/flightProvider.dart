import 'package:flutter/material.dart';

class FlightProvider with ChangeNotifier {
  List<Map<String, String>> _flights = [];

  List<Map<String, String>> get flights => _flights;

  void addFlight(Map<String, String> flight) {
    _flights.add(flight);
    notifyListeners();
  }

  void updateFlight(String id, Map<String, String> updatedFlight) {
    final index = _flights.indexWhere((f) => f['id'] == id);
    if (index != -1) {
      _flights[index] = updatedFlight;
      notifyListeners();
    }
  }

  void deleteFlight(String id) {
    _flights.removeWhere((f) => f['id'] == id);
    notifyListeners();
  }

  void resetFlights() {
    _flights = [];
    notifyListeners();
  }
}
