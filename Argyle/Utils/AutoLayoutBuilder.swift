//
//  AutoLayoutBuilder.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import UIKit

/// https://www.avanderlee.com/swift/result-builders/
@resultBuilder
struct AutoLayoutBuilder {

    static func buildBlock(_ components: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
        components.flatMap { $0 }
    }

    /// Add support for both single and collections of constraints.
    static func buildExpression(_ expression: NSLayoutConstraint) -> [NSLayoutConstraint] {
        [expression]
    }

    static func buildExpression(_ expression: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        expression
    }

    /// Add support for optionals.
    static func buildOptional(_ components: [NSLayoutConstraint]?) -> [NSLayoutConstraint] {
        components ?? []
    }

    /// Add support for if statements.
    static func buildEither(first components: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        components
    }

    static func buildEither(second components: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        components
    }

    static func buildArray(_ components: [[NSLayoutConstraint]]) -> [NSLayoutConstraint] {
        components.flatMap { $0 }
    }

    static func buildLimitedAvailability(_ components: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        components
    }
}

extension NSLayoutConstraint {
   /// Activate the layouts defined in the result builder parameter `constraints`.
   static func activate(@AutoLayoutBuilder constraints: () -> [NSLayoutConstraint]) {
       activate(constraints())
   }
}

extension UIView {
    /// Add a child subview and directly activate the given constraints.
    func addSubview<View: UIView>(_ view: View, @AutoLayoutBuilder constraints: (UIView, View) -> [NSLayoutConstraint]) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints(self, view))
    }

    func addSubviewMatchingConstraints<View: UIView>(_ view: View) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate {
            view.topAnchor.constraint(equalTo: self.topAnchor)
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        }
    }
}
