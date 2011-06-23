//
//  imageView.m
//  pictureLibrary
//
//  Created by maliy on 6/4/11.
//

#import "pageView.h"
#import "imageBackgroundView.h"


@interface pageView ()
- (BOOL) equalZoom:(CGFloat) zoom;
@end



@implementation pageView
@synthesize ibv;
@synthesize pageIdx;

#pragma mark lifeCycle

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.minimumZoomScale = 1.0;
		self.maximumZoomScale = 100.0;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
		self.delegate = self;
		self.clearsContextBeforeDrawing = NO;
		self.showsVerticalScrollIndicator = YES;
		self.showsHorizontalScrollIndicator = YES;
		self.scrollsToTop = NO;
		self.delegate = self;
		
		rScale = previousScale = 1.0;
		
		ibv = [[imageBackgroundView alloc] initWithFrame:self.bounds];
		ibv.parent = self;
		[self addSubview:ibv];
		
		zoomedPiece = [[UIView alloc] initWithFrame:CGRectMake(50.0, 50.0, 100.0, 100.0)];
		zoomedPiece.alpha = 0.0;
		zoomedPiece.backgroundColor = [UIColor yellowColor];
		[self addSubview:zoomedPiece];
	}
	return self;
}

- (void) dealloc
{
	[zoomedPiece release];
	[ibv release];
	
	[super dealloc];
}

#pragma mark -

- (void) setFrame:(CGRect) frame
{
	[super setFrame:frame];
	self.zoomScale = 1.0;

//	ibv.frame = CGRectMake(0.0, 0.0, MAX(self.contentSize.width, self.bounds.size.width), MAX(self.contentSize.height, self.bounds.size.height));
	ibv.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
}

- (void) setImage:(UIImage *) _image
{
	self.zoomScale = 1.0;
	
	ibv.image = _image;
}

- (UIImage *) image
{
	return ibv.image;
}

- (void) waitDecelerate
{
	[self scrollViewDidEndDragging:self willDecelerate:self.decelerating];
}

- (BOOL) equalZoom:(CGFloat) zoom
{
	return fabs(self.zoomScale-zoom)<.03;
}


#pragma mark UIScrollViewDelegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *) scrollView
{
	return ibv;
}

- (void) scrollViewDidEndDragging:(UIScrollView *) scrollView willDecelerate:(BOOL) decelerate
{
	
	if (decelerate)
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(wait) object:nil];
		[self performSelector:@selector(waitDecelerate) withObject:nil afterDelay:.05];
	}
	else
	{
		CGRect rct = ibv.frame;
		rct.origin = scrollView.contentOffset;
		rct.size = scrollView.bounds.size;
		NSLog(@"need reDraw %fx%f, %fx%f", rct.origin.x, rct.origin.y, rct.size.width, rct.size.height);
//		[ibv setNeedsDisplayInRect:rct];
	}
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *) view atScale:(float) scale
{
	ibv.scale = scale;
//	return ;
/*	
	[ibv setTransformWithoutScaling:CGAffineTransformIdentity];

	CGSize sz = scrollView.bounds.size; 
	rScale = previousScale*scale;
	ibv.frame = CGRectMake(0.0,
						   0.0,
						   sz.width*rScale,
						   sz.height*rScale);
	scrollView.contentSize = ibv.frame.size;
	
	CGFloat z = rScale/previousScale;
	ibv.scale = z;
	

	scrollView.minimumZoomScale /= z;
	scrollView.maximumZoomScale /= z;
	
	ibv.scale = 1.0;
	previousScale = rScale;
	NSLog(@"scale:%.4f rscale:%.4f minScale:%.4f maxScale:%.4f", scale, rScale, scrollView.minimumZoomScale, scrollView.maximumZoomScale);
*/
	[self scrollViewDidEndDragging:scrollView willDecelerate:NO];

}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView
{
	CGRect rct = [ibv imageRect];
	UIEdgeInsets edgeInset = UIEdgeInsetsZero;
	if (rct.size.width*self.zoomScale>self.bounds.size.width)
	{
		edgeInset.left = -rct.origin.x*self.zoomScale;
		edgeInset.right = edgeInset.left;
	}
	if (rct.size.height*self.zoomScale>self.bounds.size.height)
	{
		edgeInset.top = -rct.origin.y*self.zoomScale;
		edgeInset.bottom = edgeInset.top;
	}
	
	self.contentInset = edgeInset;
}

 
@end
