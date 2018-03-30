
local composer = require( "composer" )
local function startUp()
	composer.gotoScene( "sceneStartUp" , {effect = "fade", time = 1000} )
end
timer.performWithDelay( 800, startUp)