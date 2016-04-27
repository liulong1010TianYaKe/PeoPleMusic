//
//  KyoDataTipsModel.m
//  MainApp
//
//  Created by Kyo on 19/10/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import "KyoDataTipsModel.h"

@interface KyoDataTipsModel()

- (void)setupData;

@end

@implementation KyoDataTipsModel

#pragma mark --------------------
#pragma mark - CycLife

- (id)init {
    self = [super init];
    
    if (self) {
        [self setupData];
    }
    
    return self;
}

#pragma mark --------------------
#pragma mark - Methods

- (void)setupData {
    _buttonTextColor = [UIColor whiteColor];
    _buttonTextSize = 15;
    _operationButtonTop = 16;
    _operationButtonWidth = [[[UIApplication sharedApplication] delegate] window].bounds.size.width - 32;
    _operationButtonHeight = 44;
    _yScale = 1.0/1.0;
    _img = [UIImage imageNamed:@"com_tipsView_logo"];
    _imgOperationButtonNormal = [[UIImage imageNamed:@"button_249_47_58"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    _imgOperationButtonHighight = [[UIImage imageNamed:@"button_249_47_58_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
}


@end
