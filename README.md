# RNBlurredSideViewController

RNBlurredSideViewController is a side view controller with a dynamic blurred background effect when swiping similar to the iOS 7 control center. It can be used to show views on the side like the Facebook or Path app. The unique feature of RNBlurredSideViewController is that it can blur the side view background dynamically when swiping which is similar to the iOS 7 control center. The implementation of the blur effect is not based on UIToolbar. The blur effect can be customized.

![](http://i57.tinypic.com/j7c9zk.png)
![](http://i58.tinypic.com/23ubl1t.png)
![](http://i60.tinypic.com/2ibdlkj.png)

## Usage

Subclass RNBlurredSideViewController
```
@interface ViewController : RNBlurredSideViewController
```
Set the backgroundImage and other parameters in the init method of the viewController
```
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // Do something
        self.backgroundImage = [UIImage imageNamed:@"bkg.jpg"];
        self.leftWidth = 250;
        self.rightWidth = 250;
        self.sideViewTintColor = [UIColor whiteColor];
        self.sideViewAlpha = 0.2;
        
    }
    return self;
}
```

Add your views to self.leftContentView, self.centerContentView, and self.rightContentView
```
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.leftContentView.frame.size.width, self.leftContentView.frame.size.height-20)];
    leftTableView.backgroundColor = [UIColor clearColor];
    leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    [self.leftContentView addSubview:leftTableView];
    
    rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.rightContentView.frame.size.width, self.rightContentView.frame.size.height-20)];
    rightTableView.backgroundColor = [UIColor clearColor];
    rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    rightTableView.dataSource = self;
    rightTableView.delegate = self;
    [self.rightContentView addSubview:rightTableView];
    
}
```

## Properties

The width of the left side view. Set it to 0 if there is no left view.
```
@property (nonatomic, assign) CGFloat leftWidth;
```

The width of the right side view. Set it to 0 if there is no right view.
```
@property (nonatomic, assign) CGFloat rightWidth;
```

The layer alpha of the side views.
```
@property (nonatomic, assign) CGFloat sideViewAlpha;
```

The tint color of the side views.
```
@property (nonatomic, retain) UIColor *sideViewTintColor;
```

The background image.
```
@property (nonatomic, retain) UIImage *backgroundImage;
```

The container view of the left side view.
```
@property (nonatomic, retain) UIView *leftContentView;
```

The container view of the center view.
```
@property (nonatomic, retain) UIView *centerContentView;
```

The container view of the right side view.
```
@property (nonatomic, retain) UIView *rightContentView;
```

Dim the background when swiping. Default is YES.
```
@property (nonatomic, assign) BOOL dim;
```

## Requirements

iOS>=6.0 (Example project is built with iOS 7)


Accelerate Framework

## Installation

RNBlurredSideViewController is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "RNBlurredSideViewController"

You can also drag the class files into your project and add the Accelerate framework.

## Supported Orientation

RNBlurredSideViewController currently does not support horizontal orientation. But you can easily modify the code to support it.

## Author

Wenbo Shi, cwenboshi@gmail.com

## License

RNBlurredSideViewController is available under the MIT license. See the LICENSE file for more info.

