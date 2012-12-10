//
//  FlickrData.m
//  flickrlabs
//
//  Created by csjones on 12/7/12.
//  Copyright (c) 2012 csjones. All rights reserved.
//

#import "XMLReader.h"
#import "FlickrData.h"
#import "UIImage+Resize.h"

#import <QuartzCore/QuartzCore.h>

@interface FlickrData ()

- (void)getPublicData;
- (id)initWithCollection:(UICollectionView*)collectionView;

@end

@implementation FlickrData

- (id)initWithCollection:(UICollectionView*)collectionView
{
    self = [super init];
    
    if (self)
	{
        _thumbnailDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
        _imageDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
        
        _collectionView = collectionView;
        
		[self getPublicData];
	}
	
	return self;
}

+ (id)sharedInstanceWithCollection:(UICollectionView*)collectionView
{
    static FlickrData *sharedInstance = nil;
	
	if(sharedInstance)
		return sharedInstance;
	
    static dispatch_once_t pred;
	
    dispatch_once(&pred,
				  ^{
					  sharedInstance = [[FlickrData alloc] initWithCollection:collectionView];
				  });
	
    return sharedInstance;
}

- (UIImage *)getLargeImageAtIndexPath:(NSIndexPath*)indexPath
{
    if([_imageDictionary objectForKey:indexPath])
        return [_imageDictionary objectForKey:indexPath];
    
    return nil;
}

- (void)setThumbnailImage:(UIImageView *)imageView atIndexPath:(NSIndexPath*)indexPath
{
    if([_thumbnailDictionary objectForKey:indexPath])
    {
        imageView.image = [_thumbnailDictionary objectForKey:indexPath];
        imageView.layer.shadowOpacity = .7f;
        
        return;
    }

    imageView.image = [UIImage imageNamed:@"picture"];
    imageView.layer.shadowOpacity = .0f;
    
    if(_flickrDictionary)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSInteger   arrayIndex = indexPath.section * 2 + indexPath.row;
            
            NSArray     *picArray = [_flickrDictionary retrieveForPath:[NSString stringWithFormat:@"feed.entry.%i.link",arrayIndex]];
            
            NSString    *travseString = [NSString stringWithFormat:@"feed.entry.%i.link.%i",arrayIndex,picArray.count - 1];
            
            NSString    *urlString = [[_flickrDictionary retrieveForPath:travseString] objectForKey:@"@href"];
            
            NSData      *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            
            CGFloat     viewHeight = [[UIScreen mainScreen] bounds].size.height - 64.0f;
            
            UIImage     *image = [UIImage imageWithData:imageData];
            
            if(![_imageDictionary objectForKey:indexPath])
                [_imageDictionary setObject:[image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                                        bounds:CGSizeMake(320.0f, viewHeight)
                                                          interpolationQuality:kCGInterpolationDefault]
                                     forKey:indexPath];
            else
            {
                UIImage *newerImage = [_imageDictionary objectForKey:indexPath];
                
                newerImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                         bounds:CGSizeMake(320.0f, viewHeight)
                                           interpolationQuality:kCGInterpolationDefault];
            }
            
            UIImage     *thumbnail = [image thumbnailImage:125
                                         transparentBorder:5
                                              cornerRadius:12
                                      interpolationQuality:kCGInterpolationDefault];
            
            if(![_thumbnailDictionary objectForKey:indexPath])
                [_thumbnailDictionary setObject:thumbnail forKey:indexPath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if([[_collectionView indexPathsForVisibleItems] indexOfObject:indexPath] != NSNotFound)
                {
                    imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
                    imageView.layer.shadowOffset = CGSizeMake(0, 0);
                    imageView.layer.shouldRasterize = YES;
                    imageView.layer.shadowOpacity = .7f;
                    imageView.layer.shadowRadius = 7;
                    imageView.alpha = .0f;
                    
                    imageView.image = thumbnail;
                    
                    [UIView animateWithDuration:.2f animations:^{
                        imageView.alpha = 1.0f;
                    }];
                }
            });
        });
    }
}

- (void)getPublicData
{
	NSURL				*theURL = [NSURL URLWithString:@"http://api.flickr.com/services/feeds/photos_public.gne"];
    
	NSMutableURLRequest	*urlRequest = [NSMutableURLRequest requestWithURL:theURL
															  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
														  timeoutInterval:30];
    
	[urlRequest setHTTPMethod:@"GET"];
	[urlRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *returningResponse, NSData *responseData, NSError *returningError){
                               
                               if( [(NSHTTPURLResponse*)returningResponse statusCode] == 200 || !returningError)
                               {
                                   NSError      *xmlError;
                                   
                                   _flickrDictionary = [XMLReader dictionaryForXMLData:responseData error:&xmlError];
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (xmlError)
                                           [[[UIAlertView alloc] initWithTitle:@"Parsing Error"
                                                                       message:@"Cry sad panda does"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil] show];
                                       else
                                           for( unsigned i = 0; i < 5; i++)
                                               [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:i]];
                                   });
                               }
                               else
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [[[UIAlertView alloc] initWithTitle:@"Failed..."
                                                                  message:@"...to play nicely with Flickr"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil] show];
                                   });
                               }
                           }];
}



@end
