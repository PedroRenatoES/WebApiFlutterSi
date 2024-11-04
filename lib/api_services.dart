import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://localhost:5125/api";

  Future<http.Response> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/Auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/Auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"Email": email, "Password": password}),
    );
    return response;
  }

  Future<http.Response> viewAppointments(int patientId) async {
    return await http.get(Uri.parse("$_baseUrl/Citas/ver/$patientId"));
  }

  Future<http.Response> scheduleAppointment(Map<String, dynamic> appointmentData) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/Citas/agendar"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(appointmentData),
    );
    return response;
  }

  Future<http.Response> viewMedicalHistory(int patientId) async {
    return await http.get(Uri.parse("$_baseUrl/HistorialMedico/$patientId"));
  }

  Future<http.Response> viewAvailableDoctors() async {
    return await http.get(Uri.parse("$_baseUrl/Medicos"));
  }

  Future<http.Response> viewPrescription(int prescriptionId) async {
    return await http.get(Uri.parse("$_baseUrl/Receta/$prescriptionId"));
  }
}
