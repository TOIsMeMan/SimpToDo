//
//  task.swift
//  Simp To do
//
//  Created by MacBook Pro on 28/09/2023.
//

import Foundation

struct task: Codable {
    var done = false
    var title: String = ""
    let id: String = Date().timeIntervalSince1970.description
}
