import 'package:civitante/App/utilse/widgets.dart'; // Make sure the file path is correct.

void main() {
  runApp(CivitanteApp());
}

class CivitanteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialRoute:
          AppRoutes.bottomNav, // Ensure AppRoutes.splash is defined correctly.
      initialBinding:
          InitialBinding(), // Ensure InitialBinding() is correctly set up.
      defaultTransition:
          Transition.fadeIn, // Optional: for smoother page transitions.
    );
  }
}
