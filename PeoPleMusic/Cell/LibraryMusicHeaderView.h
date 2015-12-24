//
//  LibraryMusicHeaderView.h
//  PeoPleMusic
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KLibraryMusicHeaderViewHeight  135
@protocol LibraryMusicHeaderViewDelegate;
@interface LibraryMusicHeaderView : UIView

@property (nonatomic, weak)id<LibraryMusicHeaderViewDelegate > delegate;
//+ (LibraryMusicHeaderView *)createLibraryMusiceHeaderView:(UITableView *)tableView withDelegate:(id<LibraryMusicHeaderViewDelegate>)delegate;

@end

@protocol LibraryMusicHeaderViewDelegate <NSObject>



@end
