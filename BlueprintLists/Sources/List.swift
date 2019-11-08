//
//  List.swift
//  BlueprintLists
//
//  Created by Kyle Van Essen on 10/22/19.
//

import BlueprintUI

import Listable


public struct List : BlueprintUI.Element
{
    public var listDescription : ListDescription
    
    //
    // MARK: Initialization
    //
        
    public init(build : ListDescription.Build)
    {
        self.listDescription = ListDescription(build: build)
    }
    
    //
    // MARK: BlueprintUI.Element
    //
    
    public var content : ElementContent {
        return ElementContent(layout: Layout())
    }
    
    public func backingViewDescription(bounds: CGRect, subtreeExtent: CGRect?) -> ViewDescription?
    {
        return ListView.describe { config in
            config.builder = {
                return ListView(frame: bounds, appearance: self.listDescription.appearance)
            }
            
            config.apply { listView in
                listView.appearance = self.listDescription.appearance
                listView.setContent(animated: true, self.listDescription.content)
            }
        }
    }
    
    //
    // MARK: Blueprint Layout Definition
    //
    
    private struct Layout : BlueprintUI.Layout
    {
        func measure(in constraint: SizeConstraint, items: [(traits: (), content: Measurable)]) -> CGSize
        {
            return constraint.maximum
        }
        
        func layout(size: CGSize, items: [(traits: (), content: Measurable)]) -> [LayoutAttributes]
        {
            return []
        }
    }
}


public struct ListDescription
{
    public var appearance : Listable.Appearance
    public var content : Listable.Content

    public typealias Build = (inout ListDescription) -> ()
    
    public init(build : Build)
    {
        self.appearance = Listable.Appearance()
        self.content = Listable.Content()
        
        build(&self)
    }
    
    public mutating func add(_ section : Section)
    {
        self.content.sections.append(section)
    }
    
    public static func += (lhs : inout ListDescription, rhs : Section)
    {
        lhs.add(rhs)
    }
    
    public static func += (lhs : inout ListDescription, rhs : [Section])
    {
        lhs.content.sections += rhs
    }
}