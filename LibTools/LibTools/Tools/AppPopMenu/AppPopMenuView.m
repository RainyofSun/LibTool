//
//  AppPopMenuView.m
//  LibTools
//
//  Created by 刘冉 on 2018/7/6.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import "AppPopMenuView.h"

#define kMainWindow  [UIApplication sharedApplication].keyWindow

@interface UIView (LRFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;

@end


@implementation UIView (LRFrame)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end

@interface LRTabCell : UITableViewCell

/** title */
@property (nonatomic,strong) UILabel *titleLab;

@end

@implementation LRTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
}

- (void)setUI {
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.backgroundColor = [UIColor clearColor];
    }
    return _titleLab;
}

@end

static NSString *cellIdentifier = @"menuCell";

@interface AppPopMenuView()<UITableViewDelegate,UITableViewDataSource>

/** replayViewBounds */
@property (nonatomic,assign) CGRect replayViewRect;
/** cellHeight */
@property (nonatomic,assign) CGFloat cellHeight;
/** cornerRadius */
@property (nonatomic,assign) CGFloat kCornerRadius;
/** viewAlpha */
@property (nonatomic,assign) CGFloat viewAlpha;
/** contentView */
@property (nonatomic,strong) UIView *contentView;
/** bgView */
@property (nonatomic,strong) UIView *bgView;
/** tableView */
@property (nonatomic,strong) UITableView *titleTab;
/** titleSource */
@property (nonatomic,strong) NSMutableArray *titleSource;

@end

@implementation AppPopMenuView

+ (instancetype)showWithReplayView:(UIView *)replayView titles:(NSArray *)title menuWidth:(CGFloat)menuW delegate:(id<AppPopMenuViewDelegate>)delegate {
    AppPopMenuView *menuView = [[AppPopMenuView alloc] initWithReplayView:replayView titles:title menuWidth:menuW delegate:delegate];
    [menuView showReplayOnView:replayView];
    return menuView;
}

- (instancetype)initWithReplayView:(UIView *)replayView titles:(NSArray *)titleSource menuWidth:(CGFloat)width delegate:(id<AppPopMenuViewDelegate>)delegate{
    if (self = [super init]) {
        [self.titleSource addObjectsFromArray:titleSource];
        if (delegate) self.delegate = delegate;
        [self setData];
        [self setupUI:width];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LRTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.titleLab.text = self.titleSource[indexPath.row];
    cell.titleLab.font = [UIFont systemFontOfSize:self.fontSize];
    cell.titleLab.textColor = self.textColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(lrPopupMenuDidSelectedAtIndex:lrPopupMenu:)]) {
        [self dismiss];
        [self.delegate lrPopupMenuDidSelectedAtIndex:indexPath.row lrPopupMenu:self];
    }
}

- (void)dismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lrPopupMenuBeganDismiss)]) {
        [self.delegate lrPopupMenuBeganDismiss];
    }
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lrPopupMenuDidDismiss)]) {
            [self.delegate lrPopupMenuDidDismiss];
        }
        self.delegate = nil;
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

- (void)showReplayOnView:(UIView *)view {
    CGRect absoluteRect = [view convertRect:view.bounds toView:kMainWindow];
    self.x = absoluteRect.origin.x;
    self.y = absoluteRect.origin.y + absoluteRect.size.height + 3;
    [self show];
}

- (void)show {
    [kMainWindow addSubview:self.bgView];
    [kMainWindow addSubview:self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self.bgView.alpha = 1;
    }];
}

- (UITableViewCell *)getLastVisibleCell {
    NSArray <NSIndexPath *>*indexPaths = [self.titleTab indexPathsForVisibleRows];
    indexPaths = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
        return obj1.row < obj2.row;
    }];
    NSIndexPath *indexPath = indexPaths.firstObject;
    return [self.titleTab cellForRowAtIndexPath:indexPath];
}

#pragma mark - 私有方法
- (void)setData {
    
    self.cellHeight = 44.0f;
    self.fontSize   = 15.0f;
    self.textColor  = [UIColor blackColor];
    self.viewAlpha  = 0.5;
}

- (void)setupUI:(CGFloat)width {
    
    self.alpha                  = 0;
    self.layer.shadowOpacity    = 0.5;
    self.layer.shadowOffset     = CGSizeMake(0, 0);
    self.layer.shadowRadius     = 2.0;
    self.width                  = width;
    self.height                 = self.titleSource.count > 5 ? 5 * self.cellHeight : self.titleSource.count * self.cellHeight;
    
    self.contentView            = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.backgroundColor    = [[UIColor whiteColor] colorWithAlphaComponent:self.viewAlpha];
    self.contentView.layer.cornerRadius = self.kCornerRadius;
    self.contentView.layer.masksToBounds= YES;
    
    self.titleTab               = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    self.titleTab.delegate      = self;
    self.titleTab.dataSource    = self;
    self.titleTab.backgroundColor = [UIColor clearColor];
    self.titleTab.bounces       = self.titleSource.count > 5 ? YES : NO;
    self.titleTab.tableFooterView = [UIView new];
    self.titleTab.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.titleTab.centerY       = self.contentView.centerY;
    [self.titleTab registerClass:[LRTabCell class] forCellReuseIdentifier:cellIdentifier];
    
    self.bgView                 = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.bgView.alpha           = 0;
    
    [self.contentView addSubview:self.titleTab];
    [self addSubview:self.contentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismiss)];
    [self.bgView addGestureRecognizer: tap];
}

#pragma mark - setter
- (NSMutableArray *)titleSource {
    if (!_titleSource) {
        _titleSource = [NSMutableArray array];
    }
    return _titleSource;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.titleTab reloadData];
    });
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.titleTab reloadData];
    });
}

- (void)setIsShowShadow:(BOOL)isShowShadow {
    _isShowShadow = isShowShadow;
    if (!isShowShadow) {
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0.0;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius       = cornerRadius;
    self.kCornerRadius  = cornerRadius;
}

- (void)setBgViewAlpha:(CGFloat)bgViewAlpha {
    _bgViewAlpha        = bgViewAlpha;
    self.viewAlpha      = bgViewAlpha;
}

@end
