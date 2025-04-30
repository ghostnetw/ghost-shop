inShop = {}

lib.callback.register("ghost-shop:server:InShop", function(source, status)
	inShop[source] = status
end)
