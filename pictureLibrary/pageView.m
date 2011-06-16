//
//  imageView.m
//  pictureLibrary
//
//  Created by maliy on 6/4/11.
//

#import "pageView.h"
#import "imageBackgroundView.h"

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
		[self addSubview:ibv];
	}
	return self;
}

- (void) dealloc
{
	[ibv release];
	
	[super dealloc];
}

#pragma mark -

- (void) setFrame:(CGRect) frame
{
	[super setFrame:frame];

	ibv.frame = CGRectMake(0.0, 0.0, MAX(self.contentSize.width, self.bounds.size.width), MAX(self.contentSize.height, self.bounds.size.height));
}

- (void) setImage:(UIImage *) _image
{
	ibv.image = _image;
}

- (UIImage *) image
{
	return ibv.image;
}


#pragma mark UIScrollViewDelegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *) scrollView
{
	return ibv;
//	return iv;
}

/*
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
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
}
*/
 
@end
