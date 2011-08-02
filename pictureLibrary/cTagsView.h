//
//  tagsView.h
//  Amagami
//
//  Created by Andrey Derevyagin on 7/1/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "abstractView.h"

// cTag should have -[cTag tag] method and this method shoud return nsstring
@class cTag;


@interface cTagsView : UIView <UITableViewDataSource, UITableViewDelegate>
{
	UITableView *tv;
	
	NSArray *tags;
}

@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, readonly) CGSize needSize;

@end
