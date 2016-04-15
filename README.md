# ELNBehaviors

Коллекция поведений пользовательского интерфейса.

- `ELNPaginatedScrollViewBehavior`
- `ELNTouchesGestureRecognizer`
- `ELNKeyboardDismissGestureRecognizer`

## Installation

###Cocoapods

```
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/elegion/ios-podspecs'

pod 'ELNBehaviors' 
```

###Carthage

```
github 'elegion/ios-ELNBehaviors'
```

## Usage 

###ELNPaginatedScrollViewBehavior

Связывает `UIScrollView` и `UIPageControl` для постраничной навигации. Используется для отображения баннеров или галереи картинок:

![scroll](scroll.gif)

```objective-c
@interface MyCustomViewController : UIViewController 

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) ELNPaginatedScrollViewBehavior *scrollBehavior;

@end

@implementation MyCustomViewController

- (void)viewDidLoad {
	[super viewDidLoad];

    self.scrollBehavior = [[ELNPaginatedScrollViewBehavior alloc] initWithPageControl:self.pageControl scrollView:self.collectionView];
    self.scrollBehavior.autoScrollTimeInterval = 8;
}

@end
```

### ELNTouchesGestureRecognizer

Жест, который изменяет свое состояние в соответствии с методами `touchesBegan`/`touchesMoved`/`touchesEnded`/`touchesCancelled`	

###ELNKeyboardDismissGestureRecognizer

Жест, который скрывает клавиатуру при нажатии в любое место. Игнорирует нажатия на `UIView`, которые возвращают `YES` в ответ на `canBecomeFirstResponder`. 

Позволяет конфигурировать поведение с помощью блока `shouldDismissKeyboardHandler`:

```objective-c
@interface MyCustomViewController ()

@property (nonatomic, strong) IBOutlet UIButton *button;

@end

@implementation MyCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ELNKeyboardDismissGestureRecognizer *gestureRecognizer = [[ELNKeyboardDismissGestureRecognizer alloc] initWithShouldDismissKeyboardHandler:^BOOL(NSSet<UITouch *> * _Nonnull touches, UIEvent * _Nonnull event) {
        return touches.anyObject.view != self.button;
    }];
    [self.view addGestureRecognizer:gestureRecognizer];
}

@end
```

## Contribution

###Cocoapods

```sh
# download source code, fix bugs, implement new features

pod repo add legion https://github.com/elegion/ios-podspecs
pod repo push legion ELNBehaviors.podspec
```