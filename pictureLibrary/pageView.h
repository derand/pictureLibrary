//
//  imageView.h
//  pictureLibrary
//
//  Created by maliy on 6/4/11.
//

#import <UIKit/UIKit.h>

@class imageBackgroundView;

@interface pageView : UIScrollView <UIScrollViewDelegate>
{
	imageBackgroundView *ibv;
	UIView *zoomedPiece;
	
	CGFloat rScale;
	CGFloat previousScale;

	NSInteger pageIdx;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, readonly) imageBackgroundView *ibv;
@property (nonatomic, assign) NSInteger pageIdx;

@end
