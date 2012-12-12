//
//  CollectViewController.m
//  flickrlabs
//
//  Created by csjones on 12/7/12.
//  Copyright (c) 2012 csjones. All rights reserved.
//

#import "FlickrData.h"
#import "UIImage+Resize.h"
#import "CollectionCell.h"
#import "ImageViewController.h"
#import "CollectViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface CollectViewController ()

- (void)reloadData:(NSNotification *)notification;

@end

@implementation CollectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"finishedRequest" object:nil];
    
    flickrData = [FlickrData sharedInstance];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"flickrdots"] resizedImage:CGSizeMake(33, 33)
                                                                                                   interpolationQuality:kCGInterpolationDefault]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData:(NSNotification *)notification
{
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:notification.object]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if( [flickrData getThumbnailImageAtIndexPath:indexPath] )
    {
        cell.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.imageView.layer.shadowOffset = CGSizeMake(0, 0);
        cell.imageView.layer.shouldRasterize = YES;
        cell.imageView.layer.shadowOpacity = .7f;
        cell.imageView.layer.shadowRadius = 7;
        cell.imageView.alpha = .0f;
        
        cell.imageView.image = [flickrData getThumbnailImageAtIndexPath:indexPath];
        
        [UIView animateWithDuration:.2f animations:^{
            cell.imageView.alpha = 1.0f;
        }];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"picture"];
        cell.imageView.layer.shadowOpacity = .0f;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    ImageViewController *vc = [segue destinationViewController];
    
    vc.image = [flickrData getLargeImageAtIndexPath:[[self.collectionView indexPathsForSelectedItems] lastObject]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([flickrData getLargeImageAtIndexPath:indexPath])
        [self performSegueWithIdentifier:@"Image" sender:self];
}

@end