module(..., package.seeall)

local touchX, touchY = 0, 0

function onCreate(params)
    mapLoader = TMXMapLoader()
    mapData = mapLoader:loadFile("platform.tmx")

    mapView = TMXMapView()
    mapView:loadMap(mapData)
    mapView:setScene(scene)
end

function onTouchMove(e)
    local vScaleX, vScaleY = Application:getViewScale()
    mapView.camera:addLoc(-e.moveX / vScaleX, -e.moveY / vScaleY, 0)
end