import 'package:equaly/logic/app_bar/app_bar_cubit.dart';
import 'package:equaly/logic/auth/auth_cubit.dart';
import 'package:equaly/logic/currency_mapper.dart';
import 'package:equaly/presentation/pages/profile.dart';
import 'package:equaly/presentation/wireframe/bottom_nav.dart';
import 'package:equaly/presentation/wireframe/app_bar.dart';
import 'package:equaly/logic/list/expense_list_cubit.dart';
import 'package:equaly/logic/navigation/constants/nav_bar_items.dart';
import 'package:equaly/logic/navigation/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/utils/snack_bar.dart';
import 'presentation/pages/home.dart';
import 'presentation/pages/list.dart';
import 'presentation/pages/settings.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color(0xFFE3EBF4),
      systemNavigationBarColor: Color(0xFFE3EBF4),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await CurrencyMapper.initialize();

  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBarCubit>(create: (context) => AppBarCubit()),
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<ExpenseListCubit>(create: (context) => ExpenseListCubit(context.read<AuthCubit>())),
        BlocProvider<SelectedExpenseListCubit>(
            create: (context) => SelectedExpenseListCubit(null))
      ],
      child: MaterialApp(
        title: 'Equaly',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Open Sans',
          appBarTheme: const AppBarTheme(
            color: Color(0xFFEEF4FC),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Color(0xFFE3EBF4),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Color(0xFFEEF4FC),
          ),
          primaryColor: Color(0xFF15376A),
          textTheme: TextTheme(
              titleMedium: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              titleSmall: TextStyle(
                fontWeight: FontWeight.w900,
              ),
              bodySmall: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                  color: Color(0x88060F1E)),
              labelLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              labelMedium: TextStyle(
                fontSize: 16,
              ),
              labelSmall: TextStyle(
                fontSize: 14,
              )).apply(
            displayColor: Color(0xFF060F1E),
            bodyColor: Color(0xFF060F1E),
          ),
          filledButtonTheme: FilledButtonThemeData(
              style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  backgroundColor: WidgetStatePropertyAll(Color(0xFF15376A)))),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Color(0xFFE9F0F7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            dayStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFFE9F0F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Color(0xFF15376A),
                  width: 1.5,
                ),
              ),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              labelStyle: TextStyle(
                fontSize: 16,
              )),
          scaffoldBackgroundColor: const Color(0xFFEEF4FC),
          canvasColor: Color(0xFFE3EBF4),
          useMaterial3: true,
        ),
        home: const AppContainer(),
      ),
    );
  }
}

class AppContainer extends StatelessWidget {
  const AppContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Map<NavbarItem, Widget> body = {
      NavbarItem.home: HomePage(),
      NavbarItem.list: ListPage(),
      NavbarItem.settings: SettingsPage(),
      NavbarItem.profile: ProfilePage()
    };

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: CustomAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
          return body[state.navbarItem] ?? Text("404");
        }),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
