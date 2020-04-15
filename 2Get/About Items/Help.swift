//
//  Help.swift
//  toget-test
//
//  Created by Michael Hamm on 3/24/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit

class Help: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var helpScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var images: [String] = ["2Get_Help1","2Get_Help2","2Get_Help3","2Get_Help4","2Get_Help5","2Get_Help6"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = images.count
        
        for index in 0..<images.count {
            frame.origin.x = helpScrollView.frame.size.width * CGFloat(index)
            frame.size = helpScrollView.frame.size

            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images[index])
            self.helpScrollView.addSubview(imgView)
        }

        helpScrollView.contentSize = CGSize(width: helpScrollView.frame.size.width * CGFloat(images.count), height: helpScrollView.frame.size.height)
        helpScrollView.delegate = self
        
    }
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}
