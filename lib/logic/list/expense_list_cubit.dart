import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<List<ExpenseListState>> {
  int selectedList = 0;

  ExpenseListCubit(super.state);

  ExpenseListState getSelectedList() {
    return state[selectedList];
  }

  void selectList(String id) {
    selectedList = state.indexWhere((x) => x.id == id);
  }
}
