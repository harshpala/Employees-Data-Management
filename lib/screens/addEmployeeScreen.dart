import 'package:employees/widgets/customDatePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocProvider/datePickerBloc.dart';
import '../database/employee_database.dart';

class AddEmployeeScreen extends StatefulWidget {
  final VoidCallback load;
  final empId;
  final name;
  final role;
  final initialDate;
  final finalDate;
  const AddEmployeeScreen(
      {super.key,
      required this.load,
      this.empId,
      this.name,
      this.role,
      this.initialDate,
      this.finalDate});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.empId != null) {
      name = widget.name;
      selectedRole = widget.role;
      fromDate = DateTime.parse(widget.initialDate);
      toDate = DateTime.parse(widget.finalDate);
      BlocProvider.of<DatePickerBloc>(context)
          .add(PickDateEvent(fromDate!, fromDate!, toDate!));
    }
  }

  String name = '';
  String? selectedRole;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('d MMM yyyy');
  final _formKey = GlobalKey<FormState>();

  final List<String> roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];

  void _saveData(
      String name, String role, String fromDate, String toDate) async {
    Map<String, dynamic> employeeData = {
      'employeeName': name,
      'role': role,
      'fromDate': fromDate,
      'toDate': toDate,
    };

    if (widget.empId != null) {
      await EmployeeDatabase.updateEmployee(widget.empId, employeeData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Employee data updated successfully!'),
        duration: Duration(seconds: 1),
      ));
    } else {
      await EmployeeDatabase.insertEmployee(employeeData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Employee data saved successfully!'),
        duration: Duration(seconds: 1),
      ));
    }
  }

  void _showRolePicker(Size size) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.00)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: roles.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: size.height / 16.88,
                      child: ListTile(
                        title: Center(child: Text(roles[index])),
                        onTap: () {
                          setState(() {
                            selectedRole = roles[index];
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    if (index < roles.length - 1)
                      const Divider(height: 1.0, color: Colors.grey),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _openCustomDatePicker(
      BuildContext context, bool selectToDate, DateTime initialDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return customDatePicker(context, formatter, selectToDate, initialDate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Employee Details'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    initialValue: name,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => name = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an Employee name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Employee Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.blue,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 1),
                    ),
                  ),
                  SizedBox(height: size.height / 48),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus!.unfocus();

                      _showRolePicker(size);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        keyboardType: TextInputType.none,
                        //initialValue: selectedRole,
                        decoration: InputDecoration(
                          hintText: "Select Role",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          prefixIcon: const Icon(
                            Icons.work_outline_rounded,
                            color: Colors.blue,
                          ),
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Colors.blue,
                            size: 35,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 1),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select a Role';
                          }
                          return null;
                        },
                        controller: TextEditingController(text: selectedRole),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 48),
                  BlocBuilder<DatePickerBloc, DatePickerState>(
                      builder: (context, state) {
                    fromDate = state.selectedFromDate;
                    toDate = state.selectedToDate;
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();

                              _openCustomDatePicker(
                                  context, false, state.selectedFromDate);
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                height: size.height / 17.25,
                                child: TextFormField(
                                  keyboardType: TextInputType.none,
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.blue,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 1.0),
                                  ),
                                  controller: TextEditingController(
                                      text: (state.selectedFromDate.isToday()
                                          ? 'Today'
                                          : formatter
                                              .format(state.selectedFromDate))),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: size.width /
                                49), // Add spacing between date fields
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.blue,
                        ), // Small arrow pointing towards the "date (to)" field
                        SizedBox(
                            width: size.width /
                                49), // Add spacing between date fields
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();

                              _openCustomDatePicker(
                                  context, true, state.selectedToDate);
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                height: size.height / 17.25,
                                child: TextFormField(
                                  keyboardType: TextInputType.none,
                                  style: TextStyle(
                                      fontSize: 15.5,
                                      color: state.selectedToDate
                                                  .isAfter(DateTime(2101)) ||
                                              state.selectedToDate.isBefore(
                                                  state.selectedFromDate
                                                      .subtract(const Duration(
                                                          days: 1)))
                                          ? Colors.black54
                                          : null),
                                  decoration: InputDecoration(
                                    hintText: 'No Date',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.blue,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 1),
                                  ),
                                  controller: TextEditingController(
                                      text: state.selectedToDate
                                                  .isAfter(DateTime(2101)) ||
                                              state.selectedToDate.isBefore(
                                                  state.selectedFromDate
                                                      .subtract(const Duration(
                                                          days: 1)))
                                          ? ('No date')
                                          : (state.selectedToDate.isToday()
                                              ? 'Today'
                                              : formatter.format(
                                                  state.selectedToDate))),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ]),
              ),
            ),
            Column(
              children: [
                Container(
                  height: 1,
                  width: size.width,
                  color: Colors.grey[350],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, bottom: 10, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: Colors.blue,
                                backgroundColor: Colors.blue[50]),
                            onPressed: () {
                              BlocProvider.of<DatePickerBloc>(context).add(
                                  PickDateEvent(DateTime.now(), DateTime.now(),
                                      DateTime(3000)));

                              Navigator.pop(
                                context,
                              );
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(elevation: 0),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveData(name, selectedRole!,
                                    fromDate.toString(), toDate.toString());
                                widget.load();
                                BlocProvider.of<DatePickerBloc>(context).add(
                                    PickDateEvent(DateTime.now(),
                                        DateTime.now(), DateTime(3000)));
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }
}
