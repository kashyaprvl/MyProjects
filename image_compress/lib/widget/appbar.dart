import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utlis/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
    CustomAppBar({super.key ,this.leftIconPath,this.rightOnPressed,this.rightIconPath,this.leftOnPressed,required this.showIcon});
  String? leftIconPath ;
  String? rightIconPath ;
    VoidCallback? leftOnPressed;
   VoidCallback? rightOnPressed;
   bool showIcon = false;

  final double appBarHeight = 75.0;

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      backgroundColor: Colors.white,
      elevation: 0,
      leading: Text(""),
      leadingWidth: 15,
      centerTitle: true,
      toolbarHeight: appBarHeight,
      flexibleSpace: Container(
        height: appBarHeight,
        padding: const EdgeInsets.only(top: 12.0),
        child: Container(
          margin: EdgeInsets.only(top: 25, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (leftIconPath != null)?Padding(
                padding:   EdgeInsets.only(left: 29.w),
                child: _buildIconButton(
                  icon: leftIconPath!,
                  onPressed: leftOnPressed ?? () {},
                ),
              ):SizedBox.shrink(),

              (showIcon == true)?Image.asset(
                "assets/splashLogo.png",
                width: 50.w,
                height: 50.h,
                fit: BoxFit.contain,
              ):SizedBox.shrink(),

              (rightIconPath != null)?Padding(
                padding:   EdgeInsets.only(right: 29.w),
                child: _buildIconButton(
                  icon: rightIconPath!,
                  onPressed: rightOnPressed?? (){},
                ),
              ):SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required String icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.cardBackgroungColor,

      ),
      height: 55,
      width: 40,
      child: InkWell(
        onTap: onPressed,
        child: SvgPicture.asset(
         icon,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _onIconButtonPressed(BuildContext context, String action) {
    // Handle the button press based on the action (Camera/Download)
    // You can navigate to different screens or perform any other action.
    // Example:
    if (action == "Camera") {
      // Handle Camera button press
    } else if (action == "Download") {
      // Handle Download button press
    }
  }



}
