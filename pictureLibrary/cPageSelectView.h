//
//  cPageSelectView.h
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 8/1/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "abstractView.h"
#import "MultiDialViewController.h"


@class cPageSelectView;

@protocol cPageSelectViewDelegate <NSObject>
- (void) pageSelectView:(cPageSelectView *) psv didSelectPage:(NSInteger) page;
@end


@interface cPageSelectView : abstractView <UIPickerViewDelegate, UIPickerViewDataSource, MultiDialViewControllerDelegate>
{
	UIPickerView *pv;
	MultiDialViewController *mdvc;
	
	id<cPageSelectViewDelegate> delegate;
}

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) id<cPageSelectViewDelegate> delegate;

@end
