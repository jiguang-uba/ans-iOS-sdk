//
//  AnalysysLogVC.m
//  AnalysysOCDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

#import "AnalysysLogVC.h"

#import "AnalysysLogDetailVC.h"

#import "AnalysysLogData.h"

#import "AnalysysLogCell.h"
#import "AnalysysLogHeaderView.h"

@interface AnalysysLogVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AnalysysLogVC {
    BOOL _needReloadTableView;   //  是否需要刷新列表，用于标识是否点击某一条数据
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"日志列表";
    _needReloadTableView = YES;
    
    self.dataArray = [[AnalysysLogData sharedSingleton].logData mutableCopy];
    
    //  监测数据变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"AnalysysDataUpdate" object:nil];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *cleanItem = [[UIBarButtonItem alloc] initWithTitle:@"清空日志" style:UIBarButtonItemStylePlain target:self action:@selector(cleanLog)];
    UIBarButtonItem *flushItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItems = @[cleanItem, flushItem];

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"AnalysysLogCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AnalysysLogCell"];
    [tableView registerNib:[UINib nibWithNibName:@"AnalysysLogHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    
    self.tableView = tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerViewIdentify = @"HeaderView";
    AnalysysLogHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewIdentify];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnalysysLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnalysysLogCell" forIndexPath:indexPath];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.eventTypeLabel.text = [dic objectForKey:@"xwhat"];
    
    long long time = [[dic objectForKey:@"xwhen"] longLongValue];
    cell.timeLabel.text = [self stringOfDate:[NSDate dateWithTimeIntervalSince1970:time/1000]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  防止当前点击数据选中状态被刷新
    _needReloadTableView = NO;
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    AnalysysLogDetailVC *detail = [[AnalysysLogDetailVC alloc] init];
    detail.logDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)goToBack {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.callBackBlock) {
            self.callBackBlock();
        }
    }];
}

/// 清空日志列表
- (void)cleanLog {
    self.dataArray = [NSArray array];
    [[AnalysysLogData sharedSingleton].logData removeAllObjects];
    [self.tableView reloadData];
}

/// 刷新列表
- (void)refreshData {
    _needReloadTableView = YES;
    self.dataArray = [[AnalysysLogData sharedSingleton].logData mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - data update, reload list

- (void)reloadTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_needReloadTableView) {
            if (self.dataArray.count > 10000) {
                NSLog(@"临时日志累积达到10000条，将会清理");
                [self cleanLog];
            } else {
                self.dataArray = [[AnalysysLogData sharedSingleton].logData mutableCopy];
                [self.tableView reloadData];
            }
        }
    });
}

#pragma mark - other

- (NSString *)stringOfDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


@end
