//
//  CollectViewController.h
//  flickrlabs
//
//  Created by csjones on 12/7/12.
//  Copyright (c) 2012 csjones. All rights reserved.
//

@class FlickrData;

@interface CollectViewController : UICollectionViewController <UICollectionViewDataSource,UICollectionViewDelegate>
{
    FlickrData  *flickrData;
}

@end