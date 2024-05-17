import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocket_mtg/themes/localization_notifier.dart';
import 'package:pocket_mtg/themes/theme_notifier.dart';
import 'package:pocket_mtg/themes/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage>
    with AutomaticKeepAliveClientMixin {
  final List<MyTheme> themes = [
    mtgPurple,
    mtgGreen,
    mtgBlue,
    mtgRed,
    mtgWhite,
    mtgGrey,
  ];

  @override
  bool get wantKeepAlive => true;

  int selected = 0;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(IconData(59392, fontFamily: 'MTGIcons'));
      }
      return const Icon(IconData(59393, fontFamily: 'MTGIcons'));
    },
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final localeNotifier = Provider.of<LocaleNotifier>(context);

    return PageView(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.theme),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Switch(
                  thumbIcon: thumbIcon,
                  value: themeNotifier.isPhyrexian,
                  onChanged: (isCustomFont) {
                    localeNotifier.toggleLocale();
                    themeNotifier.toggleFont();
                    for (int i = 0; i < themes.length; i++) {
                      if (selected != i) {
                        themes[i].togglePhyrexian();
                      }
                    }
                  },
                ),
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: themes.length,
                    itemBuilder: (context, index) {
                      MyTheme myTheme = themes[index];
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myTheme.primaryColor,
                          foregroundColor: myTheme.textColor,
                        ),
                        onPressed: () {
                          selected = index;
                          themeNotifier.setTheme(myTheme);
                        },
                        child: themeNotifier.isPhyrexian
                            ? SvgPicture.asset(
                                'assets/p.svg',
                                width: 50,
                                height: 50,
                              )
                            : SvgPicture.asset(
                                themes[index].defaultIcon,
                                width: 50,
                                height: 50,
                              ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
