module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}

    particle = Particles.fromPex("deathBlossomCharge.pex")
    particle:setLayer(layer)
end

function onStart()
    particle.emitter:setLoc(100, 100)
    particle.emitter:forceUpdate()
    particle:start()
    particle.emitter:start()
end

function onTouchDown(e)
    local wx, wy = layer:wndToWorld(e.x, e.y, 0)
    particle.emitter:setLoc(wx, wy, 0)
    particle.emitter:forceUpdate()
    particle:startParticle()
end

function onTouchMove(e)
    --particle.emitter:addLoc(e.moveX, e.moveY, 0)
end

function onTouchUp(e)
    particle:stopParticle()
    
end