//
//  CollectViewController.m
//  flickrlabs
//
//  Created by csjones on 12/7/12.
//  Copyright (c) 2012 csjones. All rights reserved.
//

#import "UIImage+Resize.h"
#import "CollectionCell.h"
#import "ImageViewController.h"
#import "CollectViewController.h"

@implementation CollectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    flickrData = [FlickrData sharedInstanceWithCollection:self.collectionView];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"flickrdots"] resizedImage:CGSizeMake(33, 33)
                                                                                                   interpolationQuality:kCGInterpolationDefault]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [flickrData setThumbnailImage:cell.imageView atIndexPath:indexPath];
    
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
        [self performSegueWithIdentifier:@"Image" sender: self];
}

@end