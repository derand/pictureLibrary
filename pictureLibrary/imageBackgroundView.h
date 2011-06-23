//
//  imageBackgroundView.h
//  pictureLibrary
//
//  Created by maliy on 6/7/11.
//

#import <UIKit/UIKit.h>


@class imageBackgroundView;
@class pageView;


@protocol imageBackgroundViewDelegate <NSObject>
- (void) imageBackgroundViewSingleTouch:(imageBackgroundView *) ibv;
@end


@interface imageBackgroundView : UIView
{
	UIImage *image;
	
	id<imageBackgroundViewDelegate> delegate;
	
	CGFloat scale;
	BOOL move;
	pageView *parent;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) id<imageBackgroundViewDelegate> delegate;
@property (nonatomic, assign) pageView *parent;

//- (void) setTransformWithoutScaling:(CGAffineTransform) newTransform;

- (CGRect) imageRect;

@end
