import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class DatePickerEvent {}

class PickDateEvent extends DatePickerEvent {
  final DateTime displayDate;
  final DateTime selectedFromDate;
  final DateTime selectedToDate;

  PickDateEvent(this.displayDate, this.selectedFromDate, this.selectedToDate);
}

// State
class DatePickerState {
  final DateTime displayDate;
  final DateTime selectedFromDate;
  final DateTime selectedToDate;

  DatePickerState(this.displayDate, this.selectedFromDate, this.selectedToDate);
}

// BLoC
class DatePickerBloc extends Bloc<DatePickerEvent, DatePickerState> {
  DatePickerBloc()
      : super(DatePickerState(DateTime.now(), DateTime.now(), DateTime(3000)));

  //  super(DatePickerState(DateTime.now())) {
  //   on<DatePickerEvent>((event, emit) {});
  // }
  @override
  Stream<DatePickerState> mapEventToState(DatePickerEvent event) async* {
    if (event is PickDateEvent) {
      yield* _mapGetInputEventToState(event);
    }
  }

  Stream<DatePickerState> _mapGetInputEventToState(PickDateEvent event) async* {
    yield DatePickerState(
        event.displayDate, event.selectedFromDate, event.selectedToDate);
  }
}
