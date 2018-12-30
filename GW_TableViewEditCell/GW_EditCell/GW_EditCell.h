//
//  GW_EditCell.h
//  GW_TableViewEditCell
//
//  Created by zdwx on 2018/12/29.
//  Copyright © 2018 DoubleK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GW_EditCell;
NS_ASSUME_NONNULL_BEGIN
//自定义editBtn样式
typedef NS_ENUM(NSInteger, GW_EditCellActionAnimationStyle) {
    GW_EditCellActionAnimationStyleDefault = 0,    // 正常 点击就执行
    GW_EditCellActionAnimationStyleAnimation = 1,  // 动画 点击就执行动画，寻求再次确认 : 注意 Destructive|Default 属性默认执行动画
};

@protocol GW_EditCellDelegate <NSObject>
@optional;

/**
 选中了侧滑按钮
 
 @param editCell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @param index 选中的是第几个action
 */
- (void)editCell:(GW_EditCell *)editCell atIndexPath:(NSIndexPath *)indexPath didSelectedAtIndex:(NSInteger)index;

/**
 告知当前位置的cell是否需要侧滑按钮
 
 @param editCell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @return YES 表示当前cell可以侧滑, NO 不可以
 */
- (BOOL)editCell:(GW_EditCell *)editCell canSwipeRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 返回侧滑事件
 
 @param editCell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @return 数组为空, 则没有侧滑事件
 */
- (nullable NSArray<UIButton *> *)editCell:(GW_EditCell *)editCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface GW_EditItemBtn : UIButton
//动画
@property (assign, nonatomic) GW_EditCellActionAnimationStyle animationStyle;

@end

@interface GW_EditCell : UITableViewCell
//父视图
@property (weak ,nonatomic) UITableView *tableView;
//代理
@property (weak, nonatomic) id <GW_EditCellDelegate>delegate;
//位置
@property (strong ,nonatomic) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
