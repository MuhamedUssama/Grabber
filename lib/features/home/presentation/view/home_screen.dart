import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/theme/app_colors.dart';
import 'package:grabber/core/utils/app_services.dart';
import 'package:grabber/core/utils/snakbar_utils.dart';
import 'package:grabber/core/widgets/custom_text_field.dart';
import 'package:grabber/features/home/presentation/widgets/folder_path_widget.dart';

import '../view_model/home_screen_states.dart';
import '../view_model/home_screen_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BlocListener<HomeScreenViewModel, HomeScreenStates>(
      listener: (context, state) {
        if (state is ValidateUrlState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.warning_amber_rounded,
            state.message,
          );
        } else if (state is GetVideoInfoErrorState) {
          SnakBarUtils.showSnakbar(context, Icons.error, state.error);
        } else if (state is SelectFolderPathSuccessState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.folder,
            locale.folderSelected,
          );
        } else if (state is SelectFolderPathFailureState) {
          SnakBarUtils.showSnakbar(
            context,
            Icons.warning_amber_rounded,
            state.message ?? locale.noFolderSelected,
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 24,
            children: [
              Row(
                children: [Text(locale.appName, style: textTheme.displayLarge)],
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: locale.url,
                      controller:
                          context.read<HomeScreenViewModel>().controller,
                      suffixIcon: IconButton(
                        onPressed: () {
                          AppServices.pasteFromClipboard(
                            context: context,
                            controller:
                                context.read<HomeScreenViewModel>().controller,
                          );
                        },
                        color: AppColors.darkTextColor,
                        splashColor: AppColors.darkHeadTextColor,
                        disabledColor: AppColors.darkHeadTextColor,
                        splashRadius: 20,
                        icon: const Icon(Icons.content_paste_rounded),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeScreenViewModel>().pickFolderPath();
                    },
                    child: Text(locale.browse, style: textTheme.labelLarge),
                  ),
                ],
              ),
              const FolderPathWidget(),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeScreenViewModel>().getVideoInfo();
                    },
                    child: Text(locale.getInfo, style: textTheme.labelLarge),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
