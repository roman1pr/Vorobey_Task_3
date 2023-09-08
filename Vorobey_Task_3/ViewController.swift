//
//  ViewController.swift
//  Vorobey_Task_3
//
//  Created by Roman Priiskalov on 08.09.2023.
//

import UIKit

//На экране квадратная вью и слайдер. Вью перемещается из левого края в правый с поворотом и увеличением.
//
//- В конечной точке вью должна быть справа (минус отступ), увеличится в 1.5 раза и повернуться на 90 градусов.
//- Когда отпускаем слайдер, анимация идет до конца с текущего места.
//- Слева и справа отступы layout margins. Отступ как для квадратной вью, так и для слайдера.

class ViewController: UIViewController {
    private var squareView: UIView!
    private var slider: UISlider!
    
    private var animator: UIViewPropertyAnimator?
    let animationDuration = 0.8
    let animationTransformScaleFactor: Float = 1.5
    let squareSize: CGFloat = 100
    let margin: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        slider = UISlider(frame: CGRect(x: margin, y: 250, width: view.bounds.width - 2 * margin, height: 50))
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        view.addSubview(slider)
        
        squareView = UIView(frame: CGRect(x: margin, y: 100, width: squareSize, height: squareSize))
        squareView.backgroundColor = .gray
        squareView.layer.cornerRadius = 4
        view.addSubview(squareView)
        
    }
    
    @objc private func sliderTouchDown() {
        animator?.stopAnimation(true)
    }
    
    @objc private func sliderTouchUp() {
        animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut) { [weak self] in
            self?.updateSquare(value: 1.0)
            self?.slider.setValue(1.0, animated: true)
        }
        animator?.startAnimation()
    }
    
    @objc private func valueChanged() {
        self.updateSquare(value: slider.value)
    }
    
    func updateSquare(value: Float) {
        let finalCenterX = view.bounds.width - ((squareSize) * CGFloat(animationTransformScaleFactor)) - margin
        
        let updatedValueTransform = value * (animationTransformScaleFactor - 1) + 1.0
        let updatedRotationAngle = value * (.pi / 2)
        let updatedCenterX = margin + (squareSize / 2) + (finalCenterX * CGFloat(value))

        let scaleTransform = CGAffineTransform(scaleX: CGFloat(updatedValueTransform),
                                               y: CGFloat(updatedValueTransform))
        let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(updatedRotationAngle))
        
        squareView.transform = scaleTransform.concatenating(rotationTransform)
        squareView.center.x = updatedCenterX
    }
}
