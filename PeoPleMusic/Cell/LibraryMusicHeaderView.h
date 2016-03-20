//
//  LibraryMusicHeaderView.h
//  PeoPleMusic
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KLibraryMusicHeaderViewHeight  130
@protocol LibraryMusicHeaderViewDelegate;
@interface LibraryMusicHeaderView : UIView

@property (nonatomic, weak)id<LibraryMusicHeaderViewDelegate > delegate;


@end

@protocol LibraryMusicHeaderViewDelegate <NSObject>



@end
