//
//  FlickrData.h
//  flickrlabs
//
//  Created by csjones on 12/7/12.
//  Copyright (c) 2012 csjones. All rights reserved.
//

@interface FlickrData : NSObject
{
    NSDictionary        *_flickrDictionary;
    
    NSMutableDictionary *_imageDictionary, *_thumbnailDictionary;
}

+ (id)sharedInstance;

- (UIImage *)getLargeImageAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage *)getThumbnailImageAtIndexPath:(NSIndexPath*)indexPath;

@end
