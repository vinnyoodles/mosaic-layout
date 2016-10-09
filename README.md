# TRMosaicLayout

[![CI Status](http://img.shields.io/travis/vinnyoodles/TRMosaicLayout.svg?style=flat)](https://travis-ci.org/vinnyoodles/TRMosaicLayout)
[![codebeat badge](https://codebeat.co/badges/dd08069e-ec9e-42d8-ba4c-9919b4c2ccfb)](https://codebeat.co/projects/github-com-vinnyoodles-trmosaiclayout)
[![Version](https://img.shields.io/cocoapods/v/TRMosaicLayout.svg?style=flat)](http://cocoapods.org/pods/TRMosaicLayout)
[![License](https://img.shields.io/cocoapods/l/TRMosaicLayout.svg?style=flat)](http://cocoapods.org/pods/TRMosaicLayout)
[![Platform](https://img.shields.io/cocoapods/p/TRMosaicLayout.svg?style=flat)](http://cocoapods.org/pods/TRMosaicLayout)

A mosaic collection view layout inspired by [Lightbox's Algorithm](http://blog.vjeux.com/2012/image/image-layout-algorithm-lightbox.html). This is a swift implementation/extension of [@fmitech's FMMosaicLayout](https://github.com/fmitech/FMMosaicLayout). The standard `UICollectionViewFlowLayout` can be a boring presentation in your app, but TRMosaicLayout is a simple feature that will engage your users with your eyecatching content. If you don't believe me, checkout Snapchat's app and
their awesome layout in their Discover feed.

**TRMosaicLayout implementation**

<img src="Demo/demo.gif"/>

**Similar implementation used by [@snapchat](https://github.com/snapchat)**

<img src="Demo/snapchat.gif"/>

## Why use this
* TRMosaicLayout is great for displaying images that are in portrait or have a similar aspect ratio
* Examples
  * Movie posters
  * Book covers
  * Magazines
  * News articles

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `TRMosaicLayout` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'TRMosaicLayout'
```

Then, import `TRMosaicLayout`

``` swift
import TRMosaicLayout
```

#### Manually
1. Download and drop ```/TRMosaicLayout```folder in your project.  
2. Congratulations!  

## Implementation
Create a subclass of `UICollectionViewController`
```swift
import TRMosaicLayout

class TRCollectionViewController: UICollectionViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

      let mosaicLayout = TRMosaicLayout()
      self.collectionView?.collectionViewLayout = mosaicLayout
      mosaicLayout.delegate = self
  }
}
```

Extend your subclass of `UICollectionViewController` with `TRMosaicLayoutDelegate`
```swift
extension TRCollectionViewController: TRMosaicLayoutDelegate {

  func collectionView(collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:NSIndexPath) -> TRMosaicCellType {
    // I recommend setting every third cell as .Big to get the best layout
    return indexPath.item % 3 == 0 ? TRMosaicCellType.Big : TRMosaicCellType.Small
  }

  func collectionView(collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
  }

  func heightForSmallMosaicCell() -> CGFloat {
    return 150
  }
}
```

## Troubleshooting

**The cell's aren't aligned properly**
* Make sure the views you are adding to the cell have the correct frame
 
```swift
  let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
  let imageView = UIImageView(image: image)
  imageView.frame = cell.frame
  cell.backgroundView = imageView
  return cell
```

**Getting a `nil while unwrapping` error**
* Make sure you set the delegate of `TRMosaicLayout` to your `collectionViewController`
* `mosaicLayout.delegate = self`

**Something else isn't working properly**
* Use github's issue reporter on the right, this will you be your best bet as I'm on Github fairly regularly
* Send me an email vinnyoodles@gmail.com

## Release History
  * 1.0.0 Update to Swift 3
  * 0.1.0 First release on CocoaPods

## Contributions

  I am happy to accept any open contributions. Just fork this project, make the changes and submit a pull request.

## Author

  Vincent Le, vinnyoodles@gmail.com

## License

  TRMosaicLayout is available under the ```MIT``` license. See the ```LICENSE``` file for more info.
