//
//  TCSideMenuViewController.m
//  TCSideBar
//
//  Created by Ted Cheng on 25/4/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCSideMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

static TCSideMenuViewController *_sharedController;

@interface TCSideMenuViewController ()
{
    TCSideMenuViewControllerPanState _panState;
}

@end

@implementation TCSideMenuViewController

+ (TCSideMenuViewController *)sharedSideMenuViewController
{
    if (!_sharedController) {
        _sharedController = [[TCSideMenuViewController alloc] init];
    }
    return _sharedController;
}

+ (void)setUpBarButtonForViewController:(UIViewController *) viewCon
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_icon_shortcut"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:[self sharedSideMenuViewController]
                                                                  action:@selector(toggleLeftSideMenu)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_icon_history"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:[self sharedSideMenuViewController]
                                                                  action:@selector(toggleRightSideMenu)];
    
    [viewCon.navigationItem setLeftBarButtonItem:leftButton];
    [viewCon.navigationItem setRightBarButtonItem:rightButton];
}

#pragma mark - init related

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    [_rootViewController.view removeFromSuperview];
    _rootViewController = rootViewController;
    CGRect frame = self.view.bounds;
    [self.rootViewController.view setFrame:frame];
    [self.view addSubview:self.rootViewController.view];

    [self setRootViewControllerShadow];
}

- (void)setRootViewControllerShadow
{
    self.rootViewController.view.layer.masksToBounds = NO;
    self.rootViewController.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.rootViewController.view.layer.shadowRadius = 10;
    self.rootViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.rootViewController.view.bounds].CGPath;
    self.rootViewController.view.layer.shadowOpacity = 0.75;
}

- (void)setLeftSideMenuViewController:(UIViewController *)leftSideMenuViewController
{
    _leftSideMenuViewController = leftSideMenuViewController;
    CGRect frame = self.view.bounds;
    frame.size.width = LeftSideMenuWidth;
    [self.leftSideMenuViewController.view setFrame:frame];
    [self.view addSubview:self.leftSideMenuViewController.view];
    
    [self rearrangeViewControllerSequence];
}

- (void)setRightSideMenuViewController:(UIViewController *)rightSideMenuViewController
{
    _rightSideMenuViewController = rightSideMenuViewController;
    CGRect frame = self.view.bounds;
    frame.size.width = RightSideMenuWidth;
    frame.origin.x = self.view.bounds.size.width - RightSideMenuWidth;
    [self.rightSideMenuViewController.view setFrame:frame];
    [self.view addSubview:self.rightSideMenuViewController.view];
    
    [self rearrangeViewControllerSequence];
    
}

- (void)rearrangeViewControllerSequence
{
    if (self.panState == TCSideMenuViewControllerPanStateLeftSideMenuFullScreen || self.panState == TCSideMenuViewControllerPanStateLeftSideMenuOpen)
    {
        [self.view bringSubviewToFront:self.rightSideMenuViewController.view];
        [self.view bringSubviewToFront:self.leftSideMenuViewController.view];
    }
    if (self.panState == TCSideMenuViewControllerPanStateRightSideMenuOpen || self.panState == TCSideMenuViewControllerPanStateRightSideMenuFullScreen)
    {
        [self.view bringSubviewToFront:self.leftSideMenuViewController.view];
        [self.view bringSubviewToFront:self.rightSideMenuViewController.view];
    }
    [self.view bringSubviewToFront:self.rootViewController.view];
}

#pragma mark - Panning related

- (void)setPanState:(TCSideMenuViewControllerPanState) panState Animated:(BOOL) animated;
{
    if ([self isPanStateLeft:panState] && !self.leftSideMenuViewController) return;
    if ([self isPanStateRight:panState] && !self.rightSideMenuViewController) return;
    
    void (^setCenterForState)(TCSideMenuViewControllerPanState) = ^(TCSideMenuViewControllerPanState panState) {
        CGPoint center = self.rootViewController.view.center;
        center.x = [self centerXOfPanMode:panState];
        [self.rootViewController.view setCenter:center];
    };
    
    if (animated) {
        float duration = animated ? 0.2 : 0;
        
        [UIView animateWithDuration:duration animations:^{
            if ([self isOppositePanning:panState]) {
                setCenterForState(TCSideMenuViewControllerPanStateAllSideMenuClosed);
            }
        } completion:^(BOOL finished) {
            _panState = panState;
            [self rearrangeViewControllerSequence];
            [UIView animateWithDuration:duration animations:^{
                setCenterForState(_panState);
            } completion:^(BOOL finished) {
            }];
        }];
    } else {
        _panState = panState;
        [self rearrangeViewControllerSequence];
        setCenterForState(_panState);
    }
}

#pragma mark - getter method

- (TCSideMenuViewControllerPanState)panState
{
    return _panState;
}

- (BOOL)isOppositePanning:(TCSideMenuViewControllerPanState) panState
{
    return ([self isPanStateLeft:panState] && [self isPanStateRight:self.panState]) || ([self isPanStateLeft:self.panState] && [self isPanStateRight:panState]);
}

- (BOOL)isLeftSideMenuOpen
{
    return [self isPanStateLeft:self.panState];
}

- (BOOL)isRightSideMenuOpen
{
    return [self isPanStateRight:self.panState];
}

- (BOOL)isPanStateLeft:(TCSideMenuViewControllerPanState) panState
{
    return (panState == TCSideMenuViewControllerPanStateLeftSideMenuOpen || panState == TCSideMenuViewControllerPanStateLeftSideMenuFullScreen);
}

- (BOOL)isPanStateRight:(TCSideMenuViewControllerPanState) panState
{
    return (panState == TCSideMenuViewControllerPanStateRightSideMenuFullScreen || panState == TCSideMenuViewControllerPanStateRightSideMenuOpen);
}



- (float)centerXOfPanMode:(TCSideMenuViewControllerPanState) state
{
    float result = 0.0;
    float rootCenterX = CGRectGetMidX(self.view.bounds);
    
    switch (state) {
        case TCSideMenuViewControllerPanStateLeftSideMenuOpen:
            result = rootCenterX + LeftSideMenuWidth;
            break;
        case TCSideMenuViewControllerPanStateLeftSideMenuFullScreen:
            result = rootCenterX + self.view.bounds.size.width;
            break;
        case TCSideMenuViewControllerPanStateAllSideMenuClosed:
            result = rootCenterX;
            break;
        case TCSideMenuViewControllerPanStateRightSideMenuOpen:
            result = rootCenterX - RightSideMenuWidth;
            break;
        case TCSideMenuViewControllerPanStateRightSideMenuFullScreen:
            result = rootCenterX - self.view.bounds.size.width;
            break;
        default:
            break;
    }
    return result;
}

@end

@implementation TCSideMenuViewController(Helper)

- (void)toggleLeftSideMenu
{
    if (self.panState == TCSideMenuViewControllerPanStateLeftSideMenuOpen || self.panState == TCSideMenuViewControllerPanStateLeftSideMenuFullScreen){
        [self setPanState:TCSideMenuViewControllerPanStateAllSideMenuClosed Animated:YES];
    } else {
        [self setPanState:TCSideMenuViewControllerPanStateLeftSideMenuOpen Animated:YES];
    }

//    switch (self.panState) {
//        case TCSideMenuViewControllerPanStateLeftSideMenuOpen:
//            [self setPanState:TCSideMenuViewControllerPanStateAllSideMenuClosed Animated:YES];
//            break;
//        case TCSideMenuViewControllerPanStateLeftSideMenuFullScreen:
//            [self setPanState:TCSideMenuViewControllerPanStateAllSideMenuClosed Animated:YES];
//            break;
//        case TCSideMenuViewControllerPanStateAllSideMenuClosed:
//            [self setPanState:TCSideMenuViewControllerPanStateLeftSideMenuOpen Animated:YES];
//            break;
//
//        default:
//            break;
//    }
}

- (void)toggleRightSideMenu
{
    if (self.panState == TCSideMenuViewControllerPanStateRightSideMenuOpen || self.panState == TCSideMenuViewControllerPanStateRightSideMenuFullScreen){
        [self setPanState:TCSideMenuViewControllerPanStateAllSideMenuClosed Animated:YES];
    } else {
        [self setPanState:TCSideMenuViewControllerPanStateRightSideMenuOpen Animated:YES];
    }
}

- (void)toggleLeftSideMenuAnimated:(BOOL)animated
{
    if (self.panState == TCSideMenuViewControllerPanStateLeftSideMenuOpen || self.panState == TCSideMenuViewControllerPanStateLeftSideMenuFullScreen){
        [self setPanState:TCSideMenuViewControllerPanStateAllSideMenuClosed Animated:animated];
    } else {
        [self setPanState:TCSideMenuViewControllerPanStateLeftSideMenuOpen Animated:animated];
    }
}

- (void)toggleRightSideMenuAnimated:(BOOL)animated
{
    if (self.panState == TCSideMenuViewControllerPanStateRightSideMenuOpen || self.panState == TCSideMenuViewControllerPanStateRightSideMenuFullScreen){
        [self setPanState:TCSideMenuViewControllerPanStateAllSideMenuClosed Animated:animated];
    } else {
        [self setPanState:TCSideMenuViewControllerPanStateRightSideMenuOpen Animated:animated];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

