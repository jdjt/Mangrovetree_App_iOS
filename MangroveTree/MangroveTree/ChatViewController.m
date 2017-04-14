//
//  ChatViewController.m
//  MangroveTree
//
//  Created by liuchao on 2017/4/12.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatInputBar.h"
#import "ChatCell.h"
#import "PureLayout.h"
#import "ChatHeadView.h"

#define kSizeHead CGSizeMake(kScreenWidth, 64)

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *chatTabelView;
@property (nonatomic, strong) ChatInputBar *chatInputView;
@property (nonatomic, strong) ChatHeadView *headView;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [self.headView autoSetDimensionsToSize:kSizeHead];
    self.headView.backgroundColor = [UIColor redColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // add tableView
    [self.view addSubview:self.chatTabelView];
    self.chatTabelView.backgroundColor = [UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1];
    [self.chatTabelView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headView withOffset:0];
    [self.chatTabelView autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
    // add inputView
    [self.view addSubview:self.chatInputView];
    [self.chatInputView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.chatTabelView];
    [self.chatInputView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.chatInputView autoSetDimension:ALDimensionWidth toSize:kScreenWidth];
}

#pragma mark - Getter Method

- (UITableView *)chatTabelView
{
    if (!_chatTabelView)
    {
        _chatTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
        _chatTabelView.delegate = self;
        _chatTabelView.dataSource = self;
        _chatTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTabelView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
    }
    return _chatTabelView;
}

- (ChatInputBar *)chatInputView
{
    if (!_chatInputView)
    {
        _chatInputView = [[ChatInputBar alloc] init];
        _chatInputView.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _chatInputView;
}
- (ChatHeadView *)headView
{
    if (!_headView)
    {
        _headView = [[ChatHeadView alloc] init];
        _chatInputView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headView;
}
#pragma mark - UITableView  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
        cell.backgroundColor = [UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1];
        cell.backgroundColor = [UIColor blueColor];
    }
    return cell;
}
#warning 暂时舍弃自己手写聊天界面
/*
- (void)routerEventWithType:(EventChatCellType)eventType userInfo:(NSDictionary *)userInfo
{
    switch (eventType)
    {
        case EventChatMoreViewPickerImage:
            [self invokingSystemPhoto];
            break;
        case EventChatCellTypeSendMsgEvent:
            break;
        case EventChatMoreViewCemera:
            [self invokingSystemCemera];
            break;
        default:
            break;
    }
}
- (void)invokingSystemPhoto
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"去开启访问相册权限?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self openJurisdiction];
        }];
        // 将UIAlertAction添加到UIAlertController中
        [alertController addAction:cancel];
        [alertController addAction:ok];
        // present显示
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    //创建UIImagePickerController
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    
    //设置图片源类型
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //取出所有图片资源的相簿
    
    //设置代理
    pickVC.delegate = self;
    
    [self presentViewController:pickVC animated:YES completion:nil];
}

- (void)invokingSystemCemera
{
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"去开启访问相机权限?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self openJurisdiction];
        }];
        [alertController addAction:cancel];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if ([self isCameraAvailable])
    {
        // 初始化图片选择控制器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
        [controller setMediaTypes:arrMediaTypes];
        // 设置是否可以管理已经存在的图片或者视频
        [controller setAllowsEditing:YES];
        // 设置代理
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)openJurisdiction
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 判断设备是否有摄像头
- (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
// 前面的摄像头是否可用
- (BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
// 后面的摄像头是否可用
- (BOOL)isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
#pragma mark - UIImagePickerControllerDelegate

// 当得到照片或者视频后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage])
    {
        UIImage *theImage = nil;
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的原数据
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        // 保存图片到相册中
    }
    [picker  dismissViewControllerAnimated:YES completion:nil];
}
// 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker  dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
