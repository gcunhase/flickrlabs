//
//  ImageViewController.m
//  flickrlabs
//
//  Created by csjones on 12/8/12.
//  Copyright (c) 2012 csjones. All rights reserved.
//

#import "UIImage+Resize.h"
#import "ImageViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat viewHeight = [[UIScreen mainScreen] bounds].size.height - 64.0f;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    
    imageView.frame = CGRectMake(imageView.frame.size.width < 320.0f ? (320.0f - imageView.frame.size.width) * .5f : .0f,
                                 imageView.frame.size.height < viewHeight ? (viewHeight - imageView.frame.size.height) * .5f : .0f,
                                 imageView.frame.size.width, imageView.frame.size.height);
    
    imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    imageView.layer.shadowOffset = CGSizeMake(.0f,.0f);
    imageView.layer.shadowOpacity = .7f;
    imageView.layer.shadowRadius = 7.0f;
    
    [self.view addSubview:imageView];
}

@end
