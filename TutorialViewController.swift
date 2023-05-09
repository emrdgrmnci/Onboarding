//
//  TutorialViewController.swift
//  Tutorial
//
//  Created by Degirmenci Emre on 27.04.2023.
//

import UIKit
import Combine

extension UIScrollView {
    var visibleRect: CGRect {
        CGRect(origin: contentOffset, size: bounds.size)
    }
}

class TutorialViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var previousButton: UIButton!
    @IBOutlet private var pageControl: CustomPageControl!

    private var tutorialCollectionDataSource: TutorialCollectionDataSource!
    private let padding = 10.0
    private var colors = [Onboarding]()
    private var cancelBag = Set<AnyCancellable>()

    var viewModel = TutorialViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setupCollectionView()
        setupPreviousButton()
        setupNextButton()
        setObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPageControl()
    }

    // MARK: - Private

    private func setObservers() {
        cancelBag.removeAll()
        viewModel.images
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak tutorialCollectionDataSource] in
                tutorialCollectionDataSource?.updateData(items: $0)
                self.colors = $0
            }
            .store(in: &cancelBag)
    }

    private func setStyle() {
        view.backgroundColor = UIColor(named: "bgDarkGray")
        collectionView.backgroundColor = UIColor(named: "bgDarkGray")
    }

    private func setupCollectionView() {
        tutorialCollectionDataSource = TutorialCollectionDataSource(
            collectionView: collectionView
        )
        collectionView.delegate = tutorialCollectionDataSource
        collectionView.dataSource = tutorialCollectionDataSource
        tutorialCollectionDataSource?
            .scrollViewWillEndDragging = { [weak self] scrollView, velocity, targetContentOffset in
                self?.scrollViewWillEndDragging(
                    scrollView,
                    withVelocity: velocity,
                    targetContentOffset: targetContentOffset
                )
            }
    }

    private func setupPageControl() {
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = colors.count
        pageControl.currentPage = 0
        pageControl.clipsToBounds = false
    }

    private func setupPreviousButton() {
        previousButton.isHidden = true
        previousButton.setTitle("Previous", for: .normal)
        previousButton.setImage(UIImage(named: "arrow_left_white"), for: .normal)
    }

    private func setupNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.setImage(UIImage(named: "arrow_right_white"), for: .normal)
        nextButton.semanticContentAttribute = .forceRightToLeft
    }

    func scrollViewWillEndDragging(
        _: UIScrollView,
        withVelocity _: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let targetOffset = targetContentOffset.pointee.x
        let width = (collectionView.frame.size.width - padding) / 1.21
        let rounded = Double((colors.count / 2)) * abs(targetOffset / width)
        let scale = round(rounded)
        pageControl.currentPage = Int(scale)
        updateButtonStates(with: pageControl.currentPage)
        updateUI(with: pageControl.currentPage)
    }

    @IBAction
    func didTapOnPreviousButton(_: Any) {
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        pageControl.currentPage = prevIndex
        collectionView?.isPagingEnabled = false
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        updateButtonStates(with: pageControl.currentPage)
        updateUI(with: pageControl.currentPage)
    }

    @IBAction
    func didTapOnNextButton(_: Any) {
        let nextIndex = min(pageControl.currentPage + 1, colors.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.isPagingEnabled = false
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        updateButtonStates(with: pageControl.currentPage)
        updateUI(with: pageControl.currentPage)

        if nextButton.titleLabel?.text == "OK" {
            viewModel.didTapClose()
        }
    }

    private func updateUI(with currentPage: Int) {
        pageControl.currentPage = currentPage
        pageControl.indicatorImage(forPage: pageControl.currentPage)
        previousButton.isHidden = currentPage == 0
        nextButton.isHidden = currentPage == colors.count - 1
        if currentPage == colors.count - 1 {
            nextButton.isHidden = false
            nextButton.setImage(UIImage(), for: .normal)
            nextButton.setTitle("OK", for: .normal)
        } else {
            nextButton.setImage(UIImage(named: "arrow_right_white"), for: .normal)
            nextButton.setTitle("Next", for: .normal)
        }
    }

    private func updateButtonStates(with currentPage: Int) {
        pageControl.currentPage = currentPage
        previousButton.isEnabled = currentPage > 0
        nextButton.isEnabled = currentPage < colors.count
    }
}
