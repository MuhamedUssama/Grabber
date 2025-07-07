import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_states.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

class FolderPathWidget extends StatelessWidget {
  const FolderPathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: context.select((HomeScreenViewModel vm) => vm.path != null),
          child: BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
            buildWhen:
                (previous, current) => current is SelectFolderPathSuccessState,
            builder: (context, state) {
              return Text(
                context.read<HomeScreenViewModel>().path!,
                style: textTheme.bodySmall,
                textAlign: TextAlign.start,
              );
            },
          ),
        ),

        Visibility(
          visible: context.select(
            (HomeScreenViewModel vm) => vm.quality != null,
          ),
          child: BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
            buildWhen:
                (previous, current) => current is UpdateQualityValueState,
            builder: (context, state) {
              return Text(
                'Quality selected: ${context.read<HomeScreenViewModel>().quality!}',
                style: textTheme.bodySmall,
                textAlign: TextAlign.start,
              );
            },
          ),
        ),
      ],
    );
  }
}
