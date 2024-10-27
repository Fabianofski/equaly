import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<List<ExpenseListState>> {
  ExpenseListCubit(super.state);
}

class SelectedExpenseListCubit extends Cubit<ExpenseListState> {
  SelectedExpenseListCubit(super.state);

  void selectNewList(ExpenseListState newState) {
    emit(newState);
  }
}
