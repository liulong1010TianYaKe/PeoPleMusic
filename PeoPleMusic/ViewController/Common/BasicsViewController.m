//
//  BasicsViewController.m
//  KidsBook
//
//  Created by Lukes Lu on 13-9-29.
//  Copyright (c) 2013年 KidsBook Office. All rights reserved.
//

#import "BasicsViewController.h"
#import "AutoScrollView.h"
#import "UIView+OnlyOneTouch.h"

static char kLoadingInNavigationKey;

@interface BasicsViewController ()<UIAlertViewDelegate>

- (UIView *)findTitleView;  //找到当前viewcontroller的titleview
- (void)addObserverWithBarButton;
- (void)removeObserverWithBarButton;

@end

@implementation BasicsViewController

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    KyoLog(@"[%@] dealloc", [self class]);
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeObserverWithBarButton];
    [self.view endEditing:YES];
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserversWithKeyboard];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_ViewControllerWillAppear object:[NSString stringWithFormat:@"%@_%@",self.navigationItem.title,NSStringFromClass([self class])]];
    //手势滑动pop
    [self configInteractivePopGestureRecognizer:YES];
    
    if (self.isBarBugttonCanUserInteractionEnabledWhenAppear) { //是会否把所有barbutton的按钮都设置可以响应
        if (self.navigationItem && self.navigationItem.leftBarButtonItems) {
            for (NSInteger i = 0; i < self.navigationItem.leftBarButtonItems.count; i++) {
                UIBarButtonItem *barButton = self.navigationItem.leftBarButtonItems[i];
                if (barButton.customView && [barButton.customView isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)barButton.customView;
                    btn.userInteractionEnabled = YES;
                }
            }
        }
        if (self.navigationItem && self.navigationItem.rightBarButtonItems) {
            for (NSInteger i = 0; i < self.navigationItem.rightBarButtonItems.count; i++) {
                UIBarButtonItem *barButton = self.navigationItem.rightBarButtonItems[i];
                if (barButton.customView && [barButton.customView isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)barButton.customView;
                    btn.userInteractionEnabled = YES;
                }
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[[[UIApplication sharedApplication] delegate] window] onlyOneTouch];   //唯一点击
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self removeObserversWithKeyboard];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_ViewControllerWillDisappear object:[NSString stringWithFormat:@"%@_%@",self.navigationItem.title,NSStringFromClass([self class])]];
    //手势滑动pop
    [self configInteractivePopGestureRecognizer:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kAppBackgrounpColor;
    
    self.isBarBugttonCanUserInteractionEnabledWhenAppear = YES;
    
    
    [self performSelector:@selector(addObserverWithBarButton) withObject:nil afterDelay:0.0f];
    
    [self setupView];
    [self setupData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark ---------------------
#pragma mark - Settings

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.navigationItem.titleView = nil;
    [self addAutoScrollLabelTitle:title];
}

#pragma mark - Methods/Event

- (void)setupView {}
- (void)setupData {}

- (void)addAutoScrollLabelTitle:(NSString *)title
{
    CGSize size = KyoSizeWithFont(title, [UIFont systemFontOfSize:18]);
    CGFloat width = (size.width + 4) > 200 ? 200 : (size.width + 4);
    AutoScrollView *autoScrollView = [[AutoScrollView alloc] init];
    autoScrollView.backgroundColor = [UIColor clearColor];
    autoScrollView.frame = CGRectMake(0, 0, width, 30);
    autoScrollView.fontSize = 18;
    autoScrollView.color = kNavBarTextColor;
    [autoScrollView setDistance:30];
    autoScrollView.title = title;
    autoScrollView.duration = 10;
    autoScrollView.alignmentType = TextAlignmentTypeCenter;
    
    self.navigationItem.titleView = autoScrollView;

}

- (void)reSetBackButtonMethod:(SEL)method
{
    UIBarButtonItem *leftButton = self.navigationItem.leftBarButtonItem;
    UIButton *btnBack = (UIButton *)leftButton.customView;
    if (!btnBack && self.navigationItem.leftBarButtonItems && self.navigationItem.leftBarButtonItems.count > 0) {
        //下面要注意，当leftBarButtonItems有2个按钮时，只会重置第一个
        for (NSInteger i = 0; i < self.navigationItem.leftBarButtonItems.count; i++) {
            UIBarButtonItem *barButton = self.navigationItem.leftBarButtonItems[i];
            if (barButton.customView && [barButton.customView isKindOfClass:[UIButton class]]) {
                btnBack = (UIButton *)barButton.customView;
                break;
            }
        }
    }
    
    if (btnBack) {
        [btnBack removeTarget:[KyoUtil getCurrentNavigationViewController] action:NSSelectorFromString(@"back") forControlEvents:UIControlEventTouchUpInside];
        [btnBack addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)reSetBackButtonMethod:(SEL)method withTarget:(id)target
{
    UIBarButtonItem *leftButton = self.navigationItem.leftBarButtonItem;
    UIButton *btnBack = (UIButton *)leftButton.customView;
    if (!btnBack && self.navigationItem.leftBarButtonItems && self.navigationItem.leftBarButtonItems.count > 0) {
        //下面要注意，当leftBarButtonItems有2个按钮时，只会重置第一个
        for (NSInteger i = 0; i < self.navigationItem.leftBarButtonItems.count; i++) {
            UIBarButtonItem *barButton = self.navigationItem.leftBarButtonItems[i];
            if (barButton.customView && [barButton.customView isKindOfClass:[UIButton class]]) {
                btnBack = (UIButton *)barButton.customView;
                break;
            }
        }
    }
    
    if (btnBack) {
        [btnBack removeTarget:[KyoUtil getCurrentNavigationViewController] action:NSSelectorFromString(@"back") forControlEvents:UIControlEventTouchUpInside];
        [btnBack addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    }
}

//pop到投保详情界面（如果没有则跳转到列表页再没有则跳到root）
- (void)popToInsureDetailOrListOrRootViewController
{
    id listViewController = nil;
    id detailViewController = nil;
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
        if ([self.navigationController.viewControllers[i] isKindOfClass:NSClassFromString(@"ProductListViewController")]) {
            listViewController = self.navigationController.viewControllers[i];
        } else if ([self.navigationController.viewControllers[i] isKindOfClass:NSClassFromString(@"ProductDetailViewController")]) {
            detailViewController = self.navigationController.viewControllers[i];
        }
    }
    
    if (detailViewController) {
        [self.navigationController popToViewController:detailViewController animated:YES];
    } else if (listViewController) {
        [self.navigationController popToViewController:listViewController animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//根据字符串pop到对应的viewcontroller
- (void)popToViewControllerWithName:(NSString *)viewControllerName
{
    //递归，找到对应的viewcontorller然后跳转
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
        if ([self.navigationController.viewControllers[i] isKindOfClass:NSClassFromString(viewControllerName)]) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[i] animated:YES];
            return;
        }
    }
    
    //找不到，则跳到root
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clearAllTextField:(id)targer
{
    //判断是否是点击到了textfield右边的clear按钮，如果是，则跳出
    UIView *view;
    if ([targer isKindOfClass:[UIGestureRecognizer class]]) {  //如果是单击手势触发的
        view = [((UIGestureRecognizer *)targer) view];
        
        //验证是否是单击了textfield的右边清空按钮触发的，如果是，返回。
        CGPoint point = [((UIGestureRecognizer *)targer) locationOfTouch:0 inView:view];    //得到手势视图的单击坐标
        UIView *subView = [view hitTest:point withEvent:nil];   //得到单击位置的控件
        if (subView) {  //如果单击位置有控件
            
            //如果单击位置的控件有父视图，且父视图是textField，说明是单击了textfield右边的清空按钮触发的，返回
            if (subView.superview && [subView.superview isKindOfClass:[UITextField class]]) {
                return;
            }
        }
        
    }
    
//    [[KyoUtil rootViewController].view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *) notification
{
    KyoLog(@"%@",self.view);
    UIView *focusView = [KyoUtil findFocusInputView:self.view];
    if (focusView) {
        NSInteger navigationHeight = (self.navigationController && self.navigationController.navigationBar.translucent == NO) ? 64 : 0;
        CGPoint focusPoint = [self.view convertPoint:CGPointZero fromView:focusView];
        CGFloat mustY =  focusPoint.y + focusView.bounds.size.height + 25 - navigationHeight; //64是navigation，下面的也一样
        CGRect keyboardRect = CGRectZero;
        if (notification) {
            keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            self.currentKeyBoradRect = keyboardRect;
        } else {
            keyboardRect = self.currentKeyBoradRect;
        }
        float keyBoardHeight = keyboardRect.size.height;
        
        if (mustY > self.view.bounds.size.height - keyBoardHeight - navigationHeight || self.view.frame.origin.y < 0) {
            CGFloat diff = (self.view.bounds.size.height-keyBoardHeight)-mustY;
            if (diff > 0) {
                diff = 0;
            }
            KyoLog(@"%f",diff);
            [UIView animateWithDuration:0.25f
                             animations:^{
                                 self.view.frame = CGRectMake(self.view.frame.origin.x, diff, self.view.bounds.size.width, self.view.bounds.size.height);
                             } completion:^(BOOL finished) {
                             }];
        }
    } else {
        if (notification) {
            self.currentKeyBoradRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        }
    }
}

- (CGFloat)getFocusViewY:(UIView *)focusView withDiff:(CGFloat)diff
{
    if (focusView.superview == self.view) {
        return focusView.frame.origin.y+diff;
    }else{
        return [self getFocusViewY:focusView.superview withDiff:diff+focusView.frame.origin.y];
    }
}

- (void) keyboardWillHide:(NSNotification *) notification
{
    [UIView animateWithDuration:0.2f animations:^{
        NSInteger navigationHeight = (self.navigationController && self.navigationController.navigationBar.translucent == NO) ? 64 : 0;
         self.view.frame = CGRectMake(self.view.frame.origin.x, navigationHeight, self.view.frame.size.width, self.view.frame.size.height);
    }];
    self.currentKeyBoradRect = CGRectZero;
}

- (void)addObserversWithKeyboard
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserversWithKeyboard
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//改变pagecontrol中圆点样式
- (void)changePageControlImage:(UIPageControl *)pageControl
{
    UIImage *imgCurrent = [[UIImage imageNamed:@"pc_normal_selected"] shrinkImageWithSize:CGSizeMake(8, 8)];
    UIImage *imgOther = [[UIImage imageNamed:@"pc_normal"] shrinkImageWithSize:CGSizeMake(8, 8)];
    
    if (kSystemVersionMoreThan7) {
        [pageControl setValue:imgCurrent forKey:@"_currentPageImage"];
        [pageControl setValue:imgOther forKey:@"_pageImage"];
    } else {
        for (int i = 0;i < pageControl.numberOfPages; i++) {
            UIImageView *imgv = [pageControl.subviews objectAtIndex:i];
            imgv.frame = CGRectMake(imgv.frame.origin.x, imgv.frame.origin.y, 20, 20);
            imgv.image = pageControl.currentPage == i ? imgCurrent : imgOther;
        }
    }
}

//设置viewcontroller的滑动返回是否为空
- (void)configInteractivePopGestureRecognizer:(BOOL)isNotNil
{
    if (kSystemVersionMoreThan7) {  //手势滑动pop
//        self.navigationController.interactivePopGestureRecognizer.delegate = isNotNil ? [[KyoUtil getCurrentNavigationViewController] viewControllers][0] : nil;
    }
}

//清空指定网络请求
- (void)clearOperation:(AFHTTPRequestOperation *)operation {
    if (operation && !operation.isFinished) {
        [operation cancel];
    }
    
    operation = nil;
}

- (void)addObserverWithBarButton
{
    [self.navigationItem addObserver:self forKeyPath:@"leftBarButtonItems" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self.navigationItem addObserver:self forKeyPath:@"rightBarButtonItems" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self.navigationItem addObserver:self forKeyPath:@"leftBarButtonItem" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self.navigationItem addObserver:self forKeyPath:@"rightBarButtonItem" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserverWithBarButton
{
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(addObserverWithBarButton) object:nil];
    
    @try {
        [self.navigationItem removeObserver:self forKeyPath:@"leftBarButtonItems"];
    }
    @catch (NSException *exception) {
        NSLog(@"removeobserver异常：%@",exception.reason);
    }
    @finally {
    }
    
    @try {
        [self.navigationItem removeObserver:self forKeyPath:@"rightBarButtonItems"];
    }
    @catch (NSException *exception) {
        NSLog(@"removeobserver异常：%@",exception.reason);
    }
    @finally {
    }
    
    @try {
        [self.navigationItem removeObserver:self forKeyPath:@"leftBarButtonItem"];
    }
    @catch (NSException *exception) {
        NSLog(@"removeobserver异常：%@",exception.reason);
    }
    @finally {
    }
    
    @try {
        [self.navigationItem removeObserver:self forKeyPath:@"rightBarButtonItem"];
    }
    @catch (NSException *exception) {
        NSLog(@"removeobserver异常：%@",exception.reason);
    }
    @finally {
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark - MBProgressHUD

- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime
{
    [KyoUtil showMessageHUD:messageText withTimeInterval:delayTime inView:self.view];
}

- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view
{
    [KyoUtil showMessageHUD:messageText withTimeInterval:delayTime inView:view];
}

- (void)showLoadingHUD:(NSString *)labelTextOrNil
{
    [self showLoadingHUD:labelTextOrNil inView:self.view userInteractionEnabled:YES];
}

- (void)showLoadingHUD:(NSString *)labelTextOrNil inView:(UIView *)view userInteractionEnabled:(BOOL)userInteractionEnabled
{
    [KyoUtil showLoadingHUD:labelTextOrNil inView:view withDelegate:self userInteractionEnabled:userInteractionEnabled];
}

- (void)hideLoadingHUD:(NSTimeInterval)afterTime withView:(UIView *)view
{
    [KyoUtil hideLoadingHUD:afterTime withView:view];
}

- (void)hideLoadingHUD
{
    [self hideLoadingHUD:0 withView:self.view];
}

- (void)showLoadingInNavigation {
    if (!self.navigationController && !self.parentViewController.navigationController) {
        [self showLoadingHUD:nil];
        return;
    }
    
    UIBarButtonItem *barActivity = (UIBarButtonItem *)objc_getAssociatedObject(self, &kLoadingInNavigationKey);
    if (!barActivity) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.hidesWhenStopped = YES;
        activityIndicatorView.center = self.navigationController.navigationBar.center;
        barActivity = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
        
        objc_setAssociatedObject(self, &kLoadingInNavigationKey, barActivity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [(UIActivityIndicatorView *)barActivity.customView startAnimating];
    
    //如果leftbar的最后一项是菊花，直接返回了
    if (self.navigationItem.leftBarButtonItems &&
        self.navigationItem.leftBarButtonItems > 0 &&
        [self.navigationItem.leftBarButtonItems lastObject] == barActivity) {
        return;
    }
    
    //找到navigation的titleview，设置菊花
    NSInteger discante = 6;
    NSInteger currentLeft = 0;  //当前leftbarbuttons的宽度
    if (self.navigationItem.leftBarButtonItems && self.navigationItem.leftBarButtonItems > 0) {
        UIBarButtonItem *barButtonItem = [self.navigationItem.leftBarButtonItems lastObject];
        if (barButtonItem.customView) {
            currentLeft = (barButtonItem.customView.x > 0 ? barButtonItem.customView.x : 11) + barButtonItem.customView.width;
        }
    }
    
    //得到titleview
    UIView *titleView = [self findTitleView];
    //得到title的x坐标
    
    NSDictionary *dictTitleTextAttributes = [UINavigationBar appearance].titleTextAttributes;
    UIFont *titleFont = dictTitleTextAttributes[NSFontAttributeName] ? dictTitleTextAttributes[NSFontAttributeName] : [UIFont boldSystemFontOfSize:18.0f];
    NSInteger titleWidth = (KyoSizeWithFont(self.title, titleFont)).width;
    NSInteger titleX = kWindowWidth/2 - titleWidth/2;
    titleX = titleX < titleView.x ? titleX : titleView.x;
    if (titleView) {
        if (currentLeft + 20 + discante < titleX) {  //如果左边宽度＋菊花宽度＋间距还是没超过titileview的x，则可以设置分割线
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
            space.width = titleX - (currentLeft + 20 + discante);
            NSMutableArray *arrayLeftButton = [self.navigationItem.leftBarButtonItems mutableCopy];
            [arrayLeftButton addObject:space];
            [arrayLeftButton addObject:barActivity];
            self.navigationItem.leftBarButtonItems = arrayLeftButton;
        } else if (currentLeft + 20 + discante == titleX) { //如果刚好等于这个距离，则直接添加菊花，不添加分割线
            NSMutableArray *arrayLeftButton = [self.navigationItem.leftBarButtonItems mutableCopy];
            [arrayLeftButton addObject:barActivity];
            self.navigationItem.leftBarButtonItems = arrayLeftButton;
        } else {    //反之就超过了距离，用正常load
            [self showLoadingHUD:nil];
        }
    } else {
        [self showLoadingHUD:nil];
    }
}

- (void)hideLoadingInNavigation {
    UIBarButtonItem *barActivity = (UIBarButtonItem *)objc_getAssociatedObject(self, &kLoadingInNavigationKey);
    if (barActivity && barActivity.customView) {
        [(UIActivityIndicatorView *)barActivity.customView stopAnimating];
        [self hideLoadingHUD];
    } else {
        [self hideLoadingHUD];
    }
}

- (UIView *)findTitleView {
    for (UIView *subView in self.navigationController.navigationBar.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UINavigationItemView"] ||
            (CGRectContainsPoint(subView.frame, CGPointMake(self.navigationController.navigationBar.bounds.size.width / 2, self.navigationController.navigationBar.bounds.size.height / 2)) && subView.x > 0 && subView.width <= 200)) {  //titleView
            return subView;
        }
    }
    
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark ----------------------------------
#pragma mark - KVO/KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    KyoLog(@"%@",keyPath);
    [[[[UIApplication sharedApplication] delegate] window] onlyOneTouch];
}

@end
