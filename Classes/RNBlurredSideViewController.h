//
//  RNBlurredSideViewController.h
//  RNBlurredSideViewController
//
//  Created by Wenbo Shi on 2/12/14.
//  Copyright (c) 2014 Zzuumm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define DEFAULT_LEFT_WIDTH SCREEN_WIDTH-60
#define DEFAULT_RIGHT_WIDTH SCREEN_WIDTH-60
#define DEFAULT_ALPHA 0.5
#define DEFAULT_DIM_ALPHA 0.4

@interface UIImage (RNBlurredSideViewController)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end

@interface RNBlurredSideViewController : UIViewController

//The width of the left side view. Set it to 0 if there is no left view.
@property (nonatomic, assign) CGFloat leftWidth;

//The width of the right side view. Set it to 0 if there is no right view.
@property (nonatomic, assign) CGFloat rightWidth;

//The layer alpha of the side views.
@property (nonatomic, assign) CGFloat sideViewAlpha;

//The tint color of the side views.
@property (nonatomic, retain) UIColor *sideViewTintColor;

//The background image.
@property (nonatomic, retain) UIImage *backgroundImage;

//The container view of the left side view.
@property (nonatomic, retain) UIView *leftContentView;

//The container view of the center view.
@property (nonatomic, retain) UIView *centerContentView;

//The container view of the right side view.
@property (nonatomic, retain) UIView *rightContentView;

//Dim the background when swiping. Default is YES.
@property (nonatomic, assign) BOOL dim;


- (void)openLeftView:(BOOL)animated;
- (void)openRightView:(BOOL)animated;
- (void)closeSideView:(BOOL)animated;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
