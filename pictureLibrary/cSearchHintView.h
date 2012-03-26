//
//  cSearchHintView.h
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 3/8/12.
//  Copyright (c) 2012 interMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "abstractView.h"

@class cSearchHintView;

@protocol cSearchHintViewDelegate <NSObject>
- (void)searchHintView:(cSearchHintView *)sender selectHint:(id)hint;
@end


@interface cSearchHintView : abstractView <UITableViewDataSource, UITableViewDelegate>
{
	UITableView *tv;
	
	NSArray *hintsList;
	NSMutableArray *showedHintList;
	NSString *filterString;
	
	id<cSearchHintViewDelegate> delegate;
}

@property (nonatomic, retain) NSArray *hintsList;
@property (nonatomic, retain) NSString *filterString;
@property (nonatomic, assign) id<cSearchHintViewDelegate> delegate;

@end
