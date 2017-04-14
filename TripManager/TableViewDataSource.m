//
//  TableViewDataSource.m
//  TripManager
//
//  Created by 何家瑋 on 2017/3/8.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "TableViewDataSource.h"

@interface TableViewDataSource ()
{
        NSString * _cellIdentifier;
        NSString * _tableViewHeaderTitle;
        NSIndexPath * _selectCellIndexPath;
        
        CADisplayLink * _displayLink;
}

@property (nonatomic) UIView * selectCellView;

@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@property (nonatomic) UIGestureRecognizer * longPressGesture;
@property (nonatomic) UITableView * longPressTableView;

@end

@implementation TableViewDataSource

#pragma mark - public method
- (instancetype)initWithDataModel:(DataModel *)dataModel CellIdentifier:(NSString *)identifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
{
        self = [super init];
        
        if (self)
        {
                _dataModel = dataModel;
                _cellIdentifier = identifier;
                _configureCellBlock = configureCellBlock;
        }
        
        return self;
}

- (id)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [_dataModel dataForRowAtIndexPath:indexPath];
}

- (BOOL)isContainThisData:(DataItem *)item
{
        for (NSInteger i = 0; i < _dataModel.dataArray.count; i++)
        {
                NSArray * sectionArray = _dataModel.dataArray[i];
                
                for (DataItem * dataItem in sectionArray)
                {
                        if ([dataItem.Id isEqualToString:item.Id])
                        {
                                return YES;
                        }
                }
        }
        
        return NO;
}

#pragma mark - update method
- (void)updateTableView:(UITableView *)tableView cellOrderFromGesture:(UIGestureRecognizer *)gesture
{
        switch (gesture.state) {
                case UIGestureRecognizerStateBegan:
                        [self tableView:tableView longPressBegan:gesture];
                        break;
                case UIGestureRecognizerStateChanged:
                        break;
                case UIGestureRecognizerStateEnded:
                        [self tableView:tableView longPressEnd:gesture];
                        break;
                default:
                        break;
        }
}

#pragma mark update to new dataModel
- (void)updateTableView:(UITableView *)tableView fromNewDataModel:(DataModel *)newDataModel
{
        _dataModel = newDataModel;
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
        });
}

#pragma mark update now dataModel
- (void)insertTableView:(UITableView *)tableView newDataItem:(DataItem *)newItem
{
        NSInteger section = [_dataModel numberOfSection] - 1;
        
        [_dataModel insertData:newItem To:section];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
        });
}

- (void)updateTableView:(UITableView *)tableView newDataItem:(DataItem *)newItem atIndexPath:(NSIndexPath *)indexPath
{
        [_dataModel updateData:newItem To:indexPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
        });
}

- (DataItem *)deleteTableView:(UITableView *)tableView dataItemAtIndexPath:(NSIndexPath *)indexPath
{
        DataItem * deleteItem = [_dataModel deleteDataAtIndexPath:indexPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
        });
        
        return deleteItem;
}

#pragma mark - gesture operation
- (void)tableView:(UITableView *)tableView longPressBegan:(UIGestureRecognizer *)gesture
{
        CGPoint touchPoint = [gesture locationInView:gesture.view];
        _selectCellIndexPath = [tableView indexPathForRowAtPoint:touchPoint];
        UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:_selectCellIndexPath];
        
        _selectCellView = [UIView snapshotViewWithInputView:selectCell];
        _selectCellView.layer.shadowColor = [UIColor grayColor].CGColor;
        _selectCellView.layer.shadowOffset = CGSizeMake(-5, 0);
        _selectCellView.layer.shadowOpacity = 0.4;
        _selectCellView.layer.shadowRadius = 5;
        _selectCellView.layer.masksToBounds = NO;
        _selectCellView.layer.cornerRadius = 0;
        _selectCellView.frame = selectCell.frame;
        [tableView addSubview:_selectCellView];
        
        selectCell.hidden = YES;
        
        [UIView animateWithDuration:1.0 animations:^{
                _selectCellView.center = CGPointMake(selectCell.center.x, touchPoint.y);
        }];
        
        _longPressGesture = gesture;
        _longPressTableView = tableView;
        
        [self registCADisplay];
}

- (void)tableView:(UITableView *)tableView longPressChange:(UIGestureRecognizer *)gesture
{
        CGPoint touchPoint = [gesture locationInView:gesture.view];
        NSIndexPath * touchIndexPath = [tableView indexPathForRowAtPoint:touchPoint];

        if (touchIndexPath && ![touchIndexPath isEqual:_selectCellIndexPath])
        {
                [tableView beginUpdates];
                
                [_dataModel updateDataOrderFrom:_selectCellIndexPath to:touchIndexPath];
                [tableView moveRowAtIndexPath:_selectCellIndexPath toIndexPath:touchIndexPath];
                [tableView moveRowAtIndexPath:touchIndexPath toIndexPath:_selectCellIndexPath];
                
                [tableView endUpdates];
                
                _selectCellIndexPath = touchIndexPath;
        }
        
        _selectCellView.center = CGPointMake(_selectCellView.center.x, touchPoint.y);
}

- (void)edgeScrollTableView
{
        CGFloat edgeScrollOffset = 20.0;
        CGFloat boundDetectOffset = 150.0;
        CGFloat tableViewContentOffsetY = _longPressTableView.contentOffset.y + 64;
        CGFloat viewMinY = tableViewContentOffsetY + boundDetectOffset;
        CGFloat viewMaxY = tableViewContentOffsetY + _longPressTableView.bounds.size.height - boundDetectOffset;
        CGFloat touchPointY = _selectCellView.center.y;
        
//        NSLog(@"---------------------------------");
//        NSLog(@"contentOffset : %f", tableViewContentOffsetY);
//        NSLog(@"minY : %f", viewMinY);
//        NSLog(@"maxY : %f", viewMaxY);
//        NSLog(@"touchPointY : %f", touchPointY);
//        NSLog(@"contentHeight : %f", _longPressTableView.contentSize.height);
//        NSLog(@"bounds height : %f", _longPressTableView.bounds.size.height);
//        NSLog(@"---------------------------------");
        
        [self tableView:_longPressTableView longPressChange:_longPressGesture];
        
        //the top
        if (touchPointY < boundDetectOffset)
        {
                if (_longPressTableView.contentOffset.y + 64 <= 0)
                {
                        // already show the top cell
                        return;
                }
                else
                {
                        [_longPressTableView setContentOffset:CGPointMake(_longPressTableView.contentOffset.x, _longPressTableView.contentOffset.y - 1) animated:NO];
                        _selectCellView.center = CGPointMake(_selectCellView.center.x, _selectCellView.center.y - 1);
                }
        }
        
        //the bottom
        if (touchPointY > _longPressTableView.contentSize.height  - boundDetectOffset)
        {
                if (_longPressTableView.contentOffset.y >= _longPressTableView.contentSize.height - _longPressTableView.bounds.size.height)
                {
                        // if the real contentOffset.y greater than tableView.contentSize.height - tableView.bounds.size.height, means you are already move to the bottm cell
                        return;
                }
                else
                {
                        [_longPressTableView setContentOffset:CGPointMake(_longPressTableView.contentOffset.x, _longPressTableView.contentOffset.y + 1) animated:NO];
                        _selectCellView.center = CGPointMake(_selectCellView.center.x, _selectCellView.center.y + 1);
                }
        }
        
        if (touchPointY < viewMinY)
        {
                // scroll to top
                CGFloat moveDistance = (viewMinY - touchPointY) / boundDetectOffset * edgeScrollOffset;
                [_longPressTableView setContentOffset:CGPointMake(_longPressTableView.contentOffset.x, _longPressTableView.contentOffset.y - moveDistance) animated:NO];
                _selectCellView.center = CGPointMake(_selectCellView.center.x, _selectCellView.center.y - edgeScrollOffset);
        }
        else if (touchPointY > viewMaxY)
        {
                // scroll to bottom
                CGFloat moveDistance = (touchPointY - viewMaxY) / boundDetectOffset * edgeScrollOffset;
                [_longPressTableView setContentOffset:CGPointMake(_longPressTableView.contentOffset.x, _longPressTableView.contentOffset.y + moveDistance) animated:NO];
                _selectCellView.center = CGPointMake(_selectCellView.center.x, _selectCellView.center.y + edgeScrollOffset);
        }
}

- (void)tableView:(UITableView *)tableView longPressEnd:(UIGestureRecognizer *)gesture
{
        UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:_selectCellIndexPath];
        
        [UIView animateWithDuration:0.8 animations:^{
                _selectCellView.frame = selectCell.frame;
        } completion:^(BOOL finished) {
                selectCell.hidden = NO;
                [_selectCellView removeFromSuperview];
                _selectCellView = nil;
        }];
        
        _longPressGesture = nil;
        _longPressTableView = nil;
        [self stopCADisplay];
}

- (void)registCADisplay
{
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(edgeScrollTableView)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopCADisplay
{
        if (_displayLink)
        {
                [_displayLink invalidate];
                _displayLink = nil;
        }
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return [_dataModel numberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [_dataModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
        
        DataItem * item = [_dataModel dataForRowAtIndexPath:indexPath];
        
        self.configureCellBlock(cell, item);
        
        return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        if ([_delegate respondsToSelector:@selector(TableViewDataSource:canEditRowAtIndexPath:)])
        {
                return [_delegate TableViewDataSource:self canEditRowAtIndexPath:indexPath];
        }
        else
        {
                return NO;
        }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        DataItem * deleteItem = [self deleteTableView:tableView dataItemAtIndexPath:indexPath];
        
        [_delegate TableViewDataSource:self commitEditingStyle:editingStyle forDataItem:deleteItem];
}

@end
