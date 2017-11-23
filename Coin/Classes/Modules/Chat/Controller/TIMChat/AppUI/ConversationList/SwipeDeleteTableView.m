//
//  SwipeDeleteTableView.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//
#import "SwipeDeleteTableView.h"
#import <objc/runtime.h>



@interface UIButton (NSIndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPath;

@end

@implementation UIButton (NSIndexPath)

const static CGFloat kDeleteButtonWidth = 80.f;
const static CGFloat kDeleteButtonHeight = 44.f;

const static char * kSwipeDeleteTableViewCellIndexPathKey = "SwipeDeleteTableViewCellIndexPathKey";

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, kSwipeDeleteTableViewCellIndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath
{
    id obj = objc_getAssociatedObject(self, kSwipeDeleteTableViewCellIndexPathKey);
    if([obj isKindOfClass:[NSIndexPath class]])
    {
        return (NSIndexPath *)obj;
    }
    return nil;
}

@end

@interface SwipeDeleteTableView()
{
    UISwipeGestureRecognizer    *_leftSwipe;
    UISwipeGestureRecognizer    *_rightSwipe;
    UITapGestureRecognizer      *_tapGesture;
    
    UIButton                    *_deleteButton;
    NSIndexPath                 *_editingIndexPath;
}

@end

@implementation SwipeDeleteTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        _leftSwipe.delegate = self;
        [self addGestureRecognizer:_leftSwipe];

        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        _rightSwipe.delegate = self;
        _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_rightSwipe];

        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _tapGesture.delegate = self;
        // Don't add this yet

        _deleteButton = [MenuButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(kMainScreenWidth, 0, kDeleteButtonWidth, kDeleteButtonHeight);
        _deleteButton.backgroundColor = [UIColor redColor];
        _deleteButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];

        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (void)swiped:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSIndexPath * indexPath = [self cellIndexPathForGestureRecognizer:gestureRecognizer];
    if(indexPath == nil)
    {
        return;
    }
    
    if (_editingIndexPath)
    {
        [self tapped:_tapGesture];
        return;

        
    }
    
    if(![self.dataSource tableView:self canEditRowAtIndexPath:indexPath])
    {
        return;
    }

    if(gestureRecognizer == _leftSwipe && ![_editingIndexPath isEqual:indexPath])
    {
        UITableViewCell * cell = [self cellForRowAtIndexPath:indexPath];
        [self setEditing:YES atIndexPath:indexPath cell:cell];
    }
    else if (gestureRecognizer == _rightSwipe && [_editingIndexPath isEqual:indexPath])
    {
        UITableViewCell * cell = [self cellForRowAtIndexPath:indexPath];
        [self setEditing:NO atIndexPath:indexPath cell:cell];
    }
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer
{
    if(_editingIndexPath)
    {
        UITableViewCell * cell = [self cellForRowAtIndexPath:_editingIndexPath];
        [self setEditing:NO atIndexPath:_editingIndexPath cell:cell];
    }
}

- (NSIndexPath *)cellIndexPathForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    UIView * view = gestureRecognizer.view;
    if(![view isKindOfClass:[UITableView class]])
    {
        return nil;
    }

    CGPoint point = [gestureRecognizer locationInView:view];
    NSIndexPath * indexPath = [self indexPathForRowAtPoint:point];
    return indexPath;
}

- (void)setEditing:(BOOL)editing atIndexPath:indexPath cell:(UITableViewCell *)cell
{

    if(editing)
    {
        if(_editingIndexPath)
        {
            UITableViewCell * editingCell = [self cellForRowAtIndexPath:_editingIndexPath];
            [self setEditing:NO atIndexPath:_editingIndexPath cell:editingCell];
        }
        [self addGestureRecognizer:_tapGesture];
    }
    else
    {
        [self removeGestureRecognizer:_tapGesture];
    }

    CGRect frame = cell.frame;

    CGFloat cellXOffset;
    CGFloat deleteButtonXOffsetOld;
    CGFloat deleteButtonXOffset;

    if(editing)
    {
        cellXOffset = -kDeleteButtonWidth;
        deleteButtonXOffset = kMainScreenWidth - kDeleteButtonWidth;
        deleteButtonXOffsetOld = kMainScreenWidth;
        _editingIndexPath = indexPath;
    }
    else
    {
        cellXOffset = 0;
        deleteButtonXOffset = kMainScreenWidth;
        deleteButtonXOffsetOld = kMainScreenWidth - kDeleteButtonWidth;
        _editingIndexPath = nil;
    }

    CGFloat cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    _deleteButton.frame = (CGRect) {deleteButtonXOffsetOld, frame.origin.y, _deleteButton.frame.size.width, cellHeight};
    _deleteButton.indexPath = indexPath;

    [UIView animateWithDuration:0.2f animations:^{
        cell.frame = CGRectMake(cellXOffset, frame.origin.y, frame.size.width, frame.size.height);
        _deleteButton.frame = (CGRect) {deleteButtonXOffset, frame.origin.y, _deleteButton.frame.size.width, cellHeight};
    }];
}

#pragma mark - Interaciton
- (void)deleteItem:(id)sender
{
    UIButton * deleteButton = (UIButton *)sender;
    NSIndexPath * indexPath = deleteButton.indexPath;

    [self.dataSource tableView:self commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];

    _editingIndexPath = nil;

    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = _deleteButton.frame;
        _deleteButton.frame = (CGRect){frame.origin, frame.size.width, 0};
    } completion:^(BOOL finished) {
        CGRect frame = _deleteButton.frame;
        _deleteButton.frame = (CGRect){kMainScreenWidth, frame.origin.y, frame.size.width, kDeleteButtonHeight};
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO; // Recognizers of this class are the first priority
}

@end
