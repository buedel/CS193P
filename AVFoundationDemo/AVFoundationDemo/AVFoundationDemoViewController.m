//
//  AVFoundationDemoViewController.m
//  AVFoundationDemo
//
//  Created by DOUGLAS BUEDEL on 11/4/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "AVFoundationDemoViewController.h"

@interface AVFoundationDemoViewController ()
@property(nonatomic, strong) AVCaptureSession * session;
@property(nonatomic, strong) AVCaptureDevice * videoDevice;
@property(nonatomic, strong) AVCaptureDeviceInput * videoInput;
@property(nonatomic, strong) AVCaptureVideoDataOutput * frameOutput;
@property(nonatomic, strong) CIContext * context;

@property(nonatomic, strong) CIDetector * faceDetector;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation AVFoundationDemoViewController

@synthesize session = _session;
@synthesize videoDevice = _videoDevice;
@synthesize videoInput = _videoInput;
@synthesize frameOutput = _frameOutput;
@synthesize context = _context;
@synthesize faceDetector = _faceDetector;

@synthesize imgView = _imgView;

- (CIContext *) context
{
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (CIContext *) faceDetector
{
    if (!_faceDetector) {
        NSDictionary * detectorOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                          CIDetectorAccuracyLow, CIDetectorAccuracy,
                                          nil];
        
        _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                           context:nil
                                           options:detectorOptions];
    }
    return _faceDetector;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.frameOutput];

    [self.frameOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    [self.session startRunning];
    
    
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pb = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage * ciImage = [CIImage imageWithCVPixelBuffer:pb];
    
    // Add some filtering
    CIFilter * filter = [CIFilter filterWithName:@"CIHueAdjust"];
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:2.0] forKey:@"inputAngle"];
    CIImage * result = [filter valueForKey:@"outputImage"];
    
    // Face detection
    NSArray * features = [self.faceDetector featuresInImage:result];
    for(CIFaceFeature * face in features) {
        if (face.hasLeftEyePosition && face.hasRightEyePosition) {
            CGPoint eyeCenter =
            CGPointMake(face.leftEyePosition.x*0.5 + face.rightEyePosition.x*0.5,
                        face.leftEyePosition.y*0.5 + face.rightEyePosition.y*0.5);
           
            // You need to transform from the image coordninate system to the view's coordinate system
            // TODO... add code from website that adds sunglasses.
        }
    }
    
    CGImageRef ref = [self.context createCGImage:result fromRect:ciImage.extent];
    self.imgView.image = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(ref);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
