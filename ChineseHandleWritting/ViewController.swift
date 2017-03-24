//
//  ViewController.swift
//  ChineseHandleWritting
//
//  Created by Trần An on 3/21/17.
//  Copyright © 2017 Trần An. All rights reserved.
//

import UIKit
import HKChineseWords


class ViewController: UIViewController {
    
    
    
    @IBOutlet var paintView: LCPaintView!
    @IBOutlet weak var gifImageView: UIImageView!
    
    
    var wordArr = Array<String>()
    var index:Int = 0
    var imageArr = Array<UIImage>()
    var indexImageArr = 1
    
    override func viewWillAppear(_ animated: Bool) {
        print("COMPARE WHEN START IS : \(compareImages(image1: UIImage(named :"1.jpg")! , image2: UIImage(named :"3.jpg")!))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.touchEnd), name: NSNotification.Name(rawValue: "touchEnd"), object: nil)
        
        paintView.lineColor = UIColor.black
        paintView.lineWidth = 10
        
        print( (compareImages(image1: UIImage(named : "")!, image2: UIImage(named : "")!)))
        
       // testHKChineseWords("冇點難早前網上傳言今年新春氣溫會跌至個位數")

    }
    
    
    @IBAction func clearPaint(_ sender: Any) {
        paintView.clear()
        
    }
    
    @IBAction func undoPaint(_ sender: Any) {
        paintView.undo()
        
    }
//    func testHKChineseWords(_ text:String) {
//        for character in text.characters {
//            let char:String = String(character)
//            //            print(char)
//            wordArr.append(char)
//        }
//        
//        index = 0
//        testHKChineseWord(wordArr[index])
//    }
//    
//    func testHKChineseWord(_ word:String) {
//        print(HKChineseWords.sharedInstance.getInfo())
//        
//        HKChineseWords.sharedInstance.getImages(word) { (images:Array<UIImage>, error:Error?) in
//            print("error = \(error)")
//            if error == nil {
//                self.setImages(images)
//            } else {
//                // call next
//                self.didAnimationFinished()
//            }
//        }
//    }
//    
//    func setImages(_ images:Array<UIImage>) {
//        self.gifImageView.animationImages = images
//        self.gifImageView.animationDuration = Double(images.count)
////        self.gifImageView.animationDuration =
//        
//        print("NUMBER OF IMAGE IN GIF IS : \(images.count)")
//        self.gifImageView.animationRepeatCount = 2
//        self.imageArr = images
//       // self.gifImageView.startAnimating()
//        self.perform(#selector(ViewController.didAnimationFinished), with: nil, afterDelay: self.gifImageView.animationDuration)
//    }
//    
//    func didAnimationFinished() {
//        print("didAnimationFinished")
//        self.gifImageView.stopAnimating()
//        
//        if index < wordArr.count - 1 {
//            index += 1
//            testHKChineseWord(wordArr[index])
//        } else {
//            print("Test Complete!")
//        }
//    }
    
    // algt for compare 2 image
    
    func pixelValues(fromCGImage imageRef: CGImage?) -> [UInt8]?
    {
        var width = 0
        var height = 0
        var pixelValues: [UInt8]?
        
        if let imageRef = imageRef {
            width = imageRef.width
            height = imageRef.height
            let bitsPerComponent = imageRef.bitsPerComponent
            let bytesPerRow = imageRef.bytesPerRow
            let totalBytes = height * bytesPerRow
            let bitmapInfo = imageRef.bitmapInfo
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var intensities = [UInt8](repeating: 0, count: totalBytes)
            
            let contextRef = CGContext(data: &intensities,
                                       width: width,
                                       height: height,
                                       bitsPerComponent: bitsPerComponent,
                                       bytesPerRow: bytesPerRow,
                                       space: colorSpace,
                                       bitmapInfo: bitmapInfo.rawValue)
            contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
            
            pixelValues = intensities
        }
        
        return pixelValues
    }
    
    func compareImages(image1: UIImage, image2: UIImage) -> Double? {
        guard let data1 = pixelValues(fromCGImage: image1.cgImage),
            let data2 = pixelValues(fromCGImage: image2.cgImage),
            data1.count == data2.count else {
                return nil
        }
        
        let width = Double(image1.size.width)
        let height = Double(image1.size.height)
        
        return zip(data1, data2)
            .enumerated()
            .reduce(0.0) {
                $1.offset % 4 == 3 ? $0 : $0 + abs(Double($1.element.0) - Double($1.element.1))
            }
            * 100 / (width * height * 3.0) / 255.0
    }
    
    @IBAction func touchNext(_ sender: Any) {
        if(indexImageArr <= imageArr.count - 1){
        self.gifImageView.image = imageArr[indexImageArr]
              indexImageArr += 1
        }
    }
    func setImage(image1 : UIImage , image2  : UIImage) {
        print("COMPARE NOW IS :\(compareImages(image1: image1, image2: image2)!)")
      //  if compareImages(image1: image1, image2: image2)! < 10.0 {
            if(indexImageArr <= imageArr.count - 1){
                self.gifImageView.image = imageArr[indexImageArr]
                indexImageArr += 1
       //     }

        }
    }
    func resizeImage(image: UIImage, newWidth: CGFloat , newHeight : CGFloat) -> UIImage {
        
    //   let scale = newWidth / image.size.width
     //   let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let images = UIImageJPEGRepresentation(newImage!, 1)
        return UIImage(data: images!)!
    }
    func touchEnd(){
        self.setImage(image1:self.resizeImage(image:UIImage(view : paintView), newWidth: 512, newHeight: 512) , image2: UIImage(named : "1.jpg")!)
    }
}
extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}
