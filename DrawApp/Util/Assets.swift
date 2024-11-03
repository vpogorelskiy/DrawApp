//
//  Assets.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI

enum AppImage {
    public static var arrowLeft: UIImage { getImage(named: "Arrow-left") }
    public static var arrowRight: UIImage { getImage(named: "Arrow-right") }
    public static var bin: UIImage { getImage(named: "Bin") }
    public static var backgroundTexture: UIImage { getImage(named: "BackgroundTexture") }
    public static var brush: UIImage { getImage(named: "Brush") }
    public static var circle: UIImage { getImage(named: "Circle") }
    public static var erase: UIImage { getImage(named: "Erase") }
    public static var filePlus: UIImage { getImage(named: "File_Plus") }
    public static var Instruments: UIImage { getImage(named: "Instruments") }
    public static var Layers: UIImage { getImage(named: "Layers") }
    public static var palette: UIImage { getImage(named: "Palette") }
    public static var pencil: UIImage { getImage(named: "Pencil") }
    public static var play: UIImage { getImage(named: "Play") }
    public static var shapes: UIImage { getImage(named: "Shapes") }
    public static var square: UIImage { getImage(named: "Square") }
    public static var stop: UIImage { getImage(named: "Stop") }
    public static var triangle: UIImage { getImage(named: "Triangle") }
    
    private static func getImage(named: String) -> UIImage {
        UIImage(named: named, in: .main, compatibleWith: nil)!
    }
}

enum AppColor {
    public static var black: UIColor { getColor(named: "Black") }
    public static var blue: UIColor { getColor(named: "Blue") }
    public static var green: UIColor { getColor(named: "Green") }
    public static var grey: UIColor { getColor(named: "Grey") }
    public static var red: UIColor { getColor(named: "Red") }
    public static var white: UIColor { getColor(named: "White") }
    
    private static func getColor(named: String) -> UIColor {
        UIColor(named: named, in: .main, compatibleWith: nil)!
    }
}

