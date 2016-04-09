//
//  KeyBoardView.h
//  Leisure
//
//  Created by 沈强 on 16/4/9.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseView.h"

@class KeyBoardView;
@protocol KeyBoardViewDelegate <NSObject>
/**  键盘输入完成的协议方法 */
-(void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView;
@end

@interface KeyBoardView : BaseView

/** 输入框 */
@property (nonatomic,strong) UITextView *textView;
/** 代理 */
@property (nonatomic,assign) id<KeyBoardViewDelegate> delegate;

@end
