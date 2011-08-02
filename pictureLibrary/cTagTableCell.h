//
//  tagTableCell.h
//  Amagami
//
//  Created by Andrey Derevyagin on 7/1/11.
//  Copyright 2011 interMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cTagTableCell : UITableViewCell
{
	UILabel *nameLabel;
}

@property (nonatomic, retain) NSString *tagName;

+ (CGSize) sizeForTag:(NSString *) tag;

- (id) initWithReuseIdentifier:(NSString *) reuseIdentifier;



@end
