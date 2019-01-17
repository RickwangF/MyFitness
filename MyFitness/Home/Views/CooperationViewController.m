//
//  CooperationViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/16.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "CooperationViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <AVOSCloud/AVOSCloud.h>
#import "Cooperation.h"
#import "UIImage+UIColor.h"
#import "AppStyleSetting.h"
#import <SDWebImage//UIImageView+WebCache.h>
#import "CooperationTableCell.h"
#import "CooperationDetailViewController.h"
#import "MyFitness-Swift.h"
#import <Hero/Hero-Swift.h>
#import "HeroIDModel.h"

@interface CooperationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *cooperateTableView;

@property (nonatomic, strong) NSMutableArray<Cooperation*> *cooperArray;

@end

@implementation CooperationViewController

#pragma mark - Init

- (instancetype)init
{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		[self initValueProperty];
	}
	return self;
}

- (void)initValueProperty{
	_cooperArray = [[NSMutableArray alloc] init];
}

#pragma mark - Lift Circle

- (void)loadView{
	UIView *mainView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	mainView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithUIColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
	self.navigationItem.backBarButtonItem = [UIBarButtonItem new];
	self.title = @"合作伙伴";
	
	[self initCooerateTableView];
	
	[self getAllCooperation];
	
	//[self insertData];
    // Do any additional setup after loading the view.
}

#pragma mark - Insert Data

- (void)insertData{
	
	NSString *title = @"华为Mate20Pro新配色发布";
	NSString *content1 = @"在泛审美爆发的今天，不论奢侈名品还是科技尖货，都在追寻着时尚的脚步。夯实品质的前提下，还要力求满足大众对产品外观的审美需求，只有经过潮流无数次冲刷后，留下的色彩才能称之为经典。正如经典的红蓝双色，诠释的不仅是色彩界的最佳CP，更蕴含着感性与理性的双面内涵。";
	NSString *content2 = @"2019年1月10日，华为Mate 20 Pro携惊喜而来，连同众多时尚大咖，在北京三里屯CHAO酒店正式发布了两款诠释时尚经典的新色——馥蕾红、璨星蓝。发布会当天知名主持人、模特李艾，Grace Chen 品牌创始人、总设计师Grace Chen，国际超模、珠宝设计师、上市公司首席品牌官黄超燕，芭莎能量创始人兼总裁景璐等精英女性代表现身“红蓝知己”HUAWEI Mate 20系列新色沙龙现场。";
	NSString *content3 = @"在新色沙龙现场，华为消费者业务手机产品线总裁何刚对两款新色的设计初衷进行了分享。何刚表示，此次华为Mate 20 Pro在原有时尚配色基础上推出了馥蕾红、璨星蓝两款新色，是希望让手机除了带来极致的科技体验，还承载起消费者的情感需求，以色彩对话内心，引发高端用户在审美和精神上的共鸣。";
	NSString *content4 = @"说到馥蕾红，它的设计灵感源自象征热烈、浪漫的玫瑰，给人以“带着玫瑰色的梦和蓓蕾的温馨”，同时它也象征着精英女性特有的成熟魅力。华为手机正是将这一抹温润赋予在了华为Mate 20 Pro上，为科技产品增添了一份女性与时尚的气息。";
	NSString *content5 = @"此次华为Mate 20 Pro带来的馥蕾红、璨星蓝两款新色，采用的是时下流行的渐变设计，而得益于全新的工艺，让机身具有着流光溢彩的绚烂感。";
	NSString *content6 = @"比起纯色机身和常规工艺，华为手机更像是手机界的配色大师，华为Mate 20 Pro的两款新色首次采用了空间印膜工艺。为了保持机身的纤薄美感，研发团队需要以单层膜的厚度实现双层膜的立体空间光影颜色渐变，这在工艺技术难度上又上了一个台阶。在克服了诸多困难之后，才得以在不影响厚度的前提下，实现了空间渐变颜色效果和立体空间的光影颜色效果，馥蕾红的“味道”变得更为浓郁，而璨星蓝所演绎的“星空”也变得更加深邃。";
	NSString *imageUrl = @"http://lc-gytbbdn5.cn-n1.lcfile.com/828c00e7936481756f57.jpg";
	
	AVObject *object = [AVObject objectWithClassName:@"Cooperation"];
	[object setObject:title forKey:@"title"];
	[object setObject:@[content1, content2, content3, content4, content5, content6] forKey:@"content"];
	[object setObject:imageUrl forKey:@"imageUrl"];
	[object setObject:@(4) forKey:@"orderIndex"];
	[object setObject:@(YES) forKey:@"darkImage"];
	[object saveInBackground];
}

#pragma mark - Init View

- (void)initCooerateTableView{
	_cooperateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
	_cooperateTableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
	_cooperateTableView.delegate = self;
	_cooperateTableView.dataSource = self;
	_cooperateTableView.rowHeight = 300;
	_cooperateTableView.estimatedRowHeight = 0;
	_cooperateTableView.estimatedSectionHeaderHeight = 0;
	_cooperateTableView.estimatedSectionFooterHeight = 0;
	_cooperateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	if (@available(iOS 11.0, *)) {
		_cooperateTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
	UINib *cellNib = [UINib nibWithNibName:@"CooperationTableCell" bundle:NSBundle.mainBundle];
	[_cooperateTableView registerNib:cellNib forCellReuseIdentifier:@"cooperCell"];
	
	[self.view addSubview:_cooperateTableView];
	
	[_cooperateTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		if (@available(iOS 11.0, *)) {
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
		}
		else{
			make.top.equalTo(self.mas_topLayoutGuideTop);
		}
		make.left.bottom.right.equalTo(self.view);
	}];
}

#pragma mark - Request

- (void)getAllCooperation{
	AVQuery *query = [AVQuery queryWithClassName:@"Cooperation"];
	[query orderByAscending:@"orderIndex"];
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		
		if (error != nil) {
			[self.view makeToast:error.localizedDescription];
			return;
		}
		
		if (objects == nil || objects.count == 0) {
			[self.view makeToast:@"没有查询到合作对象"];
			return;
		}
		
		for (NSDictionary *object in objects) {
			Cooperation *cooper = [Cooperation cooperationWithDictionary:object];
			[self.cooperArray addObject:cooper];
		}
		
		[self.cooperateTableView reloadData];
	}];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _cooperArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	CooperationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cooperCell" forIndexPath:indexPath];
	Cooperation *cooper = _cooperArray[indexPath.row];
	cell.contentView.heroID = [NSString stringWithFormat:@"container%ld", (long)indexPath.row];
	cell.titleLabel.text = cooper.title;
	cell.titleLabel.heroID = [NSString stringWithFormat:@"title%ld", (long)indexPath.row];
	if (cooper.darkImage) {
		cell.titleLabel.textColor = UIColor.whiteColor;
	}
	cell.topImageView.heroID = [NSString stringWithFormat:@"image%ld", (long)indexPath.row];
	[cell.topImageView sd_setImageWithURL:[NSURL URLWithString:cooper.imageUrl]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	Cooperation *cooper = _cooperArray[indexPath.row];
	HeroIDModel *model = [[HeroIDModel alloc] init];
	model.containerId = [NSString stringWithFormat:@"container%ld", (long)indexPath.row];
	model.imageId = [NSString stringWithFormat:@"image%ld", (long)indexPath.row];
	model.titleId = [NSString stringWithFormat:@"title%ld", (long)indexPath.row];
	CooperationDetailViewController *detailVC = [[CooperationDetailViewController alloc] initWithCooperation:cooper HeroId:model];
	DropDismissNaviViewController *naviVC = [[DropDismissNaviViewController alloc] initWithRootViewController:detailVC];
	[self presentViewController:naviVC animated:YES completion:nil];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
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
