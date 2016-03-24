//
//  KyoKeyboardReturnKeyHandler.m
//  MainApp
//
//  Created by Kyo on 8/3/16.
//  Copyright © 2016 hzins. All rights reserved.
//

#import "KyoKeyboardReturnKeyHandler.h"
#import <objc/runtime.h>
#import <objc/message.h>


NSString *const kKyoTextFieldDelegate        =   @"kIQTextFieldDelegate";    /**< 跟IQKeyboardReturnKeyHandler中一样 */

@interface KyoKeyboardReturnKeyHandler()<UITextFieldDelegate, UITextViewDelegate>

- (id<UITextFieldDelegate>)getOriginalTextFieldDelegate:(UITextField *)textField;   /**< 得到原始设置的delegate（没用returnkeyhandler之前设置的delegate） */

- (id<UITextViewDelegate>)getOriginalTextViewDelegate:(UITextView *)textView; /**< 得到原始设置的delegate（没用returnkeyhandler之前设置的delegate） */


@end

@implementation KyoKeyboardReturnKeyHandler

#pragma mark --------------------
#pragma mark - Methods

/**< 得到原始设置的delegate（没用returnkeyhandler之前设置的delegate） */
- (id<UITextFieldDelegate>)getOriginalTextFieldDelegate:(UITextField *)textField {
    if (![self respondsToSelector:NSSelectorFromString(@"textFieldCachedInfo:")]) return nil;
    
    NSDictionary * (*p)(id,SEL,UITextField *);
    p = (NSDictionary * (*)(id,SEL,UITextField *))[self methodForSelector:NSSelectorFromString(@"textFieldCachedInfo:")];
    NSDictionary *dict = p(self, NSSelectorFromString(@"textFieldCachedInfo:"), textField);
    
    return dict && [dict objectForKey:kKyoTextFieldDelegate] ? [dict objectForKey:kKyoTextFieldDelegate] : nil;
}

- (id<UITextViewDelegate>)getOriginalTextViewDelegate:(UITextView *)textView{
    if (![self respondsToSelector:NSSelectorFromString(@"textFieldCachedInfo:")]) {
        return nil;
    }
    
    NSDictionary * (*p)(id, SEL, UITextView *);
    p = (NSDictionary * (*)(id ,SEL, UITextView *))[self methodForSelector:NSSelectorFromString(@"textFieldCachedInfo:")];
    
    NSDictionary *dict = p(self, NSSelectorFromString(@"textFieldCachedInfo:"),textView);
     return dict && [dict objectForKey:kKyoTextFieldDelegate] ? [dict objectForKey:kKyoTextFieldDelegate] : nil;
    
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-conversion"



#pragma mark --------------------
#pragma mark - TextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL result = YES;
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        BOOL (*superaction)(struct objc_super *super, SEL, UITextField *) = (BOOL (*)(struct objc_super *super, SEL, UITextField *)) objc_msgSendSuper;
        result = superaction(&superclass, _cmd, textField);
//        result = objc_msgSendSuper(&superclass, _cmd, textField);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:textField];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        
        BOOL (*action)(id  self,SEL, UITextField *) = (BOOL (*)(id self, SEL, UITextField *)) objc_msgSend;
        result = action(originalTextFieldDelegate, _cmd, textField);
        //        result = objc_msgSend(originalTextFieldDelegate, _cmd, textField);
    }
    
    return result;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        void (*superaction)(struct objc_super *super, SEL, UITextField *) = (void (*)(struct objc_super *super, SEL, UITextField *)) objc_msgSendSuper;
        superaction(&superclass, _cmd, textField);
//        objc_msgSendSuper(&superclass, _cmd, textField);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:textField];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        
        void (*action)(id self, SEL, UITextField *) = (void (*)(id self, SEL, UITextField *))objc_msgSend;
        action(originalTextFieldDelegate, _cmd, textField);
        //        objc_msgSend(originalTextFieldDelegate, _cmd, textField);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    BOOL result = YES;
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        BOOL (*superaction)(struct objc_super *super, SEL, UITextField *) = (BOOL (*)(struct objc_super *super, SEL, UITextField *)) objc_msgSendSuper;
        result = superaction(&superclass, _cmd, textField);
//        result = objc_msgSendSuper(&superclass, _cmd, textField);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:textField];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        BOOL (*action)(id  self,SEL, UITextField *) = (BOOL (*)(id self, SEL, UITextField *)) objc_msgSend;
        result = action(originalTextFieldDelegate, _cmd, textField);
//        result = objc_msgSend(originalTextFieldDelegate, _cmd, textField);
    }
    
    return result;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        
        void (*superAction)(struct objc_super *super, SEL, UITextField *) = (void (*)(struct objc_super *super, SEL, UITextField *)) objc_msgSendSuper;
        superAction(&superclass, _cmd, textField);
//        objc_msgSendSuper(&superclass, _cmd, textField);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:textField];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        void (*action)(id self, SEL, UITextField *) = (void (*)(id self, SEL, UITextField *))objc_msgSend;
        action(originalTextFieldDelegate, _cmd, textField);
//        objc_msgSend(originalTextFieldDelegate, _cmd, textField);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL result = YES;
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        BOOL (*superaction)(struct objc_super *super, SEL, UITextField *,NSRange ,NSString *) = (BOOL (*)(struct objc_super *super, SEL, UITextField *,NSRange ,NSString *)) objc_msgSendSuper;
         result =  superaction(&superclass, _cmd, textField,range, string);
        
//        result = objc_msgSendSuper(&superclass, _cmd, textField, range, string);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:textField];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        
        BOOL (*action)(id  self,SEL, UITextField *,NSRange , NSString *) = (BOOL (*)(id self, SEL, UITextField *,NSRange, NSString *)) objc_msgSend;
        result = action(originalTextFieldDelegate, _cmd, textField,range,string);
//        result = objc_msgSend(originalTextFieldDelegate, _cmd, textField, range, string);
    }
    
    return result;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    BOOL result = YES;
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        BOOL (*superAction)(struct objc_super *super, SEL, UITextField *) = (BOOL (*)(struct objc_super *super, SEL, UITextField *)) objc_msgSendSuper;
        result = superAction(&superclass, _cmd, textField);
//        result = objc_msgSendSuper(&superclass, _cmd, textField);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:textField];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        
        BOOL (*action)(id, SEL, UITextField*) = (BOOL (*)(id, SEL, UITextField *)) objc_msgSend;
//        result = objc_msgSend(originalTextFieldDelegate, _cmd, textField);
        result = action(originalTextFieldDelegate, _cmd, textField);
    }
    
    return result;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL result = YES;
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        BOOL (*superAction)(struct objc_super *super, SEL, UITextField *) = (BOOL (*)(struct objc_super *super, SEL, UITextField *)) objc_msgSendSuper;
        result = superAction(&superclass, _cmd, textField);
//        result = objc_msgSendSuper(&superclass, _cmd, textField);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:textField];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        BOOL (*action)(id, SEL, UITextField*) = (BOOL (*)(id, SEL, UITextField *)) objc_msgSend;
         result = action(originalTextFieldDelegate, _cmd, textField);
//        result = objc_msgSend(originalTextFieldDelegate, _cmd, textField);
    }
    
    return result;
}

#pragma mark --------------------
#pragma mark - TextView delegate


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL result = YES;
    
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        BOOL (*superAction)(struct objc_super *super, SEL, UITextView *) = (BOOL (*)(struct objc_super *super, SEL, UITextView *)) objc_msgSendSuper;
        result = superAction(&superclass, _cmd, textView);
        
//        result = objc_msgSendSuper(&superclass, _cmd, textView);
    }
    
   NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:(UITextField *)textView];
    
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        
        BOOL (*action)(id, SEL, UITextView *) = (BOOL (*)(id, SEL, UITextView *))objc_msgSend;
        result = action(originalTextFieldDelegate, _cmd, textView);
//        result = objc_msgSend(originalTextFieldDelegate, _cmd, textView);
    }
    
    
    return result;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    BOOL result = YES;
    
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        
        BOOL (*superAction)(struct objc_super *super, SEL, UITextView *) = (BOOL (*)(struct objc_super *super, SEL, UITextView *)) objc_msgSendSuper;
        result = superAction(&superclass, _cmd, textView);
//        result = objc_msgSendSuper(&superclass, _cmd, textView);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:(UITextField *)textView];
    
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        BOOL (*action)(id, SEL, UITextView *) = (BOOL (*)(id, SEL, UITextView *))objc_msgSend;
        result = action(originalTextFieldDelegate, _cmd, textView);
//        result = objc_msgSend(originalTextFieldDelegate, _cmd, textView);
    }
    
    
    return result;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        
        void (*superAction)(struct objc_super *, SEL, UITextView *) = (void (*)(struct objc_super *, SEL, UITextView *))objc_msgSendSuper;
        superAction(&superclass, _cmd, textView);
//        objc_msgSendSuper(&superclass, _cmd, textView);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:(UITextField *)textView];
//    NSObject<UITextViewDelegate> *originalTextViewDelegate = (NSObject <UITextViewDelegate> *)[self getOriginalTextViewDelegate:textView];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        
        void (*action) (id,SEL, UITextView *) = (void (*)(id, SEL, UITextView *))objc_msgSend;
        action(originalTextFieldDelegate, _cmd, textView);
//        objc_msgSend(originalTextFieldDelegate, _cmd, textView);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        void (*superAction)(struct objc_super *, SEL, UITextView *) = (void (*)(struct objc_super *, SEL, UITextView *))objc_msgSendSuper;
        superAction(&superclass, _cmd, textView);
//        objc_msgSendSuper(&superclass, _cmd, textView);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:(UITextField *)textView];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        void (*action) (id,SEL, UITextView *) = (void (*)(id, SEL, UITextView *))objc_msgSend;
        action(originalTextFieldDelegate, _cmd, textView);
//        objc_msgSend(originalTextFieldDelegate, _cmd, textView);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL result = YES;
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        BOOL (*superAction)(struct objc_super *, SEL, UITextView *,NSRange, NSString*) = (BOOL (*)(struct objc_super *, SEL, UITextView *,NSRange, NSString*))objc_msgSendSuper;
        superAction(&superclass, _cmd, textView,range, text);
//        result = objc_msgSendSuper(&superclass, _cmd, textView, range, text);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:(UITextField *)textView];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        
        BOOL (*action)(id, SEL, UITextView*, NSRange, NSString*) = (BOOL (*)(id, SEL, UITextView *,NSRange, NSString*))objc_msgSend;
       result =  action(originalTextFieldDelegate, _cmd, textView, range, text);
//        result = objc_msgSend(originalTextFieldDelegate, _cmd, textView, range, text);
    }
    
    return result;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        void (*superAction)(struct objc_super *, SEL, UITextView *) = (void (*)(struct objc_super *, SEL, UITextView *))objc_msgSendSuper;
        superAction(&superclass, _cmd, textView);
//        objc_msgSendSuper(&superclass, _cmd, textView);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:(UITextField *)textView];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        void (*action) (id,SEL, UITextView *) = (void (*)(id, SEL, UITextView *))objc_msgSend;
        action(originalTextFieldDelegate, _cmd, textView);
//        objc_msgSend(originalTextFieldDelegate, _cmd, textView);
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        void (*superAction)(struct objc_super *, SEL, UITextView *) = (void (*)(struct objc_super *, SEL, UITextView *))objc_msgSendSuper;
        superAction(&superclass, _cmd, textView);
//        objc_msgSendSuper(&superclass, _cmd, textView);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:(UITextField *)textView];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        void (*action) (id,SEL, UITextView *) = (void (*)(id, SEL, UITextView *))objc_msgSend;
        action(originalTextFieldDelegate, _cmd, textView);
//        objc_msgSend(originalTextFieldDelegate, _cmd, textView);
    }
}

//#ifdef NSFoundationVersionNumber_iOS_6_1

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    BOOL result = YES;
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        
        BOOL (*superAction)(struct objc_super *, SEL, UITextView *, NSURL* ,NSRange) = (BOOL (*)(struct objc_super *, SEL, UITextView *,NSURL* ,NSRange))objc_msgSendSuper;
        result =superAction(&superclass, _cmd, textView,URL, characterRange);
//        result = objc_msgSendSuper(&superclass, _cmd, textView, URL, characterRange);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:(UITextField *)textView];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        
        BOOL (*action)(id, SEL, UITextView*, NSURL*, NSRange) = (BOOL (*)(id, SEL, UITextView *,NSURL*, NSRange))objc_msgSend;
       result =  action(originalTextFieldDelegate, _cmd, textView, URL, characterRange);
//        result = objc_msgSend(originalTextFieldDelegate, _cmd, textView, URL,characterRange);
    }
    
    return result;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    BOOL result = YES;
    if ([super respondsToSelector:_cmd]) {
        struct objc_super superclass = { .receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
        BOOL (*superAction)(struct objc_super *, SEL, UITextView *, NSTextAttachment* ,NSRange) = (BOOL (*)(struct objc_super *, SEL, UITextView *,NSTextAttachment* ,NSRange))objc_msgSendSuper;
        result =superAction(&superclass, _cmd, textView,textAttachment, characterRange);
//        result = objc_msgSendSuper(&superclass, _cmd, textView, textAttachment, characterRange);
    }
    
    NSObject<UITextFieldDelegate> *originalTextFieldDelegate  = (NSObject <UITextFieldDelegate> *)[self getOriginalTextFieldDelegate:(UITextField *)textView];
    if ([originalTextFieldDelegate respondsToSelector:_cmd]) {
        BOOL (*action)(id, SEL, UITextView*, NSTextAttachment*, NSRange) = (BOOL (*)(id, SEL, UITextView *,NSTextAttachment*, NSRange))objc_msgSend;
        result =  action(originalTextFieldDelegate, _cmd, textView, textAttachment, characterRange);
//        result = objc_msgSend(originalTextFieldDelegate, _cmd, textView, textAttachment,characterRange);
    }
    
    return result;
}



//#pragma clang diagnostic pop

@end