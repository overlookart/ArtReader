//
//  ReaderCenter.swift
//  ArtReader
//
//  Created by xzh on 2023/7/16.
//

import UIKit
import LAWebView
import SnapKit
class ReaderCenter: UIViewController {

    var epubBook: EpubBook?
    var baseURL: URL?
    
    let pageVC: UIPageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    
    var readPages: [ReadPageVC] = [ReadPageVC(), ReadPageVC(), ReadPageVC()]
    var pendingVC: ReadPageVC?
    var dataSource: [Spine.SpineItem] = []
    /// 当前的下标
    var currentIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        setupData()
        pageVC.delegate = self
        pageVC.dataSource = self
        self.navigationController?.hidesBarsOnTap = true
        pageVC.setViewControllers([readPages[1]], direction: .forward, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func setupUI(){
        self.addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    private func setupData(){
        guard let book = epubBook else { return }
        dataSource = book.spines
        readPages[0].spine = currentIndex - 1 < 0 ? nil : dataSource[currentIndex-1]
        readPages[0].baseURL = baseURL
        readPages[1].spine = dataSource[currentIndex]
        readPages[1].baseURL = baseURL
        readPages[2].spine = currentIndex + 1 > dataSource.count-1 ? nil : dataSource[currentIndex+1]
        readPages[2].baseURL = baseURL
    }
    
    private func index(OfPage page: ReadPageVC) -> Int? {
        guard let spine = page.spine else { return nil }
        return dataSource.firstIndex(of: spine)
    }
    
    private func setupPageData(currentPage: ReadPageVC){
        guard let index = readPages.firstIndex(of: currentPage) else { return }
        let readPage0 = readPages[0]
        let readPage1 = readPages[1]
        let readPage2 = readPages[2]
        debugPrint(index)
        if index == 0 {
            readPages = [readPage2,readPage0,readPage1]
            readPages[0].spine = currentIndex - 1 < 0 ? nil : dataSource[currentIndex-1]
            readPages[0].loadContent()
        }else if index == 2 {
            readPages = [readPage1,readPage2,readPage0]
            readPages[2].spine = currentIndex + 1 > dataSource.count-1 ? nil : dataSource[currentIndex+1]
            readPages[2].loadContent()
        }
    }
    
}


extension ReaderCenter: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        return .min
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first as? ReadPageVC {
            pendingVC = vc
            debugPrint("开始翻页", readPages.firstIndex(of: vc))
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }
        if let vc = pendingVC {
            if let index = index(OfPage: vc) {
                currentIndex = index
                debugPrint("结束翻页", finished, completed, vc.title, currentIndex)
                setupPageData(currentPage: vc)
            }
        }
    }
    
//    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
//
//    }
//
//    func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
//
//    }
}

extension ReaderCenter: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard readPages[0].spine != nil else {
            return nil
        }
        debugPrint("上一页")
        return readPages[0]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard readPages[2].spine != nil else {
            return nil
        }
        debugPrint("下一页")
        return readPages[2]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return readPages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
    
}
