//
//  Badge.swift
//  TodoList
//
//  Created by Christopher Fields on 12/3/19.
//  Copyright © 2019 Christopher Fields. All rights reserved.
//

import SwiftUI

struct Badge: View {
    var text: String
    var backgroundColor: Color
    
    var body: some View {
        Text(text)
            .fontWeight(.medium)
            .foregroundColor(.white)
//            .frame(width: 32, height: 32)
            .font(.system(size: 16))
            .background(backgroundColor)
            .cornerRadius(64/2)
            .padding(.all, 20)
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge(text:"3/5", backgroundColor: Color.blue)
    }
}
