import 'package:bab_algharb/components/shared_value_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:bab_algharb/components/menu_row.dart';
import 'package:bab_algharb/models/menu_item.dart';
import 'package:bab_algharb/theme.dart';
import 'package:bab_algharb/assets.dart' as app_assets;

class SideMenu extends StatefulWidget {
  const SideMenu();

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<MenuItemModel> _browseMenuIcons = MenuItemModel.menuItems;
  final List<MenuItemModel> _themeMenuIcon = MenuItemModel.menuItems3;
  final List<MenuItemModel> _fillesMenuIcon = MenuItemModel.menuItems4;
  String _selectedMenu = MenuItemModel.menuItems[0].title;
  bool _isDarkMode = false;

  void onThemeRiveIconInit(artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, _themeMenuIcon[0].riveIcon.stateMachine);
    artboard.addController(controller);
    _themeMenuIcon[0].riveIcon.status =
    controller.findInput<bool>("active") as SMIBool;
  }

  void onMenuPress(MenuItemModel menu) {
    setState(() {
      _selectedMenu = menu.title;
    });
  }

  void onThemeToggle(value) {
    setState(() {
      _isDarkMode = value;
    });
    _themeMenuIcon[0].riveIcon.status.change(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom - 60),
      constraints: const BoxConstraints(maxWidth: 288),
      decoration: BoxDecoration(
        color: AppTheme.background2,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.person_outline),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 180,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                       user_name.$,
                        maxLines: 1,
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        username.$ == null ? '' : username.$,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 15,),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MenuButtonSection(
                      title: "التواصل",
                      selectedMenu: _selectedMenu,
                      menuIcons: _browseMenuIcons,
                      onMenuPress: onMenuPress),
                  // MenuButtonSection(
                  //     title: "التسلية",
                  //     selectedMenu: _selectedMenu,
                  //     menuIcons: _historyMenuIcons,
                  //     onMenuPress: onMenuPress),
                  MenuButtonSection(
                      title: "النقاط",
                      selectedMenu: _selectedMenu,
                      menuIcons: _fillesMenuIcon,
                      onMenuPress: onMenuPress),
                ],
              ),
            ),
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(children: [
              // SizedBox(
              //   width: 32,
              //   height: 32,
              //   child: Opacity(
              //     opacity: 0.6,
              //     child: RiveAnimation.asset(
              //       app_assets.iconsRiv,
              //       stateMachines: [_themeMenuIcon[0].riveIcon.stateMachine],
              //       artboard: _themeMenuIcon[0].riveIcon.artboard,
              //       onInit: onThemeRiveIconInit,
              //     ),
              //   ),
              // ),
              const SizedBox(width: 14),
              // Expanded(
              //   child: Text(
              //     _themeMenuIcon[0].title,
              //     style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 17,
              //         fontWeight: FontWeight.w600),
              //   ),
              // ),
            //  CupertinoSwitch(value: _isDarkMode, onChanged: onThemeToggle),
            ]),
          )
        ],
      ),
    );
  }
}

class MenuButtonSection extends StatelessWidget {
  const MenuButtonSection(
      {
         this.title,
         this.menuIcons,
        this.selectedMenu = "Home",
        this.onMenuPress});

  final String title;
  final String selectedMenu;
  final List<MenuItemModel> menuIcons;
  final Function(MenuItemModel menu) onMenuPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var menu in menuIcons) ...[
                Divider(
                    color: Colors.white.withOpacity(0.1),
                    thickness: 1,
                    height: 1,
                    indent: 16,
                    endIndent: 16),
                MenuRow(
                  menu: menu,
                  selectedMenu: selectedMenu,
                  onMenuPress: () => onMenuPress(menu),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}