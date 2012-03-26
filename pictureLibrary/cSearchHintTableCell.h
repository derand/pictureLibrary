//
//  cSearchHintTableCell.h
//  pictureLibrary
//
//  Created by Andrey Derevyagin on 3/8/12.
//  Copyright (c) 2012 interMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cSearchHintTableCell : UITableViewCell
{
	UILabel *nameLabel;
}

@property (nonatomic, retain) NSString *hint;

+ (CGSize) sizeForHint:(NSString *) hint;

- (id) initWithReuseIdentifier:(NSString *) reuseIdentifier;


@end
