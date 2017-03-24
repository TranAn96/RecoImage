//
//  TestViewController.swift
//  ChineseHandleWritting
//
//  Created by Trần An on 3/23/17.
//  Copyright © 2017 Trần An. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let word = "Test"
        let path = UIBezierPath()
        let spacing: CGFloat = 50
        var i: CGFloat = 0
        for letter in word.characters {
            
            var newPath = getPathForLetter(letter: letter)
            
            
            
            
         
            
            
            
            let actualPathRect = path.cgPath.boundingBox
            let transform = CGAffineTransform(translationX: (actualPathRect.width + min(i, 1)*spacing), y: 0)
            newPath.apply(transform)
//
//            newPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100))
            let lines = CAShapeLayer()
            lines.path = newPath.cgPath
            lines.bounds = (lines.path?.boundingBox)!
            lines.strokeColor = UIColor.black.cgColor
            lines.fillColor = UIColor.clear.cgColor
            /*if you just want lines*/
            lines.lineWidth = 3
            lines.position = CGPoint(x: CGFloat(self.view.frame.size.width / 2.0) + i * 20, y: CGFloat(self.view.frame.size.height / 2.0))
            lines.anchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            self.view.layer.addSublayer(lines)
            
            path.append(newPath)
            i += 1
        }
    }

    func getPathForLetter(letter: Character) -> UIBezierPath {
        var path = UIBezierPath()
        let font = CTFontCreateWithName("HelveticaNeue" as CFString?, 64, nil)
        var unichars = [UniChar]("\(letter)".utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)
            path = UIBezierPath(cgPath: cgpath!)
        }
        
        return path
    }
}
