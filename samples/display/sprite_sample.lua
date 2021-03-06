module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}

    -- Can be set in the parameter of the argument.
    sprite1 = Sprite {texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 0}
    
    -- Values ​​can be set later.
    sprite2 = Sprite {texture = "cathead.png", layer = layer}
    sprite2:setPos(0, sprite1:getBottom())
    
    -- Values ​​can be set later.
    sprite3 = Sprite {texture = "cathead.png"}
    sprite3:setLeft(0)
    sprite3:setTop(sprite2:getBottom())
    layer:insertProp(sprite3)

    -- It supports an empty constructor.
    sprite4 = Sprite()
    sprite4:setTexture("cathead.png")
    sprite4:setSize(64, 64)
    sprite4:setPos(0, sprite3:getBottom())
    sprite4:setLayer(layer)
    
    -- If the first argument string, and the texture parameters.
    sprite5 = Sprite("cathead.png")
    sprite5:setPos(sprite1:getRight() + 10, 0)
    sprite5:setLayer(layer)

    -- Resource look up.
    sprite6 = Sprite("cathead.png")
    sprite6:setPos(sprite1:getRight() + 10, sprite5:getBottom() + 10)
    sprite6:setLayer(layer)

    printProperties(sprite1)
    printProperties(sprite2)
    printProperties(sprite3)
    printProperties(sprite4)
    printProperties(sprite5)

end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToBottom"})
end

function printProperties(obj)
    -- DisplayObject base properties
    print("----- DisplayObject properties -----")
    print("width", obj:getWidth())
    print("height", obj:getHeight())
    print("size", obj:getSize())
    print("left", obj:getLeft())
    print("right", obj:getRight())
    print("top", obj:getTop())
    print("bottom", obj:getBottom())
    print("color", obj:getColor())
    print("red", obj:getRed())
    print("green", obj:getGreen())
    print("blue", obj:getBlue())
    print("alpha", obj:getAlpha())

end
