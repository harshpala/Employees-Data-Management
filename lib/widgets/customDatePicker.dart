import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocProvider/datePickerBloc.dart';
import 'package:intl/intl.dart';

import './customCalender.dart';
import 'gridViewA.dart';
import 'gridViewB.dart';

Dialog customDatePicker(BuildContext context, DateFormat formatter,
    bool selectToDate, DateTime initialDate) {
  DateTime nextWeekday(DateTime date, int weekday) {
    int daysUntilNextWeekday = 0;
    if (weekday == 1) {
      daysUntilNextWeekday = (8 - date.weekday) % 7;
    } else if (weekday == 2) {
      daysUntilNextWeekday = (9 - date.weekday) % 7;
    }
    if (daysUntilNextWeekday == 0) {
      daysUntilNextWeekday = 7;
    }

    //print(daysUntilNextWeekday);
    return date.add(Duration(days: daysUntilNextWeekday));
  }

  int i = 0;
  var isActive = [false, false, false, false, false, false];
  final datePickerBloc = BlocProvider.of<DatePickerBloc>(context);
  final size = MediaQuery.of(context).size;

  return Dialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))),
    insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
    child: BlocBuilder<DatePickerBloc, DatePickerState>(
      builder: (context, state) {
        var picked = initialDate;

        i == 0
            ? selectToDate
                ? datePickerBloc.add(PickDateEvent(
                    initialDate, state.selectedFromDate, initialDate))
                : datePickerBloc.add(PickDateEvent(
                    initialDate, initialDate, state.selectedToDate))
            : null;
        i++;

        if (DateFormat("yyyy-MM-dd").format(state.displayDate) ==
            DateFormat("yyyy-MM-dd").format(DateTime.now())) {
          isActive = [true, false, false, false, false, false];
        } else if (DateFormat("yyyy-MM-dd").format(state.displayDate) ==
            DateFormat("yyyy-MM-dd")
                .format(nextWeekday(DateTime.now(), DateTime.monday))) {
          if (DateFormat("yyyy-MM-dd").format(state.displayDate) ==
                  DateFormat("yyyy-MM-dd")
                      .format(DateTime.now().add(const Duration(days: 7))) &&
              DateFormat("yyyy-MM-dd").format(state.displayDate) ==
                  DateFormat("yyyy-MM-dd")
                      .format(nextWeekday(DateTime.now(), DateTime.tuesday))) {
            isActive = [false, true, false, true, false, false];
          } else {
            isActive = [false, true, false, false, false, false];
          }
        } else if (DateFormat("yyyy-MM-dd").format(state.displayDate) ==
            DateFormat("yyyy-MM-dd")
                .format(nextWeekday(DateTime.now(), DateTime.tuesday))) {
          if (DateFormat("yyyy-MM-dd").format(state.displayDate) ==
                  DateFormat("yyyy-MM-dd")
                      .format(DateTime.now().add(const Duration(days: 7))) &&
              DateFormat("yyyy-MM-dd").format(state.displayDate) ==
                  DateFormat("yyyy-MM-dd")
                      .format(nextWeekday(DateTime.now(), DateTime.tuesday))) {
            isActive = [false, false, true, true, false, false];
          } else {
            isActive = [false, false, true, false, false, false];
          }
        } else if (DateFormat("yyyy-MM-dd").format(state.displayDate) ==
            DateFormat("yyyy-MM-dd")
                .format(DateTime.now().add(const Duration(days: 7)))) {
          if (DateFormat("yyyy-MM-dd").format(state.displayDate) ==
                  DateFormat("yyyy-MM-dd")
                      .format(DateTime.now().add(const Duration(days: 7))) &&
              DateFormat("yyyy-MM-dd").format(state.displayDate) ==
                  DateFormat("yyyy-MM-dd")
                      .format(nextWeekday(DateTime.now(), DateTime.monday))) {
            isActive = [false, true, false, true, false, false];
          } else if (DateFormat("yyyy-MM-dd").format(state.displayDate) ==
                  DateFormat("yyyy-MM-dd")
                      .format(DateTime.now().add(const Duration(days: 7))) &&
              DateFormat("yyyy-MM-dd").format(state.displayDate) ==
                  DateFormat("yyyy-MM-dd")
                      .format(nextWeekday(DateTime.now(), DateTime.tuesday))) {
            isActive = [false, false, true, true, false, false];
          } else {
            isActive = [false, false, false, true, false, false];
          }
        } else {
          isActive = [false, false, false, false, false, false];
        }

        return SizedBox(
          height: selectToDate ? size.height / 1.58 : size.height / 1.40,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 15, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        selectToDate
                            ? GridViewB(
                                picked: picked,
                                datePickerBloc: datePickerBloc,
                                state: state,
                                selectToDate: selectToDate,
                                isActive: isActive)
                            : GridViewA(
                                nextWeekday: nextWeekday,
                                picked: picked,
                                datePickerBloc: datePickerBloc,
                                state: state,
                                selectToDate: selectToDate,
                                isActive: isActive,
                              ),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: CustomCalender(
                            isNoDate: state.displayDate.isAfter(DateTime(2101)),
                            initialDate:
                                state.displayDate.isAfter(DateTime(2101))
                                    ? state.selectedFromDate
                                    : state.displayDate,
                            firstDate: selectToDate
                                ? state.selectedFromDate
                                : DateTime(2000),
                            lastDate: DateTime(2101),
                            onDateChanged: (date) {
                              picked = date;
                              selectToDate
                                  ? datePickerBloc.add(PickDateEvent(
                                      picked,
                                      state.selectedFromDate,
                                      state.selectedToDate))
                                  : datePickerBloc.add(PickDateEvent(
                                      picked,
                                      state.selectedFromDate,
                                      state.selectedToDate));
                            },
                          ),
                        ),
                        const Divider()
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded,
                                      color: Colors.blue),
                                  SizedBox(width: size.width / 49),
                                  selectToDate
                                      ? state.displayDate
                                              .isAfter(DateTime(2101))
                                          ? const Text('No date')
                                          : Text(formatter
                                              .format(state.displayDate))
                                      : Text(
                                          formatter.format(state.displayDate)),
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        foregroundColor: Colors.blue,
                                        backgroundColor: Colors.blue[50]),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  SizedBox(width: size.width / 49),
                                  ElevatedButton(
                                    style:
                                        ElevatedButton.styleFrom(elevation: 0),
                                    onPressed: () {
                                      if (selectToDate) {
                                        datePickerBloc.add(PickDateEvent(
                                            state.displayDate,
                                            state.selectedFromDate,
                                            state.displayDate));
                                      } else {
                                        if (state.selectedToDate
                                            .isBefore(state.displayDate)) {
                                          datePickerBloc.add(PickDateEvent(
                                              state.displayDate,
                                              state.displayDate,
                                              DateTime(3000)));
                                        } else {
                                          datePickerBloc.add(PickDateEvent(
                                              state.displayDate,
                                              state.displayDate,
                                              state.selectedToDate));
                                        }
                                      }

                                      Navigator.of(context).pop();
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
              ],
            ),
          ),
        );
      },
    ),
  );
}
