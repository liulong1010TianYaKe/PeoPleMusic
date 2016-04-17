//
// Created by azu on 2013/08/28.
//


#import <Foundation/Foundation.h>

@class AutoScrollTextView;

@protocol AutoScrollDelegate
@optional
- (void)willBeginScroll:(AutoScrollTextView *)scrollTextView;
- (void)didEndScroll:(AutoScrollTextView *)scrollTextView;
@end

@interface AutoScrollTextView : UITextView{
}
@property(nonatomic) CGFloat scrollingIncrement;
@property(nonatomic) CGFloat scrollingInterval;

@property(nonatomic, strong) NSObject <AutoScrollDelegate>* scrollingDelegate;

- (void)startAutoScroll;
- (void)stopAutoScroll;

- (BOOL)isScrolling;
@end