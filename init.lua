HYDRO_GROW_INTERVAL = 100
PLANTS = {
	tomato = {name='tomato',growtype='growtall'},
	peas = {name='peas',growtype='growtall'},
	habanero = {name='habanero',growtype='growtall'},
	grapes = {name='grapes',growtype='permaculture'},
	coffee = {name='coffee',growtype='permaculture'},
	roses = {name='roses',growtype='growtall',give_on_harvest='hydro:rosebush'}
}

PLANTLIKE = function(nodeid, nodename,type,option)
	if option == nil then option = false end

	local params ={ description = nodename, drawtype = "plantlike", tile_images = {"hydro_"..nodeid..'.png'}, 
	inventory_image = "hydro_"..nodeid..'.png',	wield_image = "hydro_"..nodeid..'.png', paramtype = "light",	}
		
	if type == 'veg' then
		params.groups = {snappy=2,dig_immediate=3,flammable=2}
		params.sounds = default.node_sound_leaves_defaults()
		if option == false then params.walkable = false end
	elseif type == 'met' then			-- metallic
		params.groups = {cracky=3}
		params.sounds = default.node_sound_stone_defaults()
	elseif type == 'cri' then			-- craft items
		params.groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,flammable=3}
		params.sounds = default.node_sound_wood_defaults()
		if option == false then params.walkable = false end
	elseif type == 'eat' then			-- edible
		params.groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,flammable=3}
		params.sounds = default.node_sound_wood_defaults()
		params.walkable = false
		params.on_use = minetest.item_eat(option)
	end
	minetest.register_node("hydro:"..nodeid, params)
end
GLOWLIKE = function(nodeid,nodename,drawtype)
	if drawtype == nil then 
		drawtype = 'glasslike'
		inv_image = minetest.inventorycube("hydro_"..nodeid..".png")
	else 
		inv_image = "hydro_"..nodeid..".png" 
	end
	minetest.register_node("hydro:"..nodeid, {
		description = nodename,
		drawtype = drawtype,
		tile_images = {"hydro_"..nodeid..".png"},
		inventory_image = inv_image,
		light_propagates = true,
		paramtype = "light",
		sunlight_propagates = true,
		light_source = 15	,
		is_ground_content = true,
		groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
		sounds = default.node_sound_glass_defaults(),
	})
end

PLANTLIKE('wine','Wine Bottle','eat',1)
PLANTLIKE('coffeecup','Coffee Cup','eat',2)
GLOWLIKE('growlamp','Growlamp','plantlike')
minetest.register_node("hydro:promix", {
	description = "Promix",
	tile_images = {"hydro_promix.png"},
	is_ground_content = true,
	groups = {crumbly=3},
	sounds = default.node_sound_dirt_defaults(),
})
minetest.register_node("hydro:roastedcoffee", {
	description = "Roasted Coffee",
	tile_images = {"hydro_roastedcoffee.png"},
	inventory_image = minetest.inventorycube("hydro_roastedcoffee.png"),
	is_ground_content = true,
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("hydro:rosebush", {
	description = "Rose Bush",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tile_images = {"hydro_rosebush.png"},
	paramtype = "light",
	groups = {snappy=3,  flammable=2},
	sounds = default.node_sound_leaves_defaults(),
})

get_plantname = {}		-- plants index by nodenames (tomato1, tomato2, seeds_tomato, etc..)
get_plantbynumber = {}		-- plants index by number (for random select)
get_wildplants = {}		-- wildplant nodenames (pop control)

local is_specialharvest = function(plantname)
	local result = 'hydro:'..plantname
	if PLANTS[plantname].give_on_harvest ~= nil then result =  PLANTS[plantname].give_on_harvest end
	return result
end

for index,plant in pairs(PLANTS) do 
		--		define nodes
	minetest.register_node("hydro:wild_"..plant.name, {
		description = "Wild Plant",
		drawtype = "plantlike",
		visual_scale = 1.0,
		tile_images = {"hydro_wildplant.png"},
		paramtype = "light",
		walkable = false,
		groups = {snappy=3,flammable=3},
		sounds = default.node_sound_leaves_defaults(),
		drop = 'hydro:seeds_'..plant.name..' 4',
		selection_box = {
			type = "fixed",
			fixed = {-1/3, -1/2, -1/3, 1/3, 1/6, 1/3},
		},
	})
	minetest.register_node("hydro:seeds_"..plant.name, {
		description = plant.name.." Seeds",
		drawtype = "signlike",
		tile_images = {"hydro_seeds.png"},
		inventory_image = "hydro_seeds.png",
		wield_image = "hydro_seeds.png",
		paramtype = "light",
		paramtype2 = "wallmounted",
		is_ground_content = true,
		walkable = false,
		climbable = false,
		selection_box = {
			type = "wallmounted",
			--wall_top = = <default>
			--wall_bottom = = <default>
			--wall_side = = <default>
		},
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3},
		legacy_wallmounted = true,
		sounds = default.node_sound_wood_defaults(),
	})
	minetest.register_node('hydro:seedlings_'..plant.name, {
		drawtype = 'plantlike',
		visual_scale = 1.0,
		tile_images = { 'hydro_seedlings.png' },
		inventory_image = 'hydro_seedlings.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		furnace_burntime = 1,
		groups = { snappy = 3 },
		sounds = default.node_sound_leaves_defaults(),
		drop = '',
	})
	minetest.register_node('hydro:sproutlings_' .. plant.name, {
		drawtype = 'plantlike',
		visual_scale = 1.0,
		tile_images = { 'hydro_sproutlings.png' },
		inventory_image = 'hydro_sproutlings.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		furnace_burntime = 1,
		groups = { snappy = 3 },
		sounds = default.node_sound_leaves_defaults(),
		drop = '',
	})
	minetest.register_node('hydro:'..plant.name..'1', {
		description = 'Tomato Plant (Young)',
		drawtype = 'plantlike',
		visual_scale = 1.0,
		tile_images = { 'hydro_'..plant.name..'1.png' },
		inventory_image = 'hydro_'..plant.name..'1.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		furnace_burntime = 1,
		groups = { snappy = 3 },
		sounds = default.node_sound_leaves_defaults(),
		drop = '',
	})

	local after_dig_node = nil
	if plant.growtype == 'permaculture' then
		plant.growtype = 'growshort'
		after_dig_node = function(pos,node)
			minetest.add_node(pos,{type='node',name='hydro:'..plant.name..'1'})
		end

	end
	minetest.register_node('hydro:'..plant.name..'2', {
		description = 'Tomato Plant (Youngish)',
		drawtype = 'plantlike',
		visual_scale = 1.0,
		tile_images = { 'hydro_'..plant.name..'2.png' },
		inventory_image = 'hydro_'..plant.name..'2.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		furnace_burntime = 1,
		groups = { snappy = 3 },
		sounds = default.node_sound_leaves_defaults(),
		drop = '',
	})
	minetest.register_node('hydro:'..plant.name..'3', {
		description = 'Tomato Plant (Fruitings)',
		drawtype = 'plantlike',
		visual_scale = 1.0,
		tile_images = { 'hydro_'..plant.name..'3.png' },
		inventory_image = 'hydro_'..plant.name..'3.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		furnace_burntime = 1,
		groups = { snappy = 3 },
		sounds = default.node_sound_leaves_defaults(),
		drop = '',
	})
	

	local harvest = 'hydro:'..plant.name
	if plant.give_on_harvest then harvest = plant.give_on_harvest end
	
	minetest.register_node('hydro:'..plant.name..'4', {
		description = 'Tomato Plant (Ripe)',
		drawtype = 'plantlike',
		visual_scale = 1.0,
		tile_images = { 'hydro_'..plant.name..'4.png' },
		inventory_image = 'hydro_'..plant.name..'4.png',
		sunlight_propagates = true,
		paramtype = 'light',
		walkable = false,
		furnace_burntime = 1,
		groups = { snappy = 3 },
		sounds = default.node_sound_leaves_defaults(),
		after_dig_node = after_dig_node,
		drop = { 
				items = {
					{	items = {'hydro:seeds_'..plant.name..' 4'},
						rarity = 4,
					},
					{
						items = {harvest..' 2'},
					}
				}
		},

	})
	if plant.give_on_harvest == nil then
		minetest.register_node("hydro:"..plant.name, {
			description = plant.name,
			drawtype = "plantlike",
			visual_scale = 1.0,
			tile_images = {"hydro_"..plant.name..".png"},
			inventory_image = "hydro_"..plant.name..".png",
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,
			groups = {fleshy=3,dig_immediate=3,flammable=2},
			on_use = minetest.item_eat(4),
			sounds = default.node_sound_defaults(),
		})
	end
	table.insert(get_wildplants, 'hydro:wild_'..plant.name)
	table.insert(get_plantbynumber, plant.name)
	get_plantname["hydro:"..plant.name.."4"] = plant.name
	get_plantname["hydro:"..plant.name.."3"] = plant.name
	get_plantname["hydro:"..plant.name.."2"] = plant.name
	get_plantname["hydro:"..plant.name.."1"] = plant.name
	get_plantname['hydro:sproutlings_'..plant.name] = plant.name
	get_plantname['hydro:seedlings_'..plant.name] =  plant.name
	get_plantname['hydro:seeds_'..plant.name] = plant.name
end

--		GROW (TALL) FUNCTION
growtall = function (plantname, nodename, grnode)
	if nodename == 'hydro:'..plantname..'3' 			then
		minetest.add_node(grnode.grow1,{name="hydro:"..plantname.."4"})	
		minetest.add_node(grnode.grow2,{name="hydro:"..plantname.."4"})
	elseif nodename == 'hydro:'..plantname..'2' 		then
		minetest.add_node(grnode.grow1,{name="hydro:"..plantname.."3"})
		minetest.add_node(grnode.grow2,{name="hydro:"..plantname.."3"})
	elseif nodename == 'hydro:'..plantname..'1' 		then
		minetest.add_node(grnode.grow1,{name="hydro:"..plantname.."2"})
		minetest.add_node(grnode.grow2,{name="hydro:"..plantname.."2"})
	elseif nodename =='hydro:sproutlings_'..plantname 	then
		minetest.add_node(grnode.grow1,{name="hydro:"..plantname.."1"})
	elseif nodename == 'hydro:seedlings_'..plantname 	then
		minetest.add_node(grnode.grow1,{name="hydro:sproutlings_"..plantname})
	elseif nodename == 'hydro:seeds_'..plantname 		then
		minetest.add_node(grnode.grow1,{name="hydro:seedlings_"..plantname})
	end

end

growshort = function (plantname, nodename, grnode)
	if nodename == 'hydro:'..plantname..'3' 			then
		minetest.add_node(grnode.grow1,{name="hydro:"..plantname.."4"})	
--		minetest.add_node(grnode.grow2,{name="hydro:"..plantname.."4"})
	elseif nodename == 'hydro:'..plantname..'2' 		then
		minetest.add_node(grnode.grow1,{name="hydro:"..plantname.."3"})
--		minetest.add_node(grnode.grow2,{name="hydro:"..plantname.."3"})
	elseif nodename == 'hydro:'..plantname..'1' 		then
		minetest.add_node(grnode.grow1,{name="hydro:"..plantname.."2"})
--		minetest.add_node(grnode.grow2,{name="hydro:"..plantname.."2"})
	elseif nodename =='hydro:sproutlings_'..plantname 	then
		minetest.add_node(grnode.grow1,{name="hydro:"..plantname.."1"})
	elseif nodename == 'hydro:seedlings_'..plantname 	then
		minetest.add_node(grnode.grow1,{name="hydro:sproutlings_"..plantname})
	elseif nodename == 'hydro:seeds_'..plantname 		then
		minetest.add_node(grnode.grow1,{name="hydro:seedlings_"..plantname})
	end

end

--		WILD PLANTS/SEEDS GENERATING
minetest.register_abm({
		nodenames = { "default:dirt_with_grass" },
		interval = 600,
		chance = 80,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local air = { x=pos.x, y=pos.y+1,z=pos.z }
			local is_air = minetest.get_node_or_nil(air)
			if is_air ~= nil
			and is_air.name == 'air' then
				local count = table.getn(get_plantbynumber)
				local random_plant = math.random(1,count)
				local nodename = "hydro:wild_"..get_plantbynumber[random_plant]
				if nodename ~= "hydro:wild_rubberplant" then
					minetest.add_node({x=pos.x,y=pos.y+1,z=pos.z},{name=nodename})
				end
			end
		end
})
minetest.register_abm({
		nodenames = get_wildplants,
		interval = 600,
		chance = 2,
		action = function(pos, node, active_object_count, active_object_count_wider)
			minetest.remove_node({x=pos.x,y=pos.y,z=pos.z})
		end
})


--		GROWING
minetest.register_abm({
		nodenames = { "hydro:growlamp" },
		interval = HYDRO_GROW_INTERVAL,
		chance = 1,

		action = function(pos, node, active_object_count, active_object_count_wider)
			local grnodes = {}
			local grnodes[1] = {water = {x=pos.x,y=pos.y-5,z=pos.z}, mix = {x=pos.x,y=pos.y-4,z=pos.z},grow1 = {x=pos.x,y=pos.y-3,z=pos.z}, grow2 = {x=pos.x,y=pos.y-2,z=pos.z}}
			local grnodes[2] = {water = {x=pos.x-1,y=pos.y-5,z=pos.z}, mix = {x=pos.x-1,y=pos.y-4,z=pos.z},grow1 = {x=pos.x-1, y=pos.y-3,z=pos.z}, grow2 = {x=pos.x-1,y=pos.y-2,z=pos.z}}
			local grnodes[3] = {water = {x=pos.x+1,y=pos.y-5,z=pos.z}, mix = {x=pos.x+1,y=pos.y-4,z=pos.z},grow1 = {x=pos.x+1, y=pos.y-3,z=pos.z}, grow2 = {x=pos.x+1,y=pos.y-2,z=pos.z}}
			local grnodes[4] = {water = {x=pos.x,y=pos.y-5,z=pos.z-1}, mix = {x=pos.x,y=pos.y-4,z=pos.z-1},grow1 = {x=pos.x, y=pos.y-3, z=pos.z-1}, grow2 = {x=pos.x,y=pos.y-2,z=pos.z-1}}
			local grnodes[5] = {water = {x=pos.x,y=pos.y-5,z=pos.z+1}, mix = {x=pos.x,y=pos.y-4,z=pos.z+1},grow1 = {x=pos.x, y=pos.y-3, z=pos.z+1}, grow2 = {x=pos.x,y=pos.y-2,z=pos.z+1}}
			local grnodes[6] = {water = {x=pos.x-1,y=pos.y-5,z=pos.z-1}, mix = {x=pos.x-1,y=pos.y-4,z=pos.z-1},grow1 = {x=pos.x-1,y=pos.y-3,z=pos.z-1}, grow2 = {x=pos.x-1,y=pos.y-2,z=pos.z-1}}
			local grnodes[7] = {water = {x=pos.x-1,y=pos.y-5,z=pos.z+1}, mix = {x=pos.x-1,y=pos.y-4,z=pos.z+1},grow1 = {x=pos.x-1,y=pos.y-3,z=pos.z+1}, grow2 = {x=pos.x-1,y=pos.y-2,z=pos.z+1}}
			local grnodes[8] = {water = {x=pos.x+1,y=pos.y-5,z=pos.z-1}, mix = {x=pos.x+1,y=pos.y-4,z=pos.z-1},grow1 = {x=pos.x+1,y=pos.y-3,z=pos.z-1}, grow2 = {x=pos.x+1,y=pos.y-2,z=pos.z-1}}
			local grnodes[9] = {water = {x=pos.x+1,y=pos.y-5,z=pos.z+1}, mix = {x=pos.x+1,y=pos.y-4,z=pos.z+1},grow1 = {x=pos.x+1,y=pos.y-3,z=pos.z+1}, grow2 = {x=pos.x+1,y=pos.y-2,z=pos.z+1}}


			local waters = {}
			local ismixs = {}
			local waters[1] = minetest.get_node(grnodes[1].water)
			if waters[1].name == 'default:water_source'
			or waters[1].name == 'default:water_flowing' then
				waters[1] = true
			end
			local ismixs[1] = minetest.get_node(grnodes[1].mix)
			local waters[2] = minetest.get_node(grnodes[2].water)
			if waters[2].name == 'default:water_source' or waters[2].name == 'default:water_flowing' then waters[2] = true end
			local ismixs[2] = minetest.get_node(grnodes[2].mix)
			local waters[3] = minetest.get_node(grnodes[3].water)
			if waters[3].name == 'default:water_source' or waters[3].name == 'default:water_flowing' then waters[3] = true end
			local ismixs[3] = minetest.get_node(grnodes[3].mix)
			local waters[4] = minetest.get_node(grnodes[4].water)
			if waters[4].name == 'default:water_source' or waters[4].name == 'default:water_flowing' then waters[4] = true end
			local ismixs[4] = minetest.get_node(grnodes[4].mix)
			local waters[5] = minetest.get_node(grnodes[5].water)
			if waters[5].name == 'default:water_source' or waters[5].name == 'default:water_flowing' then waters[5] = true end
			local ismixs[5] = minetest.get_node(grnodes[5].mix)
			local waters[6] = minetest.get_node(grnodes[6].water)
			if waters[6].name == 'default:water_source' or waters[6].name == 'default:water_flowing' then waters[6] = true end
			local ismixs[6] = minetest.get_node(grnodes[6].mix)
			local waters[7] = minetest.get_node(grnodes[7].water)
			if waters[7].name == 'default:water_source' or waters[7].name == 'default:water_flowing' then waters[7] = true end
			local ismixs[7] = minetest.get_node(grnodes[7].mix)
			local waters[8] = minetest.get_node(grnodes[8].water)
			if waters[8].name == 'default:water_source' or waters[8].name == 'default:water_flowing' then waters[8] = true end
			local ismixs[8] = minetest.get_node(grnodes[8].mix)
			local waters[9] = minetest.get_node(grnodes[9].water)
			if waters[9].name == 'default:water_source' or waters[9].name == 'default:water_flowing' then waters[9] = true end
			local ismixs[9] = minetest.get_node(grnodes[9].mix)


			if waters[1] == true and ismixs[1].name == 'hydro:promix' then
				local grow1 = minetest.get_node(grnodes[1].grow1)
				local curplant = get_plantname[grow1.name]
				if curplant ~= nil and PLANTS[curplant].growtype == 'growtall' then growtall(curplant,grow1.name,grnodes[1])			--	*** GENERIC GROW FUNCTION
				elseif curplant ~= nil and PLANTS[curplant].growtype == 'growshort' then growshort(curplant,grow1.name,grnodes[1]) end	--	*** GENERIC GROW FUNCTION
			end
			if waters[2] == true and ismixs[2].name == 'hydro:promix' then
				local grow2 = minetest.get_node(grnodes[2].grow1)
				local curplant = get_plantname[grow2.name]
				if curplant ~= nil and PLANTS[curplant].growtype == 'growtall' then growtall(curplant,grow2.name,grnodes[2])			--	*** GENERIC GROW FUNCTION
				elseif curplant ~= nil and PLANTS[curplant].growtype == 'growshort' then growshort(curplant,grow2.name,grnodes[2]) end	--	*** GENERIC GROW FUNCTION
			end
			if waters[3] == true and ismixs[3].name == 'hydro:promix' then
				local grow3 = minetest.get_node(grnodes[3].grow1)
				local curplant = get_plantname[grow3.name]
				if curplant ~= nil and PLANTS[curplant].growtype == 'growtall' then growtall(curplant,grow3.name,grnodes[3])			--	*** GENERIC GROW FUNCTION
				elseif curplant ~= nil and PLANTS[curplant].growtype == 'growshort' then growshort(curplant,grow3.name,grnodes[3]) end	--	*** GENERIC GROW FUNCTION

			end
			if waters[4] == true and ismixs[4].name == 'hydro:promix' then
				local grow4 = minetest.get_node(grnodes[4].grow1)
				local curplant = get_plantname[grow4.name]
				if curplant ~= nil and PLANTS[curplant].growtype == 'growtall' then growtall(curplant,grow4.name,grnodes[4])			--	*** GENERIC GROW FUNCTION
				elseif curplant ~= nil and PLANTS[curplant].growtype == 'growshort' then growshort(curplant,grow4.name,grnodes[4]) end	--	*** GENERIC GROW FUNCTION

			end
			if waters[5] == true and ismixs[5].name == 'hydro:promix' then
				local grow5 = minetest.get_node(grnodes[5].grow1)
				local curplant = get_plantname[grow5.name]
				if curplant ~= nil and PLANTS[curplant].growtype == 'growtall' then growtall(curplant,grow5.name,grnodes[5])			--	*** GENERIC GROW FUNCTION
				elseif curplant ~= nil and PLANTS[curplant].growtype == 'growshort' then growshort(curplant,grow5.name,grnodes[5]) end	--	*** GENERIC GROW FUNCTION

			end
			if waters[6] == true and ismixs[6].name == 'hydro:promix' then
				local grow6 = minetest.get_node(grnodes[6].grow1)
				local curplant = get_plantname[grow6.name]
				if curplant ~= nil and PLANTS[curplant].growtype == 'growtall' then growtall(curplant,grow6.name,grnodes[6])			--	*** GENERIC GROW FUNCTION
				elseif curplant ~= nil and PLANTS[curplant].growtype == 'growshort' then growshort(curplant,grow6.name,grnodes[6]) end	--	*** GENERIC GROW FUNCTION

			end
			if waters[7] == true and ismixs[7].name == 'hydro:promix' then
				local grow7 = minetest.get_node(grnodes[7].grow1)
				local curplant = get_plantname[grow7.name]
				if curplant ~= nil and PLANTS[curplant].growtype == 'growtall' then growtall(curplant,grow7.name,grnodes[7])			--	*** GENERIC GROW FUNCTION
				elseif curplant ~= nil and PLANTS[curplant].growtype == 'growshort' then growshort(curplant,grow7.name,grnodes[7]) end	--	*** GENERIC GROW FUNCTION

			end
			if waters[8] == true and ismixs[8].name == 'hydro:promix' then
				local grow8 = minetest.get_node(grnodes[8].grow1)
				local curplant = get_plantname[grow8.name]
				if curplant ~= nil and PLANTS[curplant].growtype == 'growtall' then growtall(curplant,grow8.name,grnodes[8])			--	*** GENERIC GROW FUNCTION
				elseif curplant ~= nil and PLANTS[curplant].growtype == 'growshort' then growshort(curplant,grow8.name,grnodes[8]) end	--	*** GENERIC GROW FUNCTION

			end
			if waters[9] == true and ismixs[9].name == 'hydro:promix' then
				local grow9 = minetest.get_node(grnodes[9].grow1)
				local curplant = get_plantname[grow9.name]
				if curplant ~= nil and PLANTS[curplant].growtype == 'growtall' then growtall(curplant,grow9.name,grnodes[9])			--	*** GENERIC GROW FUNCTION
				elseif curplant ~= nil and PLANTS[curplant].growtype == 'growshort' then growshort(curplant,grow9.name,grnodes[9]) end	--	*** GENERIC GROW FUNCTION

			end

		end
})

minetest.register_craft({	output = 'hydro:growlamp 1',	recipe = {
		{'glass', 'torch','glass'},
		{'glass', 'torch','glass'},
		{'glass', 'torch','glass'},
}})
minetest.register_craft({	output = 'hydro:promix 6',	recipe = {
		{'', 'default:clay_lump',''},
		{'default:dirt', 'default:dirt', 'default:dirt'},
		{'default:dirt', 'default:dirt', 'default:dirt'},
}})
minetest.register_craft({	output = 'hydro:wine 1',	recipe = {
		{'default:glass', 'hydro:grapes','default:glass'},
		{'default:glass', 'hydro:grapes','default:glass'},
		{'default:glass', 'hydro:grapes','default:glass'},
	}})
minetest.register_craft({	output = 'node "hydro:coffeecup" 1',	recipe = {
		{'','',''},
		{'default:clay_lump','hydro:roastedcoffee','default:clay_lump'},
		{'','default:clay_lump',''},
	}})
minetest.register_craft({	type = "cooking",	output = "hydro:roastedcoffee",	recipe = "hydro:coffee", })

