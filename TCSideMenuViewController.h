//
//  TCSideMenuViewController.h
//  TCSideBar
//
//  Created by Ted Cheng on 25/4/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LeftSideMenuWidth 260
#define RightSideMenuWidth 260

typedef enum {
    TCSideMenuViewControllerPanStateAllSideMenuClosed,
    TCSideMenuViewControllerPanStateLeftSideMenuFullScreen,
    TCSideMenuViewControllerPanStateLeftSideMenuOpen,
    TCSideMenuViewControllerPanStateRightSideMenuFullScreen,
    TCSideMenuViewControllerPanStateRightSideMenuOpen
} TCSideMenuViewControllerPanState;

@interface TCSideMenuViewController : UIViewController

@property (nonatomic, strong) UIViewController *leftSideMenuViewController;

@property (nonatomic, strong) UIViewController *rightSideMenuViewController;

@property (nonatomic, strong) UIViewController *rootViewController;

- (TCSideMenuViewControllerPanState)panState;

- (BOOL)isOppositePanning:(TCSideMenuViewControllerPanState) panState;

- (BOOL)isLeftSideMenuOpen;

- (BOOL)isRightSideMenuOpen;

+ (TCSideMenuViewController *)sharedSideMenuViewController;

+ (void)setUpBarButtonForViewController:(UIViewController *) viewCon;

#pragma mark - panning Function

- (void)setPanState:(TCSideMenuViewControllerPanState) panState Animated:(BOOL) animated;

@end


@interface TCSideMenuViewController(Helper)

- (void)toggleLeftSideMenu;
- (void)toggleRightSideMenu;

- (void)toggleLeftSideMenuAnimated:(BOOL)animated;
- (void)toggleRightSideMenuAnimated:(BOOL)animated;


@end