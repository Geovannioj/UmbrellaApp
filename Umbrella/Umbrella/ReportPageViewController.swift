//
//  ReportPageViewController.swift
//  Umbrella
//
//  Created by Bruno Chagas on 01/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class ReportPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var reportDelegate: ReportDelegate?
    var pageControl: UIPageControl?
    
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(storyboard: "RegisterReportFirst", name: "RegisterReportViewController"),
                self.VCInstance(storyboard: "RegisterReportSecond", name: "RegisterReportSecondViewController")]
    }()
    
    private func VCInstance(storyboard: String, name: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        
        
        
        if let firstVC = VCArray.first {
            setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reportDelegate?.changeBannerVisibility()
        reportDelegate?.changeBlurViewVisibility()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subview in self.view.subviews {
            if subview is UIScrollView {
                subview.translatesAutoresizingMaskIntoConstraints = false
                
                subview.frame = CGRect(x: 0, y: 0, width: 355, height: 627)
//                subview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//                subview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//                subview.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//                subview.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
             
//                subview.backgroundColor = .clear
            } else if subview is UIPageControl {
                pageControl = subview as? UIPageControl
                subview.isUserInteractionEnabled = false
                subview.backgroundColor = .clear
            }
        }
    }
    
    func setupButtons() {
        
        let nextButton = UIButton(frame: CGRect())
        nextButton.setTitle("Proximo >", for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.backgroundColor = .blue
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextButton.isUserInteractionEnabled = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        view.addSubview(nextButton)
        
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let backButton = UIButton(frame: CGRect())
        backButton.setTitle("< Voltar", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.backgroundColor = .blue
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        backButton.isUserInteractionEnabled = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(previousPage), for: .touchUpInside)

        view.addSubview(backButton)
        
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func nextPage() {
        if let visibleViewController = viewControllers?.first{
            if let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
                scrollToViewController(viewController: nextViewController, direction: .forward)
            }
        }
    }
    
    func previousPage() {
        if let visibleViewController = viewControllers?.first{
            if let previousViewController = pageViewController(self, viewControllerBefore: visibleViewController) {
                scrollToViewController(viewController: previousViewController, direction: .reverse)
            }
        }
    }
    
//    func scrollToViewController(index newIndex: Int) {
//        if let firstViewController = viewControllers?.first,
//            let currentIndex = orderedViewControllers.indexOf(firstViewController) {
//            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .Forward : .Reverse
//            let nextViewController = orderedViewControllers[newIndex]
//            scrollToViewController(nextViewController, direction: direction)
//        }
//    }
    
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection) {
        print(self)
        //print(viewController)
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
            
            if let firstViewController = self.viewControllers?.first {
                if let index = self.VCArray.index(of: firstViewController) {
                    self.pageControl?.currentPage = index
                }
            }
        })
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard VCArray.count > previousIndex else {
            return nil
        }
        
        return VCArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex <= VCArray.count else {
            return nil
        }
        
        guard VCArray.count > nextIndex else {
            return nil
        }
        
        return VCArray[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = VCArray.index(of: firstViewController) else {
            
            return 0
        }
        
        return firstViewControllerIndex
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
