
import 'dart:math';

import 'package:flutter/material.dart';

double bottomBarVisibleHeight = 55.0;
double bottomBarOriginalHeight = 80.0;
double bottomBarExpandedHeight = 300.0;

class MenuButtonModel{
  final IconData icon;
  final String label;
  final Function onTap;

  MenuButtonModel({
    @required this.icon,
    @required this.label,
    @required this.onTap,
  });
}

class ExtendedNavigationButton extends StatefulWidget {

  ExtendedNavigationButton({
    Key key,
    this.onTap,
    this.currentBottomBarMorePercent,
    this.menuButtons,
    this.elevation,
    this.navButtonColor,
    this.navButtonIconColor
    
  });
  
  final Function(int) onTap;
  final Function(double) currentBottomBarMorePercent;

  ///If you want Empty Space then put null.
  ///Maximum 9 buttons can be added.
  ///Buttons will be placed according to the list order.
  final List<MenuButtonModel> menuButtons;

  final double elevation;
  final Color navButtonColor;
  final Color navButtonIconColor;

  @override
  _ExtendedNavigationButtonState createState() => _ExtendedNavigationButtonState();
  
}

class _ExtendedNavigationButtonState extends State<ExtendedNavigationButton> with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

  }

  //More Button Animation
  AnimationController animationControllerBottomBarMore;
  CurvedAnimation curve;
  var offsetBottomBarMore = 0.0;
  
  get currentBottomBarMorePercentage => max(
        0.0,
        min(
          1.0,
          offsetBottomBarMore /
              (bottomBarExpandedHeight - bottomBarOriginalHeight),
        ),
      );
  bool isBottomBarMoreOpen = false;
  Animation<double> animationMore;

  void onMoreVerticalDragUpdate(details) {
    offsetBottomBarMore -= details.delta.dy;
    if (offsetBottomBarMore > bottomBarExpandedHeight) {
      offsetBottomBarMore = bottomBarExpandedHeight;
    } else if (offsetBottomBarMore < 0) {
      offsetBottomBarMore = 0;
    }

    if (widget.currentBottomBarMorePercent != null)
      widget.currentBottomBarMorePercent(currentBottomBarMorePercentage);
    setState(() {});
  }
void animateBottomBarMore(bool open) {
    animationControllerBottomBarMore = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (1000 *
                        (isBottomBarMoreOpen
                            ? currentBottomBarMorePercentage
                            : (1 - currentBottomBarMorePercentage)))
                    .toInt()),
        vsync: this);
    curve = CurvedAnimation(
        parent: animationControllerBottomBarMore, curve: Curves.ease);
    animationMore = Tween(
            begin: offsetBottomBarMore,
            end: open ? bottomBarExpandedHeight : 0.0)
        .animate(curve)
          ..addListener(
            () {
              setState(() {
                offsetBottomBarMore = animationMore.value;
              });
            },
          )
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed) {
                isBottomBarMoreOpen = open;
              }
            },
          );
    animationControllerBottomBarMore.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationControllerBottomBarMore?.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        CustomBottomNavigationButton(
          menuButtons: widget.menuButtons,
          elevation: widget.elevation,
          navButtonColor: widget.navButtonColor,
          navButtonIconColor: widget.navButtonIconColor,
          onTap: widget.onTap,
          animateBottomBarMore: animateBottomBarMore,
          currentBottomBarMorePercentage: currentBottomBarMorePercentage,
          isBottomBarMoreOpen: isBottomBarMoreOpen,
          onMoreVerticalDragUpdate: onMoreVerticalDragUpdate,
          onMorePanDown: () => animationControllerBottomBarMore?.stop(),
        ),
      ],
    );
  }

}
class CustomBottomNavigationButton extends StatelessWidget {
  final List<MenuButtonModel> menuButtons;
  final Function(int) onTap;
  final Function() onMorePanDown;
  final double currentBottomBarMorePercentage;
  final Function(bool) animateBottomBarMore;
  final bool isBottomBarMoreOpen;
  final Function(DragUpdateDetails) onMoreVerticalDragUpdate;
  final Color navButtonColor;
  final Color navButtonIconColor;
  final double elevation;


  CustomBottomNavigationButton({
    Key key,
    this.onTap,
    this.animateBottomBarMore,
    this.currentBottomBarMorePercentage,
    this.isBottomBarMoreOpen,
    this.onMorePanDown,
    this.onMoreVerticalDragUpdate,
    this.menuButtons,
    this.navButtonColor,
    this.navButtonIconColor,
    this.elevation,


  });
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      height: MediaQuery.of(context).size.height/1.8,
      // alignment: Alignment.bottomCenter,
      child: Card(
        color: Colors.transparent,
        elevation: elevation ?? 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SizedBox(
          height: bottomBarOriginalHeight +
              //* Increase height when parallex card is expanded *//
              (bottomBarExpandedHeight - bottomBarOriginalHeight)  +
              //* Increase height when More Button is expanded *//
              (bottomBarExpandedHeight) * currentBottomBarMorePercentage +
              //* Increase Height For Search Bar */
              (bottomBarExpandedHeight),
          child: Stack(
            children: <Widget>[
              _buildOtherButtons(context),
              _buildMoreExpandedCard(context),
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _buildOtherButtons(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 80.0,
        padding: EdgeInsets.only(left: 0, right: 0),
        margin: EdgeInsets.only(bottom: 30.0),
        height: bottomBarVisibleHeight +
            (bottomBarExpandedHeight - 0) * currentBottomBarMorePercentage,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[_buildMoreButton(),],

        ),
      ),
    );
  }

  Widget _buildMoreButton() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: bottomBarVisibleHeight,
            child: GestureDetector(
              onPanDown: (_) => onMorePanDown,
              onVerticalDragUpdate: onMoreVerticalDragUpdate,
              onVerticalDragEnd: (_) {
                _dispatchBottomBarMoreOffset();
              },
              onVerticalDragCancel: () {
                _dispatchBottomBarMoreOffset();
              },
              child: FloatingActionButton(
                backgroundColor: navButtonColor,
                heroTag: null,
                onPressed: () {
                  if (onTap != null) onTap(0);
                  animateBottomBarMore(!isBottomBarMoreOpen);
                },
                child: Icon(Icons.menu, size:30,color: navButtonIconColor)
              ),
            ),
          ),
          SizedBox(
            height: (bottomBarExpandedHeight - bottomBarVisibleHeight) *
                currentBottomBarMorePercentage,
          )
        ],
      ),
    );
  }

  Widget _buildMoreExpandedCard(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 60,
      child: Opacity(
        opacity: currentBottomBarMorePercentage,
        child: Container(
          height: (bottomBarExpandedHeight - bottomBarVisibleHeight - 10) *
              currentBottomBarMorePercentage,
          child: Stack(
            // alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: MenuButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: menuButtons[0],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: MenuButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: menuButtons[1],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: MenuButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: menuButtons[2],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: MenuButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: menuButtons[3],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: MenuButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: menuButtons[4],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: MenuButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: menuButtons[5],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: MenuButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: menuButtons[6],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MenuButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: menuButtons[7],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MenuButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: menuButtons[8],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _dispatchBottomBarMoreOffset() {
    if (!isBottomBarMoreOpen) {
      if (currentBottomBarMorePercentage < 0.3) {
        animateBottomBarMore(false);
      } else {
        animateBottomBarMore(true);
      }
    } else {
      if (currentBottomBarMorePercentage > 0.6) {
        animateBottomBarMore(true);
      } else {
        animateBottomBarMore(false);
      }
    }
  }
  
}

class MenuButtons extends StatelessWidget {
  const MenuButtons({
    Key key,
    @required this.currentBottomBarMorePercentage,
    @required this.model,
  }) : super(key: key);

  final double currentBottomBarMorePercentage;
  final MenuButtonModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
      child: model == null
          ? SizedBox()
          : FlatButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    model.icon,
                    size: MediaQuery.of(context).size.width *
                        0.33 *
                        currentBottomBarMorePercentage /
                        3,
                    
                  ),
                  Text(
                    model.label,
                    textAlign: TextAlign.center,
                    
                    style: TextStyle().copyWith(
                      fontSize: MediaQuery.of(context).size.width *
                          0.1 *
                          currentBottomBarMorePercentage /
                          3,
                    ),
                  )
                ],
              ),
              onPressed: model.onTap,
            ),
    );
  }
}


