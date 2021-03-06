----------------------------------------------------------------
-- This is a class to grouping the DisplayObject. <br>
-- Will be used as a dummy MOAIProp. <br>
-- Base Classes => DisplayObject, Resizable <br>
--
-- @auther Makoto
-- @class table
-- @name Group
----------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local delegate = require("hp/lang/delegate")
local DisplayObject = require("hp/display/DisplayObject")
local Resizable = require("hp/display/Resizable")

local M = class(DisplayObject, Resizable)

local MOAIPropInterface = MOAIProp.getInterfaceTable()

----------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
----------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)

    params = params or {}

    self.children = {}

    self:setPrivate("width", 0)
    self:setPrivate("height", 0)

    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- Set the parameter setter function.
-- @param params Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.width then
        self:setWidth(params.width)
    end
    if params.height then
        self:setHeight(params.height)
    end

    DisplayObject.copyParams(self, params)
end

----------------------------------------------------------------
-- Returns the bounds of the object.
-- @return xMin, yMin, zMin, xMax, yMax, zMax
----------------------------------------------------------------
function M:getBounds()
    local xMin, yMin, zMin = 0, 0, 0
    local xMax, yMax, zMax = self:getWidth(), self:getHeight(), 0
    return xMin, yMin, zMin, xMax, yMax, zMax
end

--------------------------------------------------------------------------------
-- Returns the width.
-- @return width
--------------------------------------------------------------------------------
function M:getWidth()
    return self:getPrivate("width")
end

----------------------------------------------------------------
-- Returns the height.
-- @return height
----------------------------------------------------------------
function M:getHeight()
    return self:getPrivate("height")
end

--------------------------------------------------------------------------------
-- Sets the width and height.
-- @param width width
-- @param height height
--------------------------------------------------------------------------------
function M:setSize(width, height)
    self:setPrivate("width", width)
    self:setPrivate("height", height)
end

----------------------------------------------------------------
-- Set the visible.
-- @param visible visible
----------------------------------------------------------------
function M:setVisible(visible)
    MOAIPropInterface.setVisible(self, visible)
    
    for i, v in ipairs(self.children) do
        if v.setVisible then
            v:setVisible(visible)
        end
    end
end

----------------------------------------------------------------
-- Set the center of the pivot.
----------------------------------------------------------------
function M:setCenterPiv()
    local left, top = self:getPos()
    local pivX = self:getWidth() / 2
    local pivY = self:getHeight() / 2
    self:setPiv(pivX, pivY, 0)
    self:setPos(left, top)
end

----------------------------------------------------------------
-- Resize based on the location and size of the child elements.
----------------------------------------------------------------
function M:resizeForChildren()
    local maxWidth, maxHeight = 0, 0
    for i, child in ipairs(self:getChildren()) do
       maxWidth = math.max(maxWidth, child:getRight())
       maxHeight = math.max(maxHeight, child:getBottom())
    end
    self:setSize(maxWidth, maxHeight)
end

----------------------------------------------------------------
-- Returns the children object.
-- If you want to use this function with caution.<br>
-- direct manipulation table against children are not reflected in the Group.<br>
-- @return children
----------------------------------------------------------------
function M:getChildren()
    return self.children
end

----------------------------------------------------------------
-- Returns the childr object.
-- @param i Index.
-- @return child
----------------------------------------------------------------
function M:getChildAt(i)
    return self.children[i]
end

----------------------------------------------------------------
-- Add a child object. <br>
-- The child object to duplicate is not added. <br>
-- If you have set the Layer to the group, the layer is set to the child.
-- @param Child to inherit the MOAIProp.
----------------------------------------------------------------
function M:addChild(child)
    local index = table.indexOf(self.children, child)
    if index > 0 then
        return
    end
    
    table.insert(self.children, child)
    child:setParent(self)
    
    if self.layer then
        if child.setLayer then
            child:setLayer(self.layer)
        end
    end
end

----------------------------------------------------------------
-- Remove the child object. <br>
-- If you have set the Layer to the group, layer of the child is removed.
-- @param Child to inherit the MOAIProp.
----------------------------------------------------------------
function M:removeChild(child)
    local children = self.children
    local index = table.indexOf(children, child)
    if index <= 0 then
        return
    end
    
    child:setParent(nil)
    
    if self.layer then
        if child.setLayer then
            child:setLayer(nil)
        end
    end
    
    table.remove(children, index)
end

--------------------------------------------------------------------------------
-- Remove the children object.
--------------------------------------------------------------------------------
function M:removeChildren()
    for i, child in ipairs(self:getChildren()) do
        self:removeChild(child)
    end
end

--------------------------------------------------------------------------------
-- Set the layer of the same for children.
-- @param layer MOAILayer instance.
--------------------------------------------------------------------------------
function M:setLayer(layer)
    self.layer = layer
    for i, child in ipairs(self.children) do
        if child.setLayer then
            child:setLayer(layer)
        end
    end
end

--------------------------------------------------------------------------------
-- Returns true if the group.<br>
-- Are used in internal decision.
--------------------------------------------------------------------------------
function M:isGroup()
    return true
end

--------------------------------------------------------------------------------
-- If the object will collide with the screen, it returns true.<br>
-- @param screenX x of screen
-- @param screenY y of screen
-- @param screenZ (option)z of screen
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestScreen(screenX, screenY, screenZ)
    assert(self.layer)
    screenZ = screenZ or 0
    
    for i, child in ipairs(self.children) do
        if child.hitTestScreen then
            if child:hitTestScreen(screenX, screenY, screenZ) then
                return true
            end
        else
            local worldX, worldY, worldZ = self.layer:wndToWorld(screenX, screenY, screenZ)
            if child:inside(worldX, worldY, worldZ) then
                return true
            end
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- If the object will collide with the world, it returns true.<br>
-- @param worldX world x of layer
-- @param worldY world y of layer
-- @param worldZ (option)world z of layer
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestWorld(worldX, worldY, worldZ)
    worldZ = worldZ or 0
    
    for i, child in ipairs(self.children) do
        if child.hitTestWorld then
            if child:hitTestWorld(worldX, worldY, worldZ) then
                return true
            end
        else
            if child:inside(worldX, worldY, worldZ) then
                return true
            end
        end
    end
    return false
end

return M