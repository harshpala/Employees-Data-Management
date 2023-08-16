import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/employee_database.dart';
import 'addEmployeeScreen.dart';

class EmployeeListScreen extends StatefulWidget {
  var currentEmployees;
  var previousEmployees;
  var loadEmployees;
  EmployeeListScreen({
    super.key,
    required this.currentEmployees,
    required this.previousEmployees,
    required this.loadEmployees,
  });

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late Map<String, dynamic> deletedCurrentEmployees;
  late Map<String, dynamic> deletedPreviousEmployees;
  final DateFormat formatter = DateFormat('d MMM yyyy');

  Future<void> _deleteCurrentEmployee(int id, int index) async {
    deletedCurrentEmployees = widget.currentEmployees[index];
    await EmployeeDatabase.deleteEmployee(id);

    widget.loadEmployees();
  }

  Future<void> _deletePreviousEmployee(int id, int index) async {
    deletedPreviousEmployees = widget.previousEmployees[index];
    await EmployeeDatabase.deleteEmployee(id);

    widget.loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final listItemHeight = size.height / 8.436; // Height of each ListTile
    final maxTotalHeight = size.height / 2.812; // Desired total height
    double calculateHeight(int setat) {
      var set = [
        [widget.currentEmployees.length, widget.previousEmployees.length],
        [widget.previousEmployees.length, widget.currentEmployees.length]
      ];
      var desiredset = set[setat];
      double desiredHeight = maxTotalHeight;
      //print(size.height);
      //= (listItemHeight * 6) - itemCount * listItemHeight;
      if (desiredset[0] == 0) {
        desiredHeight = size.height / 69.09;
      } else if ((desiredset[0] + desiredset[1]) * listItemHeight <
          maxTotalHeight) {
        desiredHeight = desiredset[0] * listItemHeight;
        //print(1);
      } else if (desiredset[0] * listItemHeight >= maxTotalHeight &&
          desiredset[1] * listItemHeight >= maxTotalHeight) {
        //print(2);
        desiredHeight = maxTotalHeight;
      } else if (desiredset[0] * listItemHeight > maxTotalHeight &&
          desiredset[1] * listItemHeight == (listItemHeight * 5)) {
        //print(3);
        desiredHeight = listItemHeight * 1;
      } else if (desiredset[0] * listItemHeight > maxTotalHeight &&
          desiredset[1] * listItemHeight == (listItemHeight * 4)) {
        // print(4);
        desiredHeight = listItemHeight * 2;
      } else if (desiredset[0] * listItemHeight > maxTotalHeight &&
          desiredset[1] * listItemHeight == (listItemHeight * 3)) {
        // print(5);
        desiredHeight = listItemHeight * 3;
      } else if (desiredset[0] * listItemHeight > maxTotalHeight &&
          desiredset[1] * listItemHeight == (listItemHeight * 2)) {
        // print(6);
        desiredHeight = listItemHeight * 4;
      } else {
        // print(8);
        desiredHeight = desiredset[0] * listItemHeight;
      }

      return desiredHeight - (size.height / 69.09);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.currentEmployees.isEmpty
                ? const Text(
                    'No Current employees',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.blue),
                  )
                : const Text(
                    'Current employees',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.blue),
                  ),
          ),
          Container(
            height: calculateHeight(0),
            // height: (widget.currentEmployees.length * size.height / 8.44) >
            //         size.height / 2.88
            //     ? size.height / 2.88
            //     : calculateHeight(widget.previousEmployees.length) <
            //             (widget.currentEmployees.length * size.height / 8.44)
            //         ? calculateHeight(widget.previousEmployees.length)
            //         : (widget.currentEmployees.length * size.height / 8.44),
            // height: widget.currentEmployees.length * size.height / 8.44 <
            //         size.height / 2.81
            //     ? widget.currentEmployees.length * size.height / 8.44
            //     : size.height / 2.81,
            color: Colors.white,
            child: ListView.separated(
              itemCount: widget.currentEmployees.length,
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _deleteCurrentEmployee(
                          widget.currentEmployees[index]['id'], index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Employee data has been deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          EmployeeDatabase.insertEmployee(
                              deletedCurrentEmployees);

                          widget.loadEmployees();
                        },
                      ),
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  child: ListTile(
                    title: Text(
                      widget.currentEmployees[index]['employeeName'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height / 108.46,
                        ),
                        Text(
                          widget.currentEmployees[index]['role'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        SizedBox(
                          height: size.height / 108.46,
                        ),
                        Text(
                            'From ${formatter.format(DateTime.parse(widget.currentEmployees[index]['fromDate'])).toString()}',
                            style: const TextStyle(fontSize: 12))
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEmployeeScreen(
                                  load: widget.loadEmployees,
                                  empId: widget.currentEmployees[index]['id'],
                                  name: widget.currentEmployees[index]
                                      ['employeeName'],
                                  role: widget.currentEmployees[index]['role'],
                                  initialDate: widget.currentEmployees[index]
                                      ['fromDate'],
                                  finalDate: widget.currentEmployees[index]
                                      ['toDate'],
                                )),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.previousEmployees.isEmpty
                ? const Text(
                    'No Previous employees',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.blue),
                  )
                : const Text(
                    'Previous employees',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.blue),
                  ),
          ),
          Container(
            height: calculateHeight(1),
            // height: (widget.previousEmployees.length * size.height / 8.44) >
            //         size.height / 2.88
            //     ? size.height / 2.88
            //     : calculateHeight(widget.currentEmployees.length) <
            //             (widget.previousEmployees.length * size.height / 8.44)
            //         ? calculateHeight(widget.currentEmployees.length)
            //         : (widget.previousEmployees.length * size.height / 8.44),
            // height: widget.previousEmployees.length * size.height / 8.44 <
            //         size.height / 2.81
            //     ? widget.previousEmployees.length * size.height / 8.44
            //     : size.height / 2.81,
            color: Colors.white,
            child: ListView.separated(
              itemCount: widget.previousEmployees.length,
              separatorBuilder: (context, index) => const Divider(
                height: 0,
              ),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _deletePreviousEmployee(
                          widget.previousEmployees[index]['id'], index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Employee data has been deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          EmployeeDatabase.insertEmployee(
                              deletedPreviousEmployees);
                          widget.loadEmployees();
                        },
                      ),
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  child: ListTile(
                    title: Text(
                      widget.previousEmployees[index]['employeeName'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height / 108.46,
                        ),
                        Text(
                          widget.previousEmployees[index]['role'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        SizedBox(
                          height: size.height / 108.46,
                        ),
                        Text(
                            '${formatter.format(DateTime.parse(widget.previousEmployees[index]['fromDate'])).toString()} - ${formatter.format(DateTime.parse(widget.previousEmployees[index]['toDate'])).toString()}',
                            style: const TextStyle(fontSize: 12))
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEmployeeScreen(
                                  load: widget.loadEmployees,
                                  empId: widget.previousEmployees[index]['id'],
                                  name: widget.previousEmployees[index]
                                      ['employeeName'],
                                  role: widget.previousEmployees[index]['role'],
                                  initialDate: widget.previousEmployees[index]
                                      ['fromDate'],
                                  finalDate: widget.previousEmployees[index]
                                      ['toDate'],
                                )),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding:
                EdgeInsets.only(top: 10, bottom: 16.0, left: 16, right: 15),
            child: Text(
              'Swipe left to delete',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
