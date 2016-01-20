//
//  PlayListView.m
//  PeoPleMusic
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "PlayListView.h"
#import "PlayListCell.h"


@interface PlayListView ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)btnCancelTouchInside:(id)sender;
@end
@implementation PlayListView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecoginzer:)];
    [self addGestureRecognizer:tapGR];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PlayListCell class]) bundle:nil] forCellReuseIdentifier:KPlayListCellIdentify];
    
}
+ (instancetype)createPlayListViewFromWindow{
    
    PlayListView *playListView = [[[NSBundle mainBundle] loadNibNamed:@"PlayListView" owner:self options:nil] firstObject];
    
    
    return playListView;
}
- (void)tapGestureRecoginzer:(UITapGestureRecognizer *)GR{
    [self close];
}

- (void)show{
    
    if (self == nil) {
        return;
    }
    self.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    }];
    
    
}

- (void)close{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (IBAction)btnCancelTouchInside:(id)sender {
    
    [self close];
}

#pragma mark -- 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:KPlayListCellIdentify];
    __weak typeof(self)weekSelf = self;
    cell.cancelOperationBlock = ^{
        [weekSelf close];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KPlayListCelllHeight;
}
@end
