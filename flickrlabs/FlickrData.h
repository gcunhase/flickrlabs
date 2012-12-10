//
//  FlickrData.h
//  flickrlabs
//
//  Created by csjones on 12/7/12.
//  Copyright (c) 2012 csjones. All rights reserved.
//

@interface FlickrData : NSObject
{
    UICollectionView    *_collectionView;
    
    NSDictionary        *_flickrDictionary;
    
    NSMutableDictionary *_imageDictionary, *_thumbnailDictionary;
}

+ (id)sharedInstanceWithCollection:(UICollectionView*)collectionView;

- (UIImage *)getLargeImageAtIndexPath:(NSIndexPath*)indexPath;
- (void)setThumbnailImage:(UIImageView *)imageView atIndexPath:(NSIndexPath*)indexPath;

@end
