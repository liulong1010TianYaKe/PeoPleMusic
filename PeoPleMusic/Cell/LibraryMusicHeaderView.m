//
//  LibraryMusicHeaderView.m
//  PeoPleMusic
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "LibraryMusicHeaderView.h"


@interface LibraryMusicHeaderView ()
@property (weak, nonatomic) IBOutlet UISearchBar *searBar;

//@property (weak, nonatomic) IBOutlet UITextField *txtInput;
- (IBAction)btnLoadTouchInside:(id)sender;

- (IBAction)btnSpeakerTouchInside:(id)sender;
@end
@implementation LibraryMusicHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
//    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
//    leftView.bounds = CGRectMake(0, 0, 30, 30);
//    self.txtInput.leftView =leftView;
//    self.txtInput.leftViewMode = UITextFieldViewModeAlways;
//    self.backgroundColor = [UIColor clearColor];
}


//+ (LibraryMusicHeaderView *)createLibraryMusiceHeaderView:(UITableView *)tableView withDelegate:(id<LibraryMusicHeaderViewDelegate>)delegate{
//    tableView.bounds = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
//    LibraryMusicHeaderView *libView =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LibraryMusicHeaderView class]) owner:tableView options:nil] firstObject];
//    libView.delegate = delegate;
//}

// 本地下载
- (IBAction)btnLoadTouchInside:(id)sender {
}

// 音响本地
- (IBAction)btnSpeakerTouchInside:(id)sender {
}
@end
