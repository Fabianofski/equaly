import 'package:equaly/presentation/wireframe/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/app_bar/app_bar_cubit.dart';

class NewListPage extends StatelessWidget {
  const NewListPage({super.key});

  Color generateColor(double hue, double saturation, double brightness) {
    return HSVColor.fromAHSV(1.0, hue, saturation, brightness).toColor();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AppBarCubit>(context).setTitle('Neue Liste');
    var theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: CustomAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Listentitel',
                    hintText: "Titel",
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: 'EUR',
                  items: [
                    DropdownMenuItem(
                        value: 'EUR',
                        child: Row(
                          children: [
                            Text(
                              '€',
                              style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'EUR',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        )),
                    DropdownMenuItem(
                        value: 'USD',
                        child: Row(
                          children: [
                            Text(
                              '\$',
                              style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'USD',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        )),
                  ],
                  onChanged: (value) {},
                  decoration: InputDecoration(labelText: 'Hauptwährung'),
                ),
                SizedBox(height: 16),
                Text('Cover Farbe'),
                Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 8,
                  runSpacing: 6,
                  children: List.generate(20, (index) {
                    final hue = (index * 18) % 360;
                    final saturation = 0.44;
                    final brightness = 0.87;

                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: generateColor(
                            hue.toDouble(), saturation, brightness),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16),
                Text('Teilnehmer'),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Wilhelm'),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Tanisha'),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Margot'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Teilnehmer hinzufügen'),
                ),
              ],
            ),
            SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => {},
                  style: theme.filledButtonTheme.style,
                  child: Text(
                    "Erstellen",
                    style: theme.textTheme.labelLarge,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
