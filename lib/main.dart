import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocProvider/datePickerBloc.dart';
import 'database/employee_database.dart';
import 'screens/addEmployeeScreen.dart';
import 'screens/employeeListScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return BlocProvider(
        create: (context) => DatePickerBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Employee List'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> currentEmployees = [];
  List<Map<String, dynamic>> previousEmployees = [];
  Future<void> _loadEmployees() async {
    employees = await EmployeeDatabase.retrieveEmployees();
    setState(() {
      currentEmployees = employees.where((employee) {
        return DateTime.parse(employee['toDate']).year > 2101;
      }).toList();

      previousEmployees = employees.where((employee) {
        return DateTime.parse(employee['toDate']).year <= 2101;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    void _addEmployee() async {
      //await EmployeeDatabase.deleteAllEmployees();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEmployeeScreen(
                  load: _loadEmployees,
                )),
      );
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: employees.isNotEmpty
          ? EmployeeListScreen(
              currentEmployees: currentEmployees.reversed.toList(),
              previousEmployees: previousEmployees.reversed.toList(),
              loadEmployees: _loadEmployees,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/nothing.png',
                    height: size.height / 1.75,
                    width: size.width / 1.75,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: _addEmployee,
        child: const Icon(Icons.add),
      ),
    );
  }
}
