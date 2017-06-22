//
//  FlowLayout.h
//  customTitleView
//
//  Created by BlueK on 17/6/8.
//  Copyright © 2017年 BlueK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlowLayout;

@protocol FlowLayoutDelegate <NSObject>
/**
 *  subView的总数
 *
 *  @param flowLayout
 *
 *  @return <#return value description#>
 */
-(NSInteger)numberOfSectionsInFlowLayout:(FlowLayout *)flowLayout;
/**
 *  获取指定的subView
 *
 *  @param flowLayout
 *  @param index      角标，第几个
 *  @param itemView   subView不存在则为nil,FlowLayout暂时并不提供复用View，仅在调用changeItemAtIndex方法时，该值不为nil
 *
 *  @return 要显示的subView
 */
-(UIView *)flowLayout:(FlowLayout *) flowLayout viewAtIndex:(NSInteger) index itemView:(UIView*) itemView;

@end

@interface FlowLayout : UIView

@property (nonatomic,weak) id<FlowLayoutDelegate> delegate;
/**
 每一行对应view的数组
 */
@property (nonatomic,strong,readonly) NSMutableArray *rowList;
/**
 *  每一行的高度
 */
@property (nonatomic,strong,readonly) NSMutableArray *rowHightList;
/**
 *  view之间的横行间距
 */
@property (nonatomic,assign) CGFloat horizontalSpace;
/**
 *  每行的间距
 */
@property (nonatomic,assign) CGFloat verticalSpace;
/**
 *  subView数组
 */
@property (nonatomic,strong,readonly) NSMutableArray *subViewList;

/**
 *  是否固定配置的高度
 */
@property(nonatomic,assign) bool fastenHeight;
/**
 *最后一个显示的View的角标,-1则表示没有
 */
@property(nonatomic,assign,readonly) int lastShowIndex;

/**
 *  显示的最大行数
 */
@property(nonatomic,assign) int maxLine;


/**
 *  重新加载数据，该方法会删除所有item，重新调用［flowLayout:(FlowLayout *) flowLayout viewAtIndex:(NSInteger) index itemView:(UIView*) itemView］方法加载
    如没有设置delegate，该方法无效
 */
-(void)reloadData;

/**
 *  删除指定第几个item
 如没有设置delegate，该方法无效
 *
 *  @param index <#index description#>
 */
-(void)removeItemAtIndex:(NSInteger) index;

/**
 *  改变第几个item的属性，该方法会调用［flowLayout:(FlowLayout *) flowLayout viewAtIndex:(NSInteger) index itemView:(UIView*) itemView］方法
 如没有设置delegate，该方法无效
 *
 *  @param index <#index description#>
 */
-(void)changeItemAtIndex:(NSInteger) index;

/**
 *  指定位置插入item，该方法会调用［flowLayout:(FlowLayout *) flowLayout viewAtIndex:(NSInteger) index itemView:(UIView*) itemView］方法
 如没有设置delegate，该方法无效
 *
 *  @param index <#index description#>
 */
-(void)insertItemAtIndex:(NSInteger) index;

/**
 *  @param buttonList 按钮数组
 *
 *  @return CFFlowButtonView对象
 */
- (instancetype)initWithSubViewList:(NSMutableArray *)subViewList;


@end
