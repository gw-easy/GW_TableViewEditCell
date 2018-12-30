//
//  GW_EditCell.m
//  GW_TableViewEditCell
//
//  Created by zdwx on 2018/12/29.
//  Copyright © 2018 DoubleK. All rights reserved.
//

#import "GW_EditCell.h"

@implementation GW_EditItemBtn

@end

typedef NS_ENUM(NSInteger, GW_EditCellState) {
    GW_EditCellStateNormal = 0,
    GW_EditCellStateAnimating,
    GW_EditCellStateOpen
};
@interface GW_EditCell ()
//按钮array
@property (strong ,nonatomic) NSArray *btnArrs;
//cell的滑动手势
@property (strong ,nonatomic) UIPanGestureRecognizer *cellPanGR;
//tableViewd滑动手势
@property (strong ,nonatomic) UIPanGestureRecognizer *tbPanGR;
//按钮view
@property (strong ,nonatomic) UIView *btnEditView;
//是否是展开
@property (nonatomic, assign) BOOL cellEditOpen;
//cell的编辑状态
@property (nonatomic, assign) GW_EditCellState state;
//所有按钮的宽
@property (assign, nonatomic) CGFloat allBtnWidth;
@end

@implementation GW_EditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupEditCell];
    }
    return self;
}

- (void)setupEditCell {
    _cellPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewPan:)];
    _cellPanGR.delegate = self;
    [self.contentView addGestureRecognizer:_cellPanGR];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

//cellj滑动事件
- (void)contentViewPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    UIGestureRecognizerState state = pan.state;
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.contentView.frame;
        frame.origin.x += point.x;
        if (frame.origin.x > 5) {
            frame.origin.x = 5;
        } else if (frame.origin.x < -30 - _btnEditView.frame.size.width) {
            frame.origin.x = -30 - _btnEditView.frame.size.width;
        }
        self.contentView.frame = frame;
        
    } else if (state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [pan velocityInView:pan.view];
        if (self.contentView.frame.origin.x == 0) {
            return;
        } else if (self.contentView.frame.origin.x > 5) {
            [self hiddenWithBounceAnimation];
        } else if (fabs(self.contentView.frame.origin.x) >= 40 && velocity.x <= 0) {
            [self showEditView];
        } else {
            [self hiddenEditView:YES];
        }
        
    } else if (state == UIGestureRecognizerStateCancelled) {
        [self hiddenAllSideslip];
    }
}

- (void)hiddenAllSideslip {
    for (GW_EditCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:GW_EditCell.class]) {
            [cell hiddenEditView:NO];
        }
    }
}

#pragma mark - Methods
- (void)hiddenWithBounceAnimation {
    self.state = GW_EditCellStateAnimating;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setContentViewX:-10];
    } completion:^(BOOL finished) {
        [self hiddenEditView:YES];
    }];
}

//隐藏编辑页面
- (void)hiddenEditView:(BOOL)animate {
    if (self.contentView.frame.origin.x == 0){
        self.cellEditOpen = NO;
        self.state = GW_EditCellStateNormal;
        return;
    }
    self.state = GW_EditCellStateAnimating;
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:(animate?0.2:0) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setContentViewX:0];
    } completion:^(BOOL finished) {
        [weakSelf.btnEditView removeFromSuperview];
        weakSelf.btnEditView = nil;
        self.state = GW_EditCellStateNormal;
        self.cellEditOpen = NO;
    }];
}

//显示编辑页面
- (void)showEditView{
    self.state = GW_EditCellStateAnimating;
    self.cellEditOpen = YES;
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setContentViewX:-weakSelf.btnEditView.frame.size.width];
    } completion:^(BOOL finished) {
        self.state = GW_EditCellStateOpen;
    }];
}

//tableview滑动事件
- (void)tableViewPan:(UIPanGestureRecognizer *)pan {
    if (_cellEditOpen && pan.state == UIGestureRecognizerStateBegan) {
        [self hiddenAllSideslip];
    }
}

//设置contentView的x
- (void)setContentViewX:(CGFloat)x {
    CGRect frame = self.contentView.frame;
    frame.origin.x = x;
    self.contentView.frame = frame;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _cellPanGR) {

        if (!_cellEditOpen) {
            [self hiddenAllSideslip];
        }
        
        UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [gesture translationInView:gesture.view];
        
        // 如果手势相对于水平方向的角度大于45°, 则不触发侧滑
        BOOL shouldBegin = fabs(translation.y) <= fabs(translation.x);
        if (!shouldBegin) return NO;
        
        // 询问代理是否需要侧滑
        if ([_delegate respondsToSelector:@selector(editCell:canSwipeRowAtIndexPath:)]) {
            shouldBegin = [_delegate editCell:self canSwipeRowAtIndexPath:self.indexPath] || _cellEditOpen;
        }
        
        if (shouldBegin) {
            // 向代理获取侧滑展示内容数组
            if ([_delegate respondsToSelector:@selector(editCell:editActionsForRowAtIndexPath:)]) {
                NSArray *actions = [_delegate editCell:self editActionsForRowAtIndexPath:self.indexPath];
                if (!actions || actions.count == 0) return NO;
                self.btnArrs = actions;
            } else {
                return NO;
            }
        }
        return shouldBegin;
    } else if (gestureRecognizer == _tbPanGR) {
        if (self.tableView.scrollEnabled) {
            return NO;
        }
    }
    return YES;
}

//editBtn点击事件 可以自定义扩展
- (void)actionBtnDidClicked:(UIButton *)btn {
    
    if ([btn isKindOfClass:[GW_EditItemBtn class]]) {
        GW_EditItemBtn *editBtn = (GW_EditItemBtn *)btn;
        if (editBtn.animationStyle == GW_EditCellStateAnimating) {
            if (_btnArrs.count == 1) {
                [self showEditView];
            }else{
                CGFloat width = _btnEditView.frame.size.width;
                btn.frame = CGRectMake(0, 0, width, self.frame.size.height);
                for (UIButton *button in _btnEditView.subviews) {
                    if (button.tag != btn.tag) {
                        [button removeFromSuperview];
                    }
                }
                [self showEditView];
            }
        }
    }else{
        [self actionBtnDidClickToDule:btn.tag];
    }
}

- (void)actionBtnDidClickToDule:(NSInteger)tag {
    if ([self.delegate respondsToSelector:@selector(editCell:atIndexPath:didSelectedAtIndex:)]) {
        [self.delegate editCell:self atIndexPath:self.indexPath didSelectedAtIndex:tag];
    }
    [self hiddenAllSideslip];
    self.state = GW_EditCellStateNormal;
}

-(void)layoutSubviews{
    CGFloat x = 0;
    if (_cellEditOpen) x = self.contentView.frame.origin.x;
    [super layoutSubviews];
    
    // 侧滑状态旋转屏幕时, 保持侧滑
    if (_cellEditOpen){
       [self setContentViewX:x];
    }
    
    CGRect frame = self.contentView.frame;
    frame.size.width = self.bounds.size.width;
    self.contentView.frame = frame;
    _btnEditView.frame = CGRectMake(self.frame.size.width-_allBtnWidth, 0, _allBtnWidth, self.frame.size.height);
}



#pragma mark - Setter
- (void)setTableView:(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = tableView;
        [_tableView.panGestureRecognizer addTarget:self action:@selector(tableViewPan:)];
        return;
    }
    
}



//设置editView界面
- (void)setBtnArrs:(NSArray *)btnArrs{
    _btnArrs = btnArrs;
    if (_btnEditView) {
        return;
    }
    _btnEditView = [UIView new];
    [self insertSubview:_btnEditView belowSubview:self.contentView];
    _allBtnWidth = 0;
    for (int i = 0; i < btnArrs.count; i++) {
        UIButton *btn = btnArrs[i];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(actionBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _allBtnWidth += btn.frame.size.width;
        [_btnEditView addSubview:btn];
    }
    
    _btnEditView.frame = CGRectMake(self.frame.size.width-_allBtnWidth, 0, _allBtnWidth, self.frame.size.height);
}
@end
