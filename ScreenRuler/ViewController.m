//
//  ViewController.m
//  ScreenRuler
//
//  Created by 杨铁 on 2019/3/30.
//  Copyright © 2019 UnSee. All rights reserved.
//

#import "ViewController.h"

#define DYNAMIC_LINE_FLAG_X 10009
#define DYNAMIC_LINE_FLAG_Y 10010

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgBK;
@property (weak, nonatomic) IBOutlet UILabel *lblCellUnit;
@end

@implementation ViewController {
@private int _currentCellSize;
}

- (void)viewDidLoad {
    self->_currentCellSize = 10;
    
    [super viewDidLoad];
    
    [self drawLines];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(increaseCellUnit:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reduceCellUnit:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)increaseCellUnit:(UISwipeGestureRecognizer *)recognizer {
    _currentCellSize = _currentCellSize + 1;
    
    [self clearLines];
    [self drawLines];
    _lblCellUnit.text = [NSString stringWithFormat:@"Cell Size: %dP, Change it by swipe", self->_currentCellSize];
}

-(void)reduceCellUnit:(UISwipeGestureRecognizer *)recognizer {
    if(_currentCellSize - 1 <= 0) return;
    
    _currentCellSize = _currentCellSize - 1;
    [self clearLines];
    [self drawLines];
    _lblCellUnit.text = [NSString stringWithFormat:@"Cell Size: %dP, Change it by swipe", self->_currentCellSize];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self localPhoto];
}

-(void) drawLines {
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    for(int x=0; x < screenWidth; x++) {
        if(x % _currentCellSize == 0) {
            UIView* line = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 1, screenHeight)];
            line.backgroundColor = [UIColor blueColor];
            line.tag = DYNAMIC_LINE_FLAG_X;
            [self.view addSubview:line];
        }
    }
    for(int y=0; y < screenHeight; y++) {
        if(y % _currentCellSize == 0) {
            UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, y, screenWidth, 1)];
            line.backgroundColor = [UIColor redColor];
            line.tag = DYNAMIC_LINE_FLAG_Y;
            [self.view addSubview:line];
        }
    }
    
    [self.view bringSubviewToFront: _lblCellUnit];
}

-(void)clearLines {
    for (UIView* view in self.view.subviews) {
        if(view.tag == DYNAMIC_LINE_FLAG_X || view.tag == DYNAMIC_LINE_FLAG_Y)
            [view removeFromSuperview];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        NSString *key = nil;
        
        if (picker.allowsEditing)
        {
            key = UIImagePickerControllerEditedImage;
        }
        else
        {
            key = UIImagePickerControllerOriginalImage;
        }
        self.imgBK.image = [info objectForKey:key];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

// 打开本地相册
-(void)localPhoto
{
    //本地相册不需要检查，因为UIImagePickerController会自动检查并提醒
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    [self presentViewController:picker animated:YES completion:nil];
}

@end
