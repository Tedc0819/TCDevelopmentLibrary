//
//  TCNavigationBarBannerNoticeView.m
//
//  Created by Ted Cheng on 26/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCNavigationBarBannerNoticeView.h"
#import "TCNoticeManager.h"

@interface TCNavigationBarBannerNoticeView()

@property (nonatomic, strong) UILabel *noticeLabel;

@end

@implementation TCNavigationBarBannerNoticeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        float suitableWidth = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? screenSize.width :  screenSize.height;
        
        [self setFrame:CGRectMake(0, iOS7 ? 64 : 60 , suitableWidth, 30)];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAlpha:0];
        
        self.noticeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self.noticeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.noticeLabel setTextColor:iOS7 ? [UIColor blackColor] : [UIColor whiteColor]];
        [self.noticeLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.noticeLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:self.noticeLabel];
    }
    return self;
}

- (void)updateNotice:(TCNotice *)notice
{
    [self.noticeLabel setBackgroundColor:[self colorForNoticeType:notice.type]];
    [self.noticeLabel setText:notice.text];
}

- (UIColor *)colorForNoticeType:(TCNoticeType)type
{
    UIColor *color = iOS7 ? [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    if (type==TCNoticeTypeNavigationBarBannerWarning) color = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.7];
    return color;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
