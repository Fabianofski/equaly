import 'package:equaly/logic/auth/auth_cubit.dart';
import 'package:equaly/logic/currency_mapper.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InvitationModal extends StatelessWidget {
  final String listId;
  final String inviteCode;
  const InvitationModal(
      {super.key, required this.listId, required this.inviteCode});

  Future<void> joinExpenseList(BuildContext context) async {
    var expenseListCubit = BlocProvider.of<ExpenseListCubit>(context);
    await expenseListCubit.joinExpenseListWithInviteCode(listId, inviteCode);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<AuthCubit, GoogleSignInAccount?>(
        builder: (context, account) {
      var expenseListCubit = BlocProvider.of<ExpenseListCubit>(context);
      return FutureBuilder(
        future:
            expenseListCubit.fetchExpenseListWithInviteCode(listId, inviteCode),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError || snapshot.data == null) {
                return Text("Error");
              }

              final list = snapshot.data;
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text(
                    "Liste beitreten",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 256,
                            width: 256,
                            decoration: BoxDecoration(
                              color: Color(list!.expenseList.color),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                list.expenseList.emoji,
                                style: const TextStyle(fontSize: 86),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              list.expenseList.title,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: -.5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                                "${CurrencyMapper.getSymbol(list.expenseList.currency)}${list.expenseList.totalCost.toStringAsFixed(2)}"),
                          ),
                          const SizedBox(
                            height: 64.0,
                          ),
                          FilledButton(
                              onPressed: () => joinExpenseList(context),
                              child: Text("Beitreten"))
                        ],
                      )
                    ],
                  ),
                ),
              );
            default:
              return Text("Loading");
          }
        },
      );
    });
  }
}
