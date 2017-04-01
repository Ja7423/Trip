//
//  DetailViewController.m
//  TripManager
//
//  Created by 何家瑋 on 2017/3/13.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITextViewDelegate, DownloadManagerDelegate>
{
        DownloadManager * _downloadManager;
        FileManager * _fileManager;
        CLLocationManager * _locationManager;
        CLLocation * _userLocation;
}

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *addressIcon;

@property (weak, nonatomic) IBOutlet UIView *openTimeView;
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *openTimeIcon;

@property (weak, nonatomic) IBOutlet UIView *telView;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (strong, nonatomic) IBOutlet UIImageView *telIcon;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *pictureScrollView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;

@property (weak, nonatomic) IBOutlet UITextView *customRemarks;

@property (weak, nonatomic) IBOutlet UIDatePicker *visitTimePicker;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
        _downloadManager = [[DownloadManager alloc]init];
        _downloadManager.delegate = self;
        
        _fileManager = [[FileManager alloc]init];
        
        [self configrueNavigationBar];
        [self configurePictureScrollView];
        [self processDataItem];
        [self processMapView];
        
        //regist keyboard notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
        [_locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configrueNavigationBar
{
        [self switchRightBarButtonItem:UIBarButtonSystemItemAdd];
}

- (void)processDataItem
{
#pragma mark process picture url
        [self processPictureImageDownload];
        
#pragma mark labels
        // name
        _nameLabel.text = _dataItem.Name;
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        
        // description
        _descriptionLabel.text = _dataItem.Description;
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [_descriptionLabel sizeToFit];

        // address
        _addressIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location"]];
        _addressView.clipsToBounds = YES;
        [_addressView addSubview:_addressIcon];
        _addressLabel.text = _dataItem.Add;
        
        // open time
        _openTimeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"opentime"]];
        _openTimeView.clipsToBounds = YES;
        [_openTimeView addSubview:_openTimeIcon];
        _openTimeLabel.text = _dataItem.Opentime;
        
        // tel
        _telIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone"]];
        _telView.clipsToBounds = YES;
        [_telView addSubview:_telIcon];
        _telLabel.text = _dataItem.Tel;
        
        // info
        if (_dataItem.Travellinginfo && ![_dataItem.Travellinginfo isEqualToString:@""])
        {
                _infoLabel.text = _dataItem.Travellinginfo;
        }
        else if (_dataItem.Serviceinfo && ![_dataItem.Serviceinfo isEqualToString:@""])
        {
                _infoLabel.text = _dataItem.Serviceinfo;
        }
        
        _infoLabel.numberOfLines = 0;
        [_infoLabel sizeToFit];
        
#pragma mark process function button enable
        if ([_dataItem.Tel isEqualToString:@""])
        {
                _phoneButton.enabled = NO;
                NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:@"phone"];
                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
                [_phoneButton setAttributedTitle:attributeString forState:UIControlStateNormal];
        }
        
        if ([_dataItem.Website isEqualToString:@""])
        {
                _websiteButton.enabled = NO;
                NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:@"website"];
                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 7)];
                [_websiteButton setAttributedTitle:attributeString forState:UIControlStateNormal];
        }
        
#pragma mark customRemarks textview
        _customRemarks.delegate = self;
        if (_dataItem.CustomRemarks)
        {
                _customRemarks.text = _dataItem.CustomRemarks;
        }
        else
        {
                _customRemarks.text = @"備註：";
        }
        
#pragma mark visitTimePicker
        _visitTimePicker.datePickerMode = UIDatePickerModeTime;
        [_visitTimePicker addTarget:self action:@selector(didChangeSelectDate:) forControlEvents:UIControlEventValueChanged];
        NSString * timeString = (_dataItem.VisitTime) ? _dataItem.VisitTime : @"00:00";
        [_visitTimePicker setDate:[NSDate timeFromString:timeString]];
}

#pragma mark - picture scroll view
- (void)configurePictureScrollView
{
        UIImageView * contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _pictureScrollView.frame.size.width , _pictureScrollView.frame.size.height)];
        contentImageView.image = [UIImage imageNamed:@"No_image_available"];
        contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _pictureScrollView.zoomScale = 1.0f;
        _pictureScrollView.pagingEnabled = YES;
        _pictureScrollView.contentSize = _pictureScrollView.frame.size;
        
        [_pictureScrollView addSubview:contentImageView];
}

- (void)processPictureImageDownload
{
        NSMutableArray * needDownloadPictures = [NSMutableArray array];
        NSMutableArray * requests = [NSMutableArray array];
        for (int i = 1; i < 4; i++)
        {
                NSString *key = [NSString stringWithFormat:@"Picture%d", i];
                NSString * value = [_dataItem valueForKey:key];
                
                if (value && ![value isEqualToString:@""])
                {
                        // first , check if picture image already download in docutment directory
                        NSURL * fileURL = [_fileManager checkCacheFile:value.lastPathComponent];
                        if (fileURL)
                        {
                                DownloadRequest * request = [[DownloadRequest alloc]init];
                                request.response.fileURL = fileURL;
                                [requests addObject:request];
                        }
                        else
                        {
                                NSDictionary * dictionary = @{@"downloadURL" : value};
                                [needDownloadPictures addObject:dictionary];
                        }
                }
        }
        
        if (requests.count != 0)
        {
                [self processPictureScrollViewImageFromRequest:requests];
        }
        
        if (needDownloadPictures.count != 0)
        {
                _downloadManager.requests = [_downloadManager prepareDownloadRequest:needDownloadPictures];
                [_downloadManager startDownload];
        }
}

- (void)processPictureScrollViewImageFromRequest:( NSArray <DownloadRequest *>*)requests
{
        __block CGFloat scrollwidth = 0.0f;
        
        [requests enumerateObjectsUsingBlock:^(DownloadRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIImageView * contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollwidth, 0, _pictureScrollView.frame.size.width , _pictureScrollView.frame.size.height)];
                
                contentImageView.contentMode = UIViewContentModeScaleAspectFill;
                contentImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:request.response.fileURL]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        [_pictureScrollView addSubview:contentImageView];
                });
                
                scrollwidth += _pictureScrollView.frame.size.width;
        }];
        
        _pictureScrollView.zoomScale = 1.0f;
        _pictureScrollView.pagingEnabled = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
                _pictureScrollView.contentSize = CGSizeMake(scrollwidth, _pictureScrollView.frame.size.height);
                [_pictureScrollView reloadInputViews];
        });
}

#pragma mark - private method
- (CGRect)iconFrame:(UILabel *)targetLabel
{
        return CGRectMake(0, 0, targetLabel.frame.size.height, targetLabel.frame.size.height);
}

- (void)moveContentView:(CGFloat)moveOffset WhenKeyboardDidShow:(BOOL)keyboardWillShow
{
        if (keyboardWillShow)
        {
                UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, moveOffset, 0.0);
                _baseScrollView.contentInset = contentInsets;
                _baseScrollView.scrollIndicatorInsets = contentInsets;
                
                // If text field is hidden by keyboard, scroll it so it's visible
                CGRect viewFrame = self.view.frame;
                viewFrame.size.height -= moveOffset; // minus should move offset
                if (!CGRectContainsPoint(viewFrame, _customRemarks.frame.origin) )
                {
                        // the textview did not contain in the viewFrame, so the textview is hidden by keyboard
                        [_baseScrollView scrollRectToVisible:_customRemarks.frame animated:YES];
                }
        }
        else
        {
                UIEdgeInsets contentInsets = UIEdgeInsetsZero;
                _baseScrollView.contentInset = contentInsets;
                _baseScrollView.scrollIndicatorInsets = contentInsets;
        }
}

- (void)switchRightBarButtonItem:(UIBarButtonSystemItem)systemItem
{
        UIBarButtonItem * rightBarButtonItem;
        switch (systemItem) {
                case UIBarButtonSystemItemAdd:
                        rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:systemItem target:self action:@selector(clickAddButton:)];
                        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
                        self.navigationItem.rightBarButtonItem.enabled = _enableAddButton;
                        break;
                case UIBarButtonSystemItemDone:
                        rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:systemItem target:self action:@selector(clickDoneButton:)];
                        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
                        break;
                default:
                        break;
        }
}

#pragma mark - configure map and location
- (void)processMapView
{
        [self checkLocationPermission];
        
        [self findItemLocation];
}

- (void)checkLocationPermission
{
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        
        switch ([CLLocationManager authorizationStatus])
        {
                case kCLAuthorizationStatusNotDetermined:
                        [_locationManager requestWhenInUseAuthorization];
                        break;
                default:
                        break;
        }
}

- (void)startUpdateUserLocation
{
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
}

- (void)findItemLocation
{
        double latitude = _dataItem.Py.doubleValue;
        double longitude = _dataItem.Px.doubleValue;
        
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MKCoordinateRegion region = _mapView.region;
        MKCoordinateSpan span;
        
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = locationCoordinate;
        [_mapView setRegion:region animated:YES];
        
        
        MKPointAnnotation * pointAnnotation = [[MKPointAnnotation alloc]init];
        pointAnnotation.coordinate = locationCoordinate;
        _mapView.delegate = self;
        [_mapView addAnnotation:pointAnnotation];
}

#pragma mark - button action
- (IBAction)clickAddButton:(id)sender
{
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        if ([_delegate respondsToSelector:@selector(viewController:didInsertDataItem:)])
        {
                [_delegate viewController:self didInsertDataItem:_dataItem];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickDoneButton:(id)sender
{
        [_customRemarks resignFirstResponder];
        
        [self switchRightBarButtonItem:UIBarButtonSystemItemAdd];
        
        if ([_delegate respondsToSelector:@selector(viewController:didEditDataItem:)])
        {
                [_delegate viewController:self didEditDataItem:_dataItem];
        }
}

- (void)didChangeSelectDate:(UIDatePicker *)sender
{
        _dataItem.VisitTime = [NSDate stringFromTime:[sender date]];
        
        if ([_delegate respondsToSelector:@selector(viewController:didEditDataItem:)])
        {
                [_delegate viewController:self didEditDataItem:_dataItem];
        }
}

- (IBAction)clickFunctionalButton:(UIButton *)sender
{
        if (sender == _phoneButton)
        {
                [self makePhoneCall];
        }
        else if (sender == _websiteButton)
        {
                [self browseWebsite];
        }
        else if (sender == _directionButton)
        {
                [self callMapWithDirection];
        }
}

- (void)makePhoneCall
{
        NSURL * phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _dataItem.Tel]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneURL])
        {
                [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:^(BOOL success) {

                }];
        }
}

- (void)browseWebsite
{
        NSURL * webURL = [NSURL URLWithString:_dataItem.Website];
        
        if ([[UIApplication sharedApplication] canOpenURL:webURL])
        {
                [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:^(BOOL success) {

                }];
        }
}

- (void)callMapWithDirection
{
        float locationLatitude = _dataItem.Py.floatValue;
        float locationLongitude = _dataItem.Px.floatValue;
        
        NSURL * googleMapDirectionURL = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f", _userLocation.coordinate.latitude, _userLocation.coordinate.longitude, locationLatitude, locationLongitude]];
        NSURL * appleMapDirectionURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", _userLocation.coordinate.latitude, _userLocation.coordinate.longitude, locationLatitude, locationLongitude]];
        
        if ([[UIApplication sharedApplication] canOpenURL:googleMapDirectionURL])
        {
                [[UIApplication sharedApplication] openURL:googleMapDirectionURL options:@{} completionHandler:^(BOOL success) {
                        
                }];
        }
        else
        {
                [[UIApplication sharedApplication] openURL:appleMapDirectionURL options:@{} completionHandler:^(BOOL success) {
                        
                }];
        }
}

#pragma mark - mapView delegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
        return nil;
}

#pragma mark - CLLocation delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
        _userLocation = locations[0];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
                [self startUpdateUserLocation];
        }
}

#pragma mark - DownloadManagerDelegate
- (void)downloadManager:(DownloadManager *)manager didFinishDownload:( NSArray <DownloadRequest *>*)requests
{
        [self processPictureScrollViewImageFromRequest:requests];
}

#pragma mark - keyboard notification
- (void)keyboardDidShow:(NSNotification *)notification
{
        NSDictionary * userInfo = [notification userInfo];
        CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        [self moveContentView:keyboardSize.height WhenKeyboardDidShow:YES];
        [self switchRightBarButtonItem:UIBarButtonSystemItemDone];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
        [self moveContentView:0.0 WhenKeyboardDidShow:NO];
}

#pragma mark - textview delegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
        _dataItem.CustomRemarks = textView.text;
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
