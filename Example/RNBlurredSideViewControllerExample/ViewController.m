//
//  ViewController.m
//  RNBlurredSideViewControllerExample
//
//  Created by Wenbo Shi on 2/12/14.
//  Copyright (c) 2014 Zzuumm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController{
    UITableView *leftTableView;
    UITableView *rightTableView;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // Do something
        self.backgroundImage = [UIImage imageNamed:@"bkg.jpg"];
        //self.leftWidth = 250;
        //self.rightWidth = 250;
        //self.sideViewTintColor = [UIColor whiteColor];
        //self.sideViewAlpha = 0.2;
        
    }
    return self;
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = @"Item";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self closeSideView:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
