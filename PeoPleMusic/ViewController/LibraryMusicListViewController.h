//
//  LibraryMusicListViewController.h
//  PeoPleMusic
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "BasicsTableViewController.h"

@interface LibraryMusicListViewController : BasicsTableViewController
+ (LibraryMusicListViewController *)createLibraryMusicListViewController;
@property (nonatomic, strong) NSString *urlString;
@end
