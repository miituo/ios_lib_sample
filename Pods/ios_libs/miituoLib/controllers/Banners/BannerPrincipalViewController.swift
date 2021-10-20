//
//  BannerPrincipalViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 10/11/20.
//

import UIKit

class BannerPrincipalViewController: UIPageViewController {
    
    weak var tutorialDelegate: BannerPrincipalViewControllerDelegate?
    var indice = 1
    let tiempo = 5
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(color: "sega"),
                self.newColoredViewController(color: "segb")
        //        self.newColoredViewController(color: "third")
        ]
        //self.newColoredViewController(color: "four")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataSource = self //as! UIPageViewControllerDataSource
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            /*setViewControllers([firstViewController],
             direction: .forward,
             animated: true,
             completion: nil)
             */
            //scrollToViewController(firstViewController)
            scrollToViewController(viewController: firstViewController)
        }
        
        _ = Timer.scheduledTimer(timeInterval: 9, target: self, selector: #selector(scrollToViewController), userInfo: nil, repeats: true)
        
        tutorialDelegate?.onboardingViewController(tutorialPageViewController: self, didUpdatePageCount: orderedViewControllers.count)
    }
    
    fileprivate func newColoredViewController(color: String) -> UIViewController {
        let bundle = Bundle(for: PolizasViewController.self)
        return UIStoryboard(name: "Polizas", bundle: bundle) .
            instantiateViewController(withIdentifier: "\(color)SB")
    }
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter:  visibleViewController) {
            //let nextViewController = pageViewController(self,viewControllerAfterViewController: visibleViewController) {
            //scrollToViewController(nextViewController)
            scrollToViewController(viewController: nextViewController)
        }
    }
    
    @objc func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
           let currentIndex = orderedViewControllers.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            //let nextViewController = orderedViewControllers[newIndex]
            let nextViewController = orderedViewControllers[indice]
            scrollToViewController(viewController: nextViewController, direction: direction)
            
            indice += 1
            if indice >= 2{
                indice = 0
            }
        }
    }
    
    fileprivate func scrollToViewController(viewController: UIViewController,
                                            direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyTutorialDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    @objc fileprivate func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
           let index = orderedViewControllers.firstIndex(of: firstViewController) {
            //tutorialDelegate?.onboardingViewController(self,didUpdatePageIndex: index)
            tutorialDelegate?.onboardingViewController(tutorialPageViewController: self, didUpdatePageIndex: index)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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

extension BannerPrincipalViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
            //return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
            //return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
}


extension BannerPrincipalViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        notifyTutorialDelegateOfNewIndex()
        
        /*if let firstViewController = viewControllers?.first,
         let index = orderedViewControllers.index(of: firstViewController) {
         tutorialDelegate?.onboardingViewController(tutorialPageViewController: self, didUpdatePageIndex: index)
         //tutorialDelegate?.onboardingViewController(self,                                                         didUpdatePageIndex: index)
         }*/
    }
    
}

protocol BannerPrincipalViewControllerDelegate: AnyObject {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func onboardingViewController(tutorialPageViewController: BannerPrincipalViewController,
                                  didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func onboardingViewController(tutorialPageViewController: BannerPrincipalViewController,
                                  didUpdatePageIndex index: Int)
}
