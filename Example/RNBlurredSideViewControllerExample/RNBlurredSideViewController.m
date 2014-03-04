//
//  RNBlurredSideViewController.m
//  RNBlurredSideViewController
//
//  Created by Wenbo Shi on 2/12/14.
//  Copyright (c) 2014 Zzuumm. All rights reserved.
//

#import "RNBlurredSideViewController.h"


@implementation UIImage (RNBlurredSideViewController)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}

@end

@interface RNBlurredSideViewController ()<UIScrollViewDelegate>

@end

@implementation RNBlurredSideViewController{
    UIScrollView *mainScrollView;
    unsigned screenStatus;
    
    UIImage *blurredImage;
    UIImageView *blurredImageView;
    UIView *blurredOverlayView;
    
    UIView *backgroundView;
}

@synthesize leftWidth = _leftWidth;
@synthesize rightWidth = _rightWidth;
@synthesize sideViewAlpha = _sideViewAlpha;
@synthesize backgroundImage = _backgroundImage;
@synthesize leftContentView = _leftContentView;
@synthesize centerContentView = _centerContentView;
@synthesize rightContentView = _rightContentView;
@synthesize dim = _dim;

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // Do something
        [self setDefault];
    }
    return self;
}

- (id)init{
    if (self = [super init]){
        [self setDefault];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        [self setDefault];
    }
    return self;
}

- (void)setDefault{
    self.leftWidth = DEFAULT_LEFT_WIDTH;
    self.rightWidth = DEFAULT_RIGHT_WIDTH;
    self.sideViewAlpha = DEFAULT_ALPHA;
    self.sideViewTintColor = [UIColor blackColor];
    self.dim = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadScrollView];
}

- (void)loadScrollView{
    self.view.backgroundColor = [UIColor clearColor];
    
    backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    [self.view addSubview:backgroundView];
    
    blurredImage = [self.backgroundImage blurredImageWithRadius:20 iterations:10 tintColor:nil];
    
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH+self.leftWidth+self.rightWidth, SCREEN_HEIGHT);
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.bounces = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.decelerationRate = 0;
    
    [mainScrollView setCanCancelContentTouches:NO];
    [mainScrollView setDelaysContentTouches:YES];

    
    self.leftContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftWidth, SCREEN_HEIGHT)];
    self.leftContentView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:_leftContentView];
    
    UILabel *seperation = [[UILabel alloc] initWithFrame:CGRectMake(self.leftWidth-0.5, 0, 0.5, SCREEN_HEIGHT)];
    seperation.backgroundColor = [UIColor whiteColor];
    seperation.alpha = 0.3;
    [mainScrollView addSubview:seperation];
    
    self.centerContentView = [[UIView alloc] initWithFrame:CGRectMake(self.leftWidth, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.centerContentView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:_centerContentView];
    
    self.rightContentView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH+self.leftWidth, 0, self.rightWidth, SCREEN_HEIGHT)];
    self.rightContentView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:_rightContentView];
    
    seperation = [[UILabel alloc] initWithFrame:CGRectMake(self.leftWidth+SCREEN_WIDTH, 0, 0.5, SCREEN_HEIGHT)];
    seperation.backgroundColor = [UIColor whiteColor];
    seperation.alpha = 0.3;
    [mainScrollView addSubview:seperation];
    
    
    mainScrollView.delegate = self;
    
    [self.view addSubview:mainScrollView];
    
    blurredImageView = [[UIImageView alloc] init];
    blurredImageView.image = blurredImage;
    blurredImageView.clipsToBounds = YES;
    [self.view insertSubview:blurredImageView belowSubview:mainScrollView];
    
    blurredOverlayView = [[UIImageView alloc] init];
    blurredOverlayView.backgroundColor = _sideViewTintColor;
    blurredOverlayView.alpha = _sideViewAlpha;
    [self.view insertSubview:blurredOverlayView belowSubview:mainScrollView];
    
    [self closeSideView:NO];
    
}

#pragma mark - scrollView

- (void)closeSideView:(BOOL)animated{
    [mainScrollView setContentOffset:CGPointMake(self.leftWidth, 0) animated:animated];
    screenStatus = 0;
}

- (void)openLeftView:(BOOL)animated{
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:animated];
    screenStatus = 1;
}

- (void)openRightView:(BOOL)animated{
    [mainScrollView setContentOffset:CGPointMake(self.rightWidth+self.leftWidth, 0) animated:animated];
    screenStatus = 2;
}

- (void)arrangeViews:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x<self.leftWidth/5){
        if (screenStatus == 0)
            [self openLeftView:YES];
        else if (screenStatus != 1) {
            [self closeSideView:YES];
        }
        else{
            [self openLeftView:YES];
        }
        
    }
    else if (scrollView.contentOffset.x>self.leftWidth+self.rightWidth*4/5){
        if (screenStatus == 0)
            [self openRightView:YES];
        else if (screenStatus != 2) {
            [self closeSideView:YES];
        }
        else{
            [self openRightView:YES];
        }
    }
    else{
        [self closeSideView:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //NSLog(@"%f",scrollView.contentOffset.x);
    //NSLog(@"%f",SCREEN_WIDTH-LEFT_SIZE);
    if ([scrollView isEqual:mainScrollView]){
        if (!decelerate){
            [self arrangeViews:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:mainScrollView])
        [self arrangeViews:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if ([scrollView isEqual:mainScrollView]){
        if (scrollView.contentOffset.x < self.leftWidth){
            CGRect blurredRect = CGRectMake(0, 0, self.leftWidth-scrollView.contentOffset.x, SCREEN_HEIGHT);
            //UIImage *croppedBlurredImage = [blurredImage croppedImage:blurredRect];
            blurredImageView.frame = blurredRect;
            blurredImageView.contentMode = UIViewContentModeTopLeft;
            blurredOverlayView.frame = blurredImageView.frame;
            if (self.dim){
                backgroundView.alpha = DEFAULT_DIM_ALPHA+(1-DEFAULT_DIM_ALPHA)*(1-(self.leftWidth-scrollView.contentOffset.x)/self.leftWidth);
                self.centerContentView.alpha = backgroundView.alpha;
            }
        }
        else if (scrollView.contentOffset.x > self.leftWidth){
            CGRect blurredRect = CGRectMake(SCREEN_WIDTH - (scrollView.contentOffset.x-self.leftWidth), 0, scrollView.contentOffset.x-self.leftWidth, SCREEN_HEIGHT);
            blurredImageView.frame = blurredRect;
            blurredImageView.contentMode = UIViewContentModeTopRight;
            blurredOverlayView.frame = blurredImageView.frame;
            if (self.dim){
                backgroundView.alpha = DEFAULT_DIM_ALPHA+(1-DEFAULT_DIM_ALPHA)*(1-(scrollView.contentOffset.x-self.leftWidth)/self.rightWidth);
                self.centerContentView.alpha = backgroundView.alpha;
            }
        }
        
    }
}

@end
