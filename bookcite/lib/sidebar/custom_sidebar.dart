import 'package:bookcite/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this import

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    final canvasColor = AppColors.colorSurfaceSecondary;
    final actionColor = AppColors.colorSurfacePrimary;
    final divider =
        Divider(color: AppColors.colorBlack.withOpacity(0.3), height: 1);

    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.colorSurfaceSecondary,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: AppColors.colorButtonPrimary,
        textStyle: TextStyle(color: AppColors.colorBlack.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: AppColors.colorButtonPrimary),
        hoverTextStyle: const TextStyle(
          color: AppColors.colorBlack,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors.colorBlack,
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: AppColors.colorBlack,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            Navigator.pushNamed(context, '/homepage');
          },
        ),
        SidebarXItem(
          icon: Icons.search,
          label: 'Search',
          onTap: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
      
        //TODO: Uncomment when feature is ready
        // SidebarXItem(
        //     icon: Icons.favorite,
        //     label: 'Today\'s Pick',
        //     onTap: () {
        //       Navigator.pushNamed(context, '/todayspick');
        //     }),

        SidebarXItem(
          icon: Icons.people,
          label: 'Log Out',
          onTap: () async {
            // 1. Show popup
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Log out successfully'),
                duration: Duration(seconds: 2),
              ),
            );

            // 2. Clear access token from secure storage
            const storage = FlutterSecureStorage();
            await storage.delete(key: 'access token');
            await storage.delete(key: 'refresh token');

            // 3. Wait for the snackbar to show, then navigate and remove all previous routes
            // await Future.delayed(const Duration(seconds: 2));
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          },
        ),
      ],
    );
  }
}
