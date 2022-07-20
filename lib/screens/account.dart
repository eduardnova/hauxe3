import 'package:firebase_auth/firebase_auth.dart';
import 'package:hauxe/utils/authentication.dart';
import 'package:hauxe/screens/auth_screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:hauxe/theme/color.dart';
import 'package:hauxe/utils/data.dart';
import 'package:hauxe/widgets/custom_image.dart';
import 'package:hauxe/theme/custom_colors.dart';
import 'package:hauxe/widgets/setting_box.dart';
import 'package:hauxe/widgets/setting_item.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late bool _isEmailVerified;
  late User _user;

  bool _verificationEmailBeingSent = false;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;
    _isEmailVerified = _user.emailVerified;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(backgroundColor: appBgColor, pinned: true, snap: true, floating: true),
        SliverToBoxAdapter(child: getBody())
      ],
    );
  }

  getHeader() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Account",
            style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Column(
            children: [
              _user.photoURL != null
                  ? ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Image.network(
                          _user.photoURL!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: CustomColors.firebaseGrey,
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget._user.displayName!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 24.0),
              _isEmailVerified
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: Material(
                            color: Colors.greenAccent.withOpacity(0.6),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Email is verified',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 20,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: Material(
                            color: Colors.redAccent.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Email is not verified',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 20,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 8.0),
              Visibility(
                visible: !_isEmailVerified,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _verificationEmailBeingSent
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColors.firebaseGrey,
                            ),
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                CustomColors.firebaseGrey,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                _verificationEmailBeingSent = true;
                              });
                              await _user.sendEmailVerification();
                              setState(() {
                                _verificationEmailBeingSent = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                'Verify',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.firebaseNavy,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(width: 16.0),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () async {
                        User? user = await Authentication.refreshUser(_user);

                        if (user != null) {
                          setState(() {
                            _user = user;
                            _isEmailVerified = user.emailVerified;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 24.0),
              //Text(
              //  'You are now signed in using Firebase Authentication. To sign out of your account click the "Sign Out" button below.',
              //  style: TextStyle(color: CustomColors.firebaseGrey.withOpacity(0.8), fontSize: 14, letterSpacing: 0.2),
              // ),
              // SizedBox(height: 16.0),
              // _isSigningOut
              //     ? CircularProgressIndicator(
              //         valueColor: AlwaysStoppedAnimation<Color>(
              //           Colors.redAccent,
              //         ),
              //       )
              //     : ElevatedButton(
              //         style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.all(
              //             Colors.redAccent,
              //           ),
              //           shape: MaterialStateProperty.all(
              //             RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              ///             ),
              //           ),
              //         ),
              //         onPressed: () async {
              //           setState(() {
              //             _isSigningOut = true;
              //           });
              //           await FirebaseAuth.instance.signOut();
              //           setState(() {
              //             _isSigningOut = false;
              //           });
              //           Navigator.of(context).pushReplacement(_routeToSignInScreen());
              //         },
              //         child: Padding(
              //           padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              //           child: Text(
              //             'Sign Out',
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.white,
              //               letterSpacing: 2,
              //             ),
              //           ),
              //         ),
              //       ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: SettingBox(
                  title: "12 courses",
                  icon: "assets/icons/work.svg",
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: SettingBox(
                  title: "55 hours",
                  icon: "assets/icons/time.svg",
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: SettingBox(
                  title: "4.8",
                  icon: "assets/icons/star.svg",
                )),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Setting",
                leadingIcon: "assets/icons/setting.svg",
                //bgIconColor: blue,
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Payment",
                leadingIcon: "assets/icons/wallet.svg",
                //bgIconColor: green,
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Bookmark",
                leadingIcon: "assets/icons/bookmark.svg",
                //bgIconColor: primary,
                onTap: () {},
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Notification",
                leadingIcon: "assets/icons/bell.svg",
                bgIconColor: purple,
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Privacy",
                leadingIcon: "assets/icons/shield.svg",
                bgIconColor: orange,
                onTap: () {},
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Log Out",
                leadingIcon: "assets/icons/logout.svg",
                bgIconColor: darker,
                onTap: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await FirebaseAuth.instance.signOut();
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context).pushReplacement(_routeToSignInScreen());
                },
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
