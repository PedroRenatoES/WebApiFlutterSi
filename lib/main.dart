// main.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_app_1/api_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Citas Médicas',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/appointments': (context) => const AppointmentScreen(),
        '/doctors': (context) => const DoctorsScreen(),
        '/medical_history': (context) => const MedicalHistoryScreen(),
        '/prescriptions': (context) => const PrescriptionScreen(),
      },
    );
  }
}



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _login() async {
    final response = await _apiService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}


// register_screen.dart

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _register() async {
    final response = await _apiService.register({
      "Nombre": _nameController.text,
      "Apellido": _surnameController.text,
      "FechaNacimiento": "1990-05-15", // Ejemplo de fecha
      "Genero": "Masculino",
      "Telefono": "123456789",
      "Direccion": "Calle Falsa 123",
      "Email": _emailController.text,
      "Password": _passwordController.text,
    });

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Surname', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}


// home_screen.dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/appointment');
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Schedule Appointment'),
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/doctors');
                },
                icon: const Icon(Icons.people),
                label: const Text('Available Doctors'),
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/history');
                },
                icon: const Icon(Icons.history),
                label: const Text('Medical History'),
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// appointment_screen.dart

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final response = await _apiService.viewAppointments(1); // Cambia el ID del paciente
    if (response.statusCode == 200) {
      setState(() {
        _appointments = List.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar citas')),
      );
    }
  }

  Future<void> _scheduleAppointment() async {
    // Información de la nueva cita; personaliza estos valores
    final appointmentData = {
      "fecha": "2024-11-05",
      "hora": "10:00",
      "medicoId": 1,
      "pacienteId": 1
    };
    final response = await _apiService.scheduleAppointment(appointmentData);

    if (response.statusCode == 201) {
      _loadAppointments();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cita agendada con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agendar cita')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citas')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                final appointment = _appointments[index];
                return ListTile(
                  title: Text('Fecha: ${appointment["fecha"]}'),
                  subtitle: Text('Hora: ${appointment["hora"]}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _scheduleAppointment,
            child: const Text('Agendar nueva cita'),
          ),
        ],
      ),
    );
  }
}


// doctors_screen.dart

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  _DoctorsScreenState createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _doctors = [];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    final response = await _apiService.viewAvailableDoctors();
    if (response.statusCode == 200) {
      setState(() {
        _doctors = List.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar doctores')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctores Disponibles')),
      body: ListView.builder(
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          final doctor = _doctors[index];
          return ListTile(
            title: Text('Dr. ${doctor["nombre"]} ${doctor["apellido"]}'),
            subtitle: Text('Especialidad: ${doctor["especialidad"]}'),
          );
        },
      ),
    );
  }
}


// medical_history_screen.dart

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _medicalHistory = [];

  @override
  void initState() {
    super.initState();
    _loadMedicalHistory();
  }

  Future<void> _loadMedicalHistory() async {
    final response = await _apiService.viewMedicalHistory(1); // Cambia el ID del paciente
    if (response.statusCode == 200) {
      setState(() {
        _medicalHistory = List.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar historial médico')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial Médico')),
      body: ListView.builder(
        itemCount: _medicalHistory.length,
        itemBuilder: (context, index) {
          final record = _medicalHistory[index];
          return ListTile(
            title: Text(record["descripcion"]),
            subtitle: Text('Fecha: ${record["fecha"]}'),
          );
        },
      ),
    );
  }
}



class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({Key? key}) : super(key: key);

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _prescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    final response = await _apiService.viewPrescription(1); // Cambia el ID de la receta según corresponda
    if (response.statusCode == 200) {
      setState(() {
        _prescriptions = List.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar recetas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetas Médicas')),
      body: ListView.builder(
        itemCount: _prescriptions.length,
        itemBuilder: (context, index) {
          final prescription = _prescriptions[index];
          return ListTile(
            title: Text('Medicamento: ${prescription["medicamento"]}'),
            subtitle: Text('Dosis: ${prescription["dosis"]}'),
          );
        },
      ),
    );
  }
}
