//
//  picturesViewController.h
//  pictureLibrary
//
//  Created by maliy on 6/4/11.
//

#import <UIKit/UIKit.h>
#import "imageBackgroundView.h"


@class picturesViewController;

@protocol picturesViewControllerDelegate <NSObject>
- (NSInteger) picturesViewControllerPicturesCount:(picturesViewController *) sender;
@optional
- (UIImage *) picturesViewController:(picturesViewController *) sender imageById:(NSInteger) idx;
- (void) picturesViewController:(picturesViewController *) sender changeImageTo:(NSInteger) idx;
@end


@interface picturesViewController : UIViewController <UIScrollViewDelegate, imageBackgroundViewDelegate>
{
	id<picturesViewControllerDelegate> delegate;
	
	UIScrollView *pagesView;
	NSMutableArray *pages;
	
	NSInteger index;
	NSInteger prewIndex;
	NSInteger count;
	BOOL infinitiCount;
	
	NSInteger pagesWindow;
	NSInteger pageStart;
	NSInteger pageEnd;
	
	UIBarStyle savedBarStyle;
	UIStatusBarStyle savedStatusBarStyle;
	BOOL showed;
}

@property (nonatomic, assign) id<picturesViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger pagesWindow;

- (void) reloadData;
- (void) setIndex:(NSInteger) _index animated:(BOOL) animated;
- (void) setImage:(UIImage *) _image forIndex:(NSInteger) idx;

@end
