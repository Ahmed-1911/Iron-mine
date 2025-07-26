import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_mine/core/helpers/routes.dart';
import 'package:iron_mine/core/utils/enums.dart';
import 'package:iron_mine/presentation/screens/admin_users/extraction_admin_screen.dart';
import 'package:iron_mine/presentation/screens/quality_users/quality_extraction_ticket_screen.dart';
import 'package:iron_mine/presentation/screens/quality_users/quality_storage_ticket_screen.dart';
import 'package:iron_mine/presentation/viewModel/locale/localization_provider.dart';

import '../../core/singleton/settings_session.dart';
import '../../core/utils/token_util.dart';
import 'admin_users/crusher_admins_ticket_screen.dart';
import 'admin_users/storage_admins_ticket_screen.dart';
import 'authorization/login/login_screen.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends ConsumerState<Splash> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
          final locProvider = ref.read(localProvider.notifier);
          await locProvider.fetchLocale();
          SettingsSession.instance().loadLanguage();
        });

        Future.delayed(
          const Duration(seconds: 2),
          () async {
            final token = TokenUtil.getTokenFromMemory();
            final role = TokenUtil.getRoleFromMemory();

            CustomNavigator.cleanAndPush(
              // ignore: use_build_context_synchronously
              context: context,
              widget: token.isEmpty
                  ? LogInScreen()
                  : role == RolesEnum.crusherAdmin
                      ? CrusherTicketScreen()
                      : role == RolesEnum.storageAdmin
                          ? StorageTicketScreen()
                          : role == RolesEnum.storageQuality
                              ? QualityStorageTicketScreen()
                              : role == RolesEnum.extractionQuality
                                  ? QualityExtractionTicketScreen()
                                  : ExtractionZoneListScreen(),
            );
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/images/splash.jpg',
            width: 1.sw,
            height: 1.sh,
            fit: BoxFit.fill,
          )
              // .animate()
              // .fade(
              //   duration: Duration(seconds: 1),
              // ) // uses `Animate.defaultDuration`
              // .scale(),
        ),
      ),
    );
  }
}
