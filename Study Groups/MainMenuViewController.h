//
//  MainMenuViewController.h
//  Study Groups
//
//  Created by Nicholas Gordon on 6/2/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuCell.h"

@interface MainMenuViewController : UICollectionViewController
@property (strong, nonatomic) NSArray *myImageArray;
@property (strong, nonatomic) NSArray *myDescriptionArray;

@end
