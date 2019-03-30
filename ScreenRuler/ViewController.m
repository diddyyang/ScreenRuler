//
//  ViewController.m
//  ScreenRuler
//
//  Created by 杨铁 on 2019/3/30.
//  Copyright © 2019 UnSee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgBK;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawLines];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self localPhoto];
}

-(void) drawLines {
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    for(int x=0; x < screenWidth; x++) {
        if(x % 10 == 0) {
            UIView* line = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 1, screenHeight)];
            line.backgroundColor = [UIColor blueColor];
            [self.view addSubview:line];
        }
    }
    for(int y=0; y < screenHeight; y++) {
        if(y % 10 == 0) {
            UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, y, screenWidth, 1)];
            line.backgroundColor = [UIColor redColor];
            [self.view addSubview:line];
        }
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
