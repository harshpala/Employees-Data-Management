import 'package:flutter/material.dart';

import '../blocProvider/datePickerBloc.dart';

class GridViewB extends StatelessWidget {
  var picked;

  var datePickerBloc;

  var state;

  var selectToDate;

  var isActive;

  GridViewB({
    super.key,
    required this.picked,
    required this.datePickerBloc,
    required this.state,
    required this.selectToDate,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    return GridView.count(
      childAspectRatio: 3,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor:
                    state.displayDate.isAtSameMomentAs(DateTime(3000))
                        ? Colors.white
                        : Colors.blue,
                backgroundColor:
                    state.displayDate.isAtSameMomentAs(DateTime(3000))
                        ? Colors.blue
                        : Colors.blue[50]),
            onPressed: () {
              picked = DateTime(3000);
              datePickerBloc.add(PickDateEvent(
                  picked, state.selectedFromDate, state.selectedToDate));
            },
            child: const Text('No date'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: state.selectedFromDate.isBefore(DateTime.now())
                    ? isActive[0]
                        ? Colors.white
                        : Colors.blue
                    : Colors.white,
                backgroundColor: state.selectedFromDate.isBefore(DateTime.now())
                    ? isActive[0]
                        ? Colors.blue
                        : Colors.blue[50]
                    : Colors.grey[400]),
            onPressed: () {
              picked = DateTime.now();
              if (state.selectedFromDate.isBefore(picked)) {
                datePickerBloc.add(PickDateEvent(
                    picked, state.selectedFromDate, state.selectedToDate));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Final Date cannot be before Initial Date'),
                  duration: Duration(milliseconds: 1000),
                ));
              }
            },
            child: const Text('Today'),
          ),
        ),
      ],
    );
  }
}
