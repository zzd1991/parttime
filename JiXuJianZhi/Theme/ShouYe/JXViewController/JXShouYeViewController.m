//
//  JXShouYeViewController.m
//  JiXuJianZhi
//
//  Created by John Mr on 2020/4/24.
//  Copyright © 2020 oneteam. All rights reserved.
//

#import "JXShouYeViewController.h"
#import "JXShouYeTableViewCell.h"

// Request & Model
#import "JXGetJobApi.h"
#import "JXGetJobModel.h"


@interface JXShouYeViewController () <UITableViewDelegate,UITableViewDataSource,QLAPIManagerParamSource,
QLAPIManagerCallBackDelegate>

@property(nonatomic,strong)UITableView       *shouyeTableView;

@property(nonatomic,strong)JXGetJobApi       *getJobApi;
@property(nonatomic,assign)NSUInteger         page;
@property(nonatomic,strong)NSArray           *resultArr;
@property(nonatomic,strong)JXGetJobModel     *getJobModel;


@end

@implementation JXShouYeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"急需兼职";
    
    [self.view addSubview:self.shouyeTableView];
    [self.shouyeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    self.page = 1;
    [self.getJobApi loadData];
}

#pragma mark - QLAPIManagerParamSource
-(NSDictionary *)paramsForApi:(QLAPIBaseManager *)manager{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.getJobApi == manager) {

    }
    
    return params;
}

#pragma mark - QLAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(QLAPIBaseManager *)manager
{
//    [self.matchTableView.mj_header endRefreshing];
//    [self hideHUDView];
    if (self.getJobApi == manager) {
        
        self.resultArr = [manager fetchDataWithReformer:self.getJobApi];
        [self.shouyeTableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(QLAPIBaseManager *)manager
{
//    [self.matchTableView.mj_header endRefreshing];
//    [self hideHUDView];
    
    NSLog(@"-=-=-  %lu",(unsigned long)manager.errorType);
    
    if (manager.errorType == QLAPIManagerErrorTypeNoNetWork || manager.errorType == QLAPIManagerErrorTypeDefault) {
        
        [self.view addSubview:self.noNetView];
        [self.noNetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JXShouYeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JXShouYeTableViewCell"];
    if (cell) {
        cell = [[JXShouYeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JXShouYeTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    JXGetJobModel *getJobModel = self.resultArr[indexPath.row];
    cell.getJobModel = getJobModel;

    return cell;
}

#pragma mark - lazy

-(UITableView *)shouyeTableView{
    if (!_shouyeTableView) {
        _shouyeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _shouyeTableView.delegate = self;
        _shouyeTableView.dataSource = self;
        _shouyeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_shouyeTableView registerClass:[JXShouYeTableViewCell class] forCellReuseIdentifier:@"JXShouYeTableViewCell"];
//        _matchTableView.showsVerticalScrollIndicator = NO;
//        _matchTableView.showsHorizontalScrollIndicator = NO;
//        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//        [header setImages:self.animatArr forState:MJRefreshStateIdle];
//        [header setImages:self.animatArr forState:MJRefreshStatePulling];
//        [header setImages:self.animatArr forState:MJRefreshStateRefreshing];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.stateLabel.hidden = YES;
//        _shouyeTableView.mj_header = header;

    }
    return _shouyeTableView;
}


-(JXGetJobApi *)getJobApi{
    if (!_getJobApi) {
        _getJobApi = [[JXGetJobApi alloc]init];
        _getJobApi.delegate = self;
        _getJobApi.paramSource = self;
    }
    return _getJobApi;
}

@end
