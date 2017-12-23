//
//  ViewController.m
//  DragAndDropTable
//
//  Created by Юрий Логинов on 22.12.17.
//  Copyright © 2017 Yury Loginov. All rights reserved.
//

#import "ViewController.h"
#import "TableSection.h"
#import "TableCell.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "TableCellsDraggingHandler.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, TableViewCellsDraggingDelegate>

@property (nonatomic, strong) NSArray  <TableSection *> *sections;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) TableCellsDraggingHandler *dragHandler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
}

- (void)setupTable {
    self.dragHandler = [TableCellsDraggingHandler handleDraggingOnTableView:self.tableView];
    self.dragHandler.delegate = self;
    self.tableView.estimatedRowHeight = 70.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSMutableArray *cellsFirst = [NSMutableArray new];
    NSMutableArray *cellsSecond = [NSMutableArray new];
    
    for (int i = 0; i < 10; i++) {
        NSString *titleCell = [NSString stringWithFormat:@"Row %d", i+1];
        TableCell *cell = [TableCell cellWithTitle:titleCell height:UITableViewAutomaticDimension action:^{
            NSLog(@"%@ tapped", titleCell);
        }];
        
        if (i < 5) {
            [cellsFirst addObject:cell];
        } else {
            [cellsSecond addObject:cell];
        }
    };
    
    TableSection *firstSection = [TableSection sectionWithCells:cellsFirst headerTitle:@"First"];
    firstSection.type = SectionTypeFirst;
    
    TableSection *secondSection = [TableSection sectionWithCells:cellsSecond headerTitle:@"Second"];
    secondSection.type = SectionTypeSecond;
    
    self.sections = @[firstSection, secondSection];
}

#pragma mark - Dragging delegate

- (void)selectedRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TableSection *currentSection = self.sections[indexPath.section];
    TableCell *cell = currentSection.cells[indexPath.row];
    if (cell.actionBlock) {
        cell.actionBlock();
    }
}

- (void)dragDidEndFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    TableSection *fromSection = self.sections[fromIndexPath.section];
    TableCell *fromCell = fromSection.cells[fromIndexPath.row];
    
    TableSection *toSection = self.sections[toIndexPath.section];
    TableCell *toCell = toSection.cells[toIndexPath.row];
    
    if ([fromCell isEqual:toCell]) {
        return;
    }
    
    UIViewController *vc = nil;
    
    if (toSection.type == SectionTypeFirst) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FirstViewController class])];
        [(FirstViewController *)vc setupWithFirstTitle:fromCell.titleLabel.text secondTitle:toCell.titleLabel.text];
    } else {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SecondViewController class])];
        [(SecondViewController *)vc setupWithFirstTitle:fromCell.titleLabel.text secondTitle:toCell.titleLabel.text];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (TableSection *)sectionForIndexPath:(NSIndexPath *)indexPath {
    return self.sections[indexPath.section];
}

- (BOOL)shouldDropToIndexPath:(NSIndexPath *_Nonnull)indexPath {
    TableSection *currentSection = self.sections[indexPath.section];
    if (currentSection.type == SectionTypeFirst) {
        return NO;
    }
    return YES;
}

#pragma mark - TableView data source

-(void)setSections:(NSArray<TableSection *> *)sections {
    _sections = sections;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TableSection *currentSection = self.sections[section];
    return currentSection.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableSection *currentSection = self.sections[indexPath.section];
    TableCell *cell = currentSection.cells[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableSection *currentSection = self.sections[indexPath.section];
    TableCell *cell = currentSection.cells[indexPath.row];
    return cell.height;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TableSection *currentSection = self.sections[section];
    return currentSection.headerTitle;
}

@end
