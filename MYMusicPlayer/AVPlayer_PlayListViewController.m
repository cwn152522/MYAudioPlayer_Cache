//
//  AVPlayer_PlayListViewController.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/28.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_PlayListViewController.h"
#import "UIView+CWNView.h"
#import "AVPlayer_PlayListTableViewCell.h"
#import "AVPlayer_PlayListTableHeaderView.h"

static NSString *const kCellIdentifier = @"list_cell_Id";

@interface AVPlayer_PlayListViewController ()<UITableViewDelegate, UITableViewDataSource, AVPlayer_PlayListTableHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AVPlayer_PlayListTableHeaderView *tableHeaderView;

@end

@implementation AVPlayer_PlayListViewController

#pragma mark - <*********************** 页面生命周期 ************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshTableView];
}

#pragma mark - <*********************** 页面ui搭建和数据初始化 ************************>

- (void)configTableView{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"AVPlayer_PlayListTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];

    if(!_tableHeaderView){
        _tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"AVPlayer_PlayListTableHeaderView" owner:self options:nil] firstObject];
        _tableHeaderView.delegate = self;
    }
    self.tableView.tableHeaderView = _tableHeaderView;
    self.tableView.tableHeaderView.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - <*********************** 列表数据请求 ************************>

- (void)refreshTableView{
    // !!!: 数据请求和列表刷新事件
    [self.tableView reloadData];
}

#pragma mark - <*********************** 各种代理事件处理 ************************>

#pragma mark UITableViewDataDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicModel *item = [self.data objectAtIndex:indexPath.row];
    if([self.delegate respondsToSelector:@selector(playList:didSelectItem:atRow:)]){
        [self.delegate playList:self didSelectItem:item atRow:indexPath.row];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVPlayer_PlayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    MusicModel *item = self.data[indexPath.row];
    [cell.nameLabel setText:[@"龙虎榜揭秘：" stringByAppendingString:item.music_title]];
    
    if(item.isPlaying == YES){
        cell.isPlayImage.hidden = NO;
        [cell startAnimation];
        cell.nameLabelLeft.constant = 5;
        [UIView animateWithDuration:0.12 animations:^{
            [cell.contentView layoutIfNeeded];
        }];
    }else{
        cell.isPlayImage.hidden = YES;
        cell.nameLabelLeft.constant = -12;
        [UIView animateWithDuration:0.12 animations:^{
            [cell.contentView layoutIfNeeded];
        }];
    }
    return cell;
}

#pragma mark AVPlayer_PlayListTableHeaderViewDelegate
- (void)playListHeaderView_didSelectRecycleType:(AVPlayerPlayMode)playMode{
    if([self.delegate respondsToSelector:@selector(playList_didSelectRecycleType:)]){
        [self.delegate playList_didSelectRecycleType:playMode];
    }
}

#pragma mark - <*********************** 其他事件处理 ************************>

- (void)musicWillStartToPlay:(NSInteger)index{
    [self.data enumerateObjectsUsingBlock:^(MusicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == index)
            obj.isPlaying = YES;
        else
            obj.isPlaying = NO;
    }];
    [self.tableView reloadData];//刷新列表
}

- (void)didReceiveMemoryWarning {
    //TODO: 内存警告检测事件
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickCloseBtn:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(playList_onClickClose)]){
        [self.delegate playList_onClickClose];
    }
}

- (void)setData:(NSMutableArray<MusicModel *> *)data{
    _data = data;
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
