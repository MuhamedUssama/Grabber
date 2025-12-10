// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';

// class ActionButtons extends StatelessWidget {
//   final VoidCallback onDownloadPressed;

//   const ActionButtons({super.key, required this.onDownloadPressed});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<HomeScreenViewModel>();
//     // final locale = AppLocalizations.of(context)!;

//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: onDownloadPressed,
//             icon: const Icon(Icons.download_rounded),
//             label: const Text("Start Download"),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               textStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           width: double.infinity,
//           child: OutlinedButton.icon(
//             onPressed: () => cubit.pickFolderPath(),
//             icon: const Icon(Icons.folder_open_rounded),
//             label: Text(cubit.path ?? "Select Save Folder"),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
