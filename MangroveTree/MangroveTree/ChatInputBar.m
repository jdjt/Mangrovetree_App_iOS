//
//  ChatInputBar.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/13.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChatInputBar.h"
#import "PureLayout.h"

//背景颜色
#define kBkColor               ([UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1])

//输入框最小高度
#define kMinHeightTextView          (34)

//输入框最大高度
#define kMaxHeightTextView   (84)

//默认输入框和父控件底部间隔
#define kDefaultBottomTextView_SupView  (5)

#define kDefaultTopTextView_SupView  (5)

//按钮大小
#define kSizeBtn                 (CGSizeMake(34*2, 34))


@interface ChatInputBar ()<UITextViewDelegate>

@property (nonatomic, assign) NSLayoutConstraint *mBottomConstraintTextView;// TextView和自己底部约束，会被动态增加、删除
@property (nonatomic, assign) NSLayoutConstraint *mBottomConstraintWithSupView; // 自己和父控件 底部约束，使用这个约束让自己伴随键盘移动
@property (nonatomic, assign) CGFloat mHeightTextView;  // TextView的高度
@property(nonatomic,strong)UITextView *mInputTextView;  // 输入TextView
@property(nonatomic,strong)UIButton   *mSendBtn;        // 发送按钮

@end

@implementation ChatInputBar

#pragma mark - Override System Method

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _mHeightTextView = kMinHeightTextView; //默认设置输入框最小高度
        
        // 增加输入框
        [self addInputView];

        // 增加更多按钮
        [self addSendButton];

        
        // 监听键盘显示、隐藏变化，让自己伴随键盘移动
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout

//获取自己和父控件底部约束，控制该约束可以让自己伴随键盘移动
-(void)updateConstraints
{
    [super updateConstraints];
    
    
    if (!_mBottomConstraintWithSupView)
    {
        NSArray *constraints = self.superview.constraints;
        
        for (int index= (int)constraints.count-1; index>0; index--)
        {//从末尾开始查找
            NSLayoutConstraint *constraint = constraints[index];
            
            if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondAttribute == NSLayoutAttributeBottom)
            {//获取自己和父控件底部约束
                _mBottomConstraintWithSupView = constraint;
                
                break;
            }
        }
    }
    
}

-(CGSize)intrinsicContentSize
{
    CGFloat height = _mHeightTextView+kDefaultBottomTextView_SupView +kDefaultTopTextView_SupView;
    
//    height += [_mMoreView intrinsicContentSize].height; //如果更多视图当前正在显示，需要加上更多视图的高度
//    
//    height += [_mFaceView intrinsicContentSize].height; //如果表情视图当前正在显示，需要加上他的的高度
    
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

#pragma mark - KeyBoard Noti

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    
    if (notification.name == UIKeyboardWillShowNotification)
    {
        _mBottomConstraintWithSupView.constant = -(keyboardEndFrame.size.height);
    }else
    {
        _mBottomConstraintWithSupView.constant = 0;
    }
    
    [self.superview layoutIfNeeded];
    
    
    [UIView commitAnimations];
}

#pragma mark - Button Click

- (void)sendMsgBtnClick:(UIButton *)button
{
    if(_mInputTextView.text == nil ||[_mInputTextView.text isEqualToString:@""]|| [_mInputTextView.text isEqualToString:@"请输入您需要的服务内容"])
        return;
    if ([self.delegate respondsToSelector:@selector(sendMsgByChatBarView:)])
    {
        [self.delegate sendMsgByChatBarView:_mInputTextView.text];
        _mInputTextView.text = @"";//清空输入框
        [self textViewDidChange:_mInputTextView];
    }
}

#pragma mark - Getter Method

-(UITextView *)mInputTextView
{
    if (!_mInputTextView)
    {
        _mInputTextView = [[UITextView alloc]initForAutoLayout];
        
        _mInputTextView.delegate = self;
        _mInputTextView.layer.cornerRadius = 4;
        _mInputTextView.layer.masksToBounds = YES;
        _mInputTextView.layer.borderWidth = 1;
        _mInputTextView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _mInputTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 4.0f);
        _mInputTextView.contentInset = UIEdgeInsetsZero;
        _mInputTextView.scrollEnabled = NO;
        _mInputTextView.scrollsToTop = NO;
        _mInputTextView.userInteractionEnabled = YES;
        _mInputTextView.font = [UIFont systemFontOfSize:14];
        _mInputTextView.textColor = [UIColor blackColor];
        _mInputTextView.backgroundColor = [UIColor whiteColor];
        _mInputTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
        _mInputTextView.keyboardType = UIKeyboardTypeDefault;
        _mInputTextView.returnKeyType = UIReturnKeySend;
        _mInputTextView.textAlignment = NSTextAlignmentLeft;
        _mInputTextView.text = @"请输入您需要的服务内容";
        _mInputTextView.textColor = [UIColor darkGrayColor];
    }
    return _mInputTextView;
}
- (UIButton *)mSendBtn
{
    if (!_mSendBtn)
    {
        _mSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mSendBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_mSendBtn addTarget:self action:@selector(sendMsgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _mSendBtn.backgroundColor = [UIColor colorWithHexString:@"#ed8256"];
        _mSendBtn.clipsToBounds = YES;
        _mSendBtn.layer.cornerRadius = 4.0f;
        [_mSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_mSendBtn autoSetDimensionsToSize:kSizeBtn];

    }
    return _mSendBtn;

}
- (void)addSendButton
{
    [self addSubview:self.mSendBtn];
    [self.mSendBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    [self.mSendBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:5];
    [self.mSendBtn  autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.mInputTextView withOffset:5];
}

- (void)addInputView
{
    [self addSubview:self.mInputTextView];
    [self.mInputTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kDefaultTopTextView_SupView];
    [self.mInputTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8];
    _mBottomConstraintTextView = [self.mInputTextView  autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kDefaultBottomTextView_SupView];
}

#pragma mark -TextView Delegate

//输入框获取输入焦点后，隐藏其他视图
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _mInputTextView.textColor = [UIColor blackColor];
    _mInputTextView.text = @"";
}

//判断用户是否点击了键盘发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {//点击了发送按钮
        
        if (![textView.text isEqualToString:@""])
        {
            //输入框当前有数据才需要发送
            
            if ([self.delegate respondsToSelector:@selector(sendMsgByChatBarView:)])
            {
                [self.delegate sendMsgByChatBarView:textView.text];
            }
            textView.text = @"";//清空输入框
            [self textViewDidChange:textView];
        }
        return NO;
    }
    
    return YES;
}

//根据输入文字多少，自动调整输入框的高度
-(void)textViewDidChange:(UITextView *)textView
{
    //计算输入框最小高度
    CGSize size =  [textView sizeThatFits:CGSizeMake(textView.contentSize.width, 0)];
    
    CGFloat contentHeight;
    
    //输入框的高度不能超过最大高度
    if (size.height > kMaxHeightTextView)
    {
        contentHeight = kMaxHeightTextView;
        textView.scrollEnabled = YES;
    }else
    {
        contentHeight = size.height;
        textView.scrollEnabled = NO;
    }

    if (_mHeightTextView != contentHeight)
    {//如果当前高度需要调整，就调整，避免多做无用功
        _mHeightTextView = contentHeight ;//重新设置自己的高度
        [self invalidateIntrinsicContentSize];
    }
}
- (void)inPutViewresignFirstResponder
{
    [self.mInputTextView resignFirstResponder];
    [self.mInputTextView setText:@""];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
