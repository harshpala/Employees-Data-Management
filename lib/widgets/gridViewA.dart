import 'package:flutter/material.dart';

import '../blocProvider/datePickerBloc.dart';

// ignore: must_be_immutable
class GridViewA extends StatefulWidget {
  var nextWeekday;

  var picked;

  var datePickerBloc;

  var state;

  var selectToDate;

  var isActive;

  GridViewA(
      {super.key,
      required this.nextWeekday,
      required this.picked,
      required this.datePickerBloc,
      required this.state,
      required this.selectToDate,
      required this.isActive});

  @override
  State<GridViewA> createState() => _GridViewAState();
}

class _GridViewAState extends State<GridViewA> {
  // var isActive = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
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
                    widget.isActive[0] ? Colors.white : Colors.blue,
                backgroundColor:
                    widget.isActive[0] ? Colors.blue : Colors.blue[50]),
            onPressed: () {
              //widget.isActive = [true, false, false, false];
              widget.picked = DateTime.now();
              widget.datePickerBloc.add(PickDateEvent(widget.picked,
                  widget.state.selectedFromDate, widget.state.selectedToDate));
            },
            child: const Text('Today'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor:
                    widget.isActive[1] ? Colors.white : Colors.blue,
                backgroundColor:
                    widget.isActive[1] ? Colors.blue : Colors.blue[50]),
            onPressed: () {
              // isActive = [false, true, false, false];
              widget.picked =
                  widget.nextWeekday(DateTime.now(), DateTime.monday);
              widget.datePickerBloc.add(PickDateEvent(widget.picked,
                  widget.state.selectedFromDate, widget.state.selectedToDate));
            },
            child: const Text('Next Monday'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor:
                    widget.isActive[2] ? Colors.white : Colors.blue,
                backgroundColor:
                    widget.isActive[2] ? Colors.blue : Colors.blue[50]),
            onPressed: () {
              //isActive = [false, false, true, false];
              widget.picked =
                  widget.nextWeekday(DateTime.now(), DateTime.tuesday);
              widget.datePickerBloc.add(PickDateEvent(widget.picked,
                  widget.state.selectedFromDate, widget.state.selectedToDate));
            },
            child: const Text('Next Tuesday'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor:
                    widget.isActive[3] ? Colors.white : Colors.blue,
                backgroundColor:
                    widget.isActive[3] ? Colors.blue : Colors.blue[50]),
            onPressed: () {
              //isActive = [false, false, false, true];
              widget.picked = DateTime.now().add(const Duration(days: 7));
              widget.datePickerBloc.add(PickDateEvent(widget.picked,
                  widget.state.selectedFromDate, widget.state.selectedToDate));
            },
            child: const Text('After 1 Week'),
          ),
        ),
      ],
    );
  }
}
