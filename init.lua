local HYDRO_GROW_INTERVAL = 100
local PLANTS = {
	tomato = {name='tomato',growtype='growtall'},
	peas = {name='peas',growtype='growtall'},
	habanero = {name='habanero',growtype='growtall'},
	grapes = {name='grapes',growtype='permaculture'},
	coffee = {name='coffee',growtype='permaculture'},
	roses = {name='roses',growtype='growtall',give_on_harvest='hydro:rosebush'}
}

minetest.register_node("hydro:wine", {
	description = 'Wine Bottle',
	drawtype = "plantlike",
	tile_images = {"hydro_wine.png"},
	inventory_image = "hydro_wine.png",
	wield_image = "hydro_wine.png",
	paramtype = "light",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	sounds = default.node_sound_wood_defaults(),
	walkable = false,
	on_use = minetest.item_eat(1)
})

minetest.register_node("hydro:coffeecup", {
	description = 'Coffee Cup',
	drawtype = "plantlike",
	tile_images = {"hydro_coffeecup.png"},
	inventory_image = "hydro_coffeecup.png",
	wield_image = "hydro_coffeecup.png",
	paramtype = "light",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	sounds = default.node_sound_wood_defaults(),
	walkable = false,
	on_use = minetest.item_eat(2)
})

minetest.register_node("hydro:growlamp", {
	description = "Growlamp",
	drawtype = 'plantlike',
	tile_images = {"hydro_growlamp.png"},
	inventory_image = "hydro_growlamp.png",
	light_propagates = true,
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 15	,
	is_ground_content = true,
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

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

local get_plantname = {}		-- plants index by nodenames (tomato1, tomato2, seeds_tomato, etc..)
local get_plantbynumber = {}		-- plants index by number (for random select)
local get_wildplants = {}		-- wildplant nodenames (pop control)

for _,plant in pairs(PLANTS) do 
		--		define nodes
	local wild_plant = "hydro:wild_"..plant.name
	minetest.register_node(wild_plant, {
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
	if plant.give_on_harvest then
		harvest = plant.give_on_harvest
	end
	
	local after_dig_node
	if plant.growtype == 'permaculture' then
		plant.growtype = 'growshort'
		after_dig_node = function(pos)
			minetest.add_node(pos, {name='hydro:'..plant.name..'1'})
		end

	end

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
	if not plant.give_on_harvest then
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
	table.insert(get_wildplants, wild_plant)
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
local function grow_plant(plantname, nodename, pos, tall)
	local name, above
	if nodename == 'hydro:'..plantname..'3' 			then
		name = plantname.."4"
		above = true
	elseif nodename == 'hydro:'..plantname..'2' 		then
		name = plantname.."3"
		above = true
	elseif nodename == 'hydro:'..plantname..'1' 		then
		name = plantname.."2"
		above = true
	elseif nodename =='hydro:sproutlings_'..plantname 	then
		name = plantname.."1"
	elseif nodename == 'hydro:seedlings_'..plantname 	then
		name = "sproutlings_"..plantname
	elseif nodename == 'hydro:seeds_'..plantname 		then
		name = "seedlings_"..plantname
	else
		return
	end
	minetest.add_node(pos, {name="hydro:"..name})
	if above
	and tall then
		minetest.add_node({x=pos.x, y=pos.y+1, z=pos.z}, {name="hydro:"..name})
	end
end

--		WILD PLANTS/SEEDS GENERATING
minetest.register_abm({
		nodenames = { "default:dirt_with_grass" },
		interval = 600,
		chance = 80,
		action = function(p, node)
			p.y = p.y+1
			local is_air = minetest.get_node_or_nil(p)
			if is_air
			and is_air.name == 'air' then
				local count = table.getn(get_plantbynumber)
				local random_plant = math.random(1, count)
				local nodename = "hydro:wild_"..get_plantbynumber[random_plant]
				if nodename ~= "hydro:wild_rubberplant" then
					minetest.add_node(p, {name=nodename})
				end
			end
		end
})
minetest.register_abm({
		nodenames = get_wildplants,
		interval = 600,
		chance = 2,
		action = function(pos)
			minetest.remove_node({x=pos.x,y=pos.y,z=pos.z})
		end
})


--		GROWING
minetest.register_abm({
	nodenames = { "hydro:growlamp" },
	interval = HYDRO_GROW_INTERVAL,
	chance = 1,
	action = function(pos, node)
		if minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name == "air"
		or minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name ~= "air" then
			return
		end
		for i = -1,1 do
			for j = -1,1 do
				local p = {x=pos.x+j, y=pos.y, z=pos.z+i}
				local water = minetest.get_node({x=p.x, y=p.y-5, z=p.z}).name
				if (water == 'default:water_source' or water == 'default:water_flowing')
				and minetest.get_node({x=p.x, y=p.y-4, z=p.z}).name == 'hydro:promix' then
					local grow = minetest.get_node({x=p.x, y=p.y-3, z=p.z}).name
					local curplant = get_plantname[grow]
					if curplant then
						local growtype = PLANTS[curplant].growtype
						local tall
						if growtype == 'growtall' then
							tall = true
						end
						grow_plant(curplant, grow, {x=p.x, y=p.y-3, z=p.z}, tall)
					end
				end
			end
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
minetest.register_craft({
	output = 'hydro:wine 1',	recipe = {
		{'default:glass', 'hydro:grapes','default:glass'},
		{'default:glass', 'hydro:grapes','default:glass'},
		{'default:glass', 'hydro:grapes','default:glass'},
	}
})
minetest.register_craft({
	output = 'node "hydro:coffeecup" 1',	recipe = {
		{'','',''},
		{'default:clay_lump','hydro:roastedcoffee','default:clay_lump'},
		{'','default:clay_lump',''},
	}
})
minetest.register_craft({	type = "cooking",	output = "hydro:roastedcoffee",	recipe = "hydro:coffee", })

