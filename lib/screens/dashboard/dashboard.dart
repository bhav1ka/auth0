import 'package:flutter/material.dart';
import 'package:mpsc_demo/datamodels/user_profile.dart';
import 'package:mpsc_demo/globalvariables/constants.dart';
import 'package:mpsc_demo/screens/dashboard/create_conference.dart';
import 'package:mpsc_demo/screens/dashboard/side_navigation.dart';
import 'package:mpsc_demo/screens/joinconference/join_conference.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:mpsc_demo/services/api_helper.dart';
import 'package:mpsc_demo/utils/app_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:mpsc_demo/globalvariables/list.dart';
import '../../services/show_snackbar.dart';
import 'package:popup_menu/popup_menu.dart';

class DashBoard extends StatefulWidget {
  static String id = 'profile';

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchRecent = TextEditingController();
  TextEditingController searchInvited = TextEditingController();
  List<SizedBox> lastJoinedList = [];
  List<GestureDetector> invitedList = [];
  List<GestureDetector> favoriteList = [];
  Widget buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CreateConference()));
  }

  void showPopup(Offset offset, int index, bool isRemove,
      {String fromList = ''}) {
    void onclickRemove(MenuItemProvider item) async {
      print('Click menu -> ${item.menuTitle}');
      if (item.menuTitle == 'Remove') {
        print('Inside if');
        await unsetConference(context, '1234', index);
      }
    }

    void onclickAdd(MenuItemProvider item) async {
      print('Click menu -> ${item.menuTitle}');
      if (fromList == 'invited')
        await setConference(context, '1234', index, 'invited');
      else
        await setConference(context, '1234', index, 'lastjoined');
    }

    void onDismiss() {
      print('Menu is dismiss');
    }

    void stateChanged(bool isShow) {
      print('menu is ${isShow ? 'showing' : 'closed'}');
    }

    PopupMenu menu = PopupMenu(
        backgroundColor: kprimaryColor,
        lineColor: Colors.white,
        highlightColor: Colors.white,
        maxColumn: 2,
        items: [
          MenuItem(
              userInfo: index,
              textStyle: TextStyle(color: Colors.white),
              title: 'Open',
              image: Icon(Icons.open_in_browser, color: Colors.white)),
          isRemove
              ? MenuItem(
                  userInfo: index,
                  textStyle: TextStyle(color: Colors.white),
                  title: 'Remove',
                  image: Icon(
                    Icons.favorite_outline_outlined,
                    color: Colors.red,
                  ))
              : MenuItem(
                  userInfo: index,
                  textStyle: TextStyle(color: Colors.white),
                  title: 'Add',
                  image: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )),
        ],
        onClickMenu: isRemove ? onclickRemove : onclickAdd,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(rect: Rect.fromPoints(offset, offset));
  }

  List<GestureDetector> fetchFavorites() {
    favoriteList = [];
    for (var i in kfavouriteNames) {
      favoriteList.add(GestureDetector(
        onTapUp: (TapUpDetails details) {
          setState(() {
            print('Tapping fetch favourites');
            showPopup(details.globalPosition, kfavouriteNames.indexOf(i), true);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 60,
            child: Card(
              borderOnForeground: true,
              child: Center(
                child: Text(
                  i,
                  overflow: TextOverflow.ellipsis,
                  style: kPrimaryTextStyle,
                ),
              ),
              color: const Color(0XFFF6F6EB),
            ),
          ),
        ),
      ));
    }
    print('Favourite List Length: ${favoriteList.length}');
    return favoriteList;
  }

  List<SizedBox> fetchLastJoined() {
    lastJoinedList = [];
    for (var i in kconferenceNames) {
      lastJoinedList.add(SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 30,
        child: GestureDetector(
          onTapUp: (TapUpDetails details) {
            showPopup(
                details.globalPosition, kconferenceNames.indexOf(i), false,
                fromList: 'lastjoined');
          },
          child: Card(
            borderOnForeground: true,
            child: Center(
              child: Text(
                i,
                style: kPrimaryTextStyle,
              ),
            ),
            color: const Color(0XFFFFB6C1),
          ),
        ),
      ));
    }
    print('Card list length ${lastJoinedList.length}');
    return lastJoinedList;
  }

  List<GestureDetector> fetchInvitedList() {
    invitedList = [];
    for (var i in kconferenceNames) {
      invitedList.add(GestureDetector(
        onTapUp: (TapUpDetails details) {
          showPopup(details.globalPosition, kconferenceNames.indexOf(i), false,
              fromList: 'invited');
        },
        child: Card(
          borderOnForeground: true,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Text(
              i,
              style: kPrimaryTextStyle,
            ),
          ),
          color: const Color(0XFFF7F663),
        ),
      ));
    }
    print('Card list length ${lastJoinedList.length}');
    return invitedList;
  }

  List<Widget> _buildFooterWidgets(BuildContext context) => [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DayNightSwitcher(
                nightBackgroundColor: kprimaryColor,
                dayBackgroundColor: kprimaryColor,
                isDarkModeEnabled:
                    Provider.of<AppStateNotifier>(context, listen: false)
                        .darkModeEnabled,
                onStateChanged: (isDarkModeEnabled) =>
                    Provider.of<AppStateNotifier>(context, listen: false)
                        .darkModeEnabled = isDarkModeEnabled,
              ),
            ],
          ),
        ),
      ];

  void unsetConference(context, String conferenceId, int index) async {
    print('Inside unset Conference');
    bool unsetValue = await ApiHelper.unsetFavouriteConference(
        Provider.of<UserProfile>(context, listen: false)
            .getIdToken['name']
            .toString(),
        conferenceId);
    print('Unset conference status: $unsetValue');
    if (unsetValue == true)
      setState(() {
        print('Invoking set State');
        kfavouriteNames.removeAt(index);
      });
    else
      CustomSnackBar.showSnackBar(
          'Error: Unable to remove conference from Favourites', context);
  }

  void setConference(
      context, String conferenceId, int index, String fromWhere) async {
    print('Inside set Conference');
    bool setValue = await ApiHelper.setFavouriteConference(
        Provider.of<UserProfile>(context, listen: false)
            .getIdToken['name']
            .toString(),
        conferenceId);
    print('set conference status: $setValue');
    if (setValue == true)
      setState(() {
        print('Invoking set State');
        if (fromWhere == 'invited')
          kfavouriteNames.add(kconferenceNames[index]);
        else
          kfavouriteNames.add(kconferenceNames[index]);
      });
    else
      CustomSnackBar.showSnackBar(
          'Error: Unable to remove conference from Favourites', context);
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.3;
    PopupMenu.context = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: SideNavigation(),
      appBar: AppBar(
        backgroundColor: kprimaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: Provider.of<AppStateNotifier>(context).darkModeEnabled
                ? const AssetImage('assets/images/hoot_dark.png')
                : const AssetImage('assets/images/hoot_light.png'),
            // width: imageWidth,
            // height: imageHeight,
            width: imageWidth,
            height: imageWidth - 30,
          ),
          Text(
            'MPSC-HOOT',
            style: kSecondaryTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 30,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            //searchInvited
                            controller: searchRecent,
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                              hintText: 'Search',
                              hintStyle: Provider.of<AppStateNotifier>(context)
                                      .darkModeEnabled
                                  ? const TextStyle(color: Colors.white)
                                  : const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 30,
                          child: Card(
                            borderOnForeground: true,
                            elevation: 5.0,
                            child: Center(
                              child: Text(
                                'Last Joined',
                                style: kCardTextStyle,
                              ),
                            ),
                            color: kprimaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: fetchLastJoined(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 30,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            //searchInvited
                            controller: searchInvited,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                              hintText: 'Search',
                              hintStyle: Provider.of<AppStateNotifier>(context)
                                      .darkModeEnabled
                                  ? const TextStyle(color: Colors.white)
                                  : const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 30,
                          child: Card(
                            borderOnForeground: true,
                            child: Center(
                                child: Text(
                              'Invited Conferences',
                              style: kCardTextStyle,
                            )),
                            color: kprimaryColor,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: fetchInvitedList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kprimaryColor),
                      ),
                      onPressed: () async {
                        print('Pressed create conference');
                        bool gotMeetingLink = await showModalBottomSheet(
                                context: context, builder: buildBottomSheet) ??
                            false;
                        if (gotMeetingLink)
                          // ignore: curly_braces_in_flow_control_structures
                          CustomSnackBar.showSnackBar(
                              'Meeting link copied to clipboard', context);
                      },
                      child: const Text('Create Conference')),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kprimaryColor),
                      ),
                      onPressed: () async {
                        print('Pressed join conference');
                        Navigator.pushNamed(context, JoinConference.id);
                        //await unsetConference(context);
                      },
                      child: const Text('Join Conference')),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: ListView(
                  scrollDirection: Axis.horizontal, children: fetchFavorites()),
            ),
          ),
          ..._buildFooterWidgets(context),
        ],
      ),
    );
  }
}
