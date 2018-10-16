local time = tonumber(minetest.settings:get("simple_sunburn_time")) or 5
local damage_min = tonumber(minetest.settings:get("simple_sunburn_damage_min")) or 1
local damage_max = tonumber(minetest.settings:get("simple_sunburn_damage_max")) or 2

local use_tigris = minetest.get_modpath("tigris_base")

simple_sunburn = {
    -- If necessary, other mods can override this.
    get_damage = function(player)
        return math.random(damage_min, damage_max)
    end,
}

local function do_damage(player, amount)
    if use_tigris then
        tigris.damage.apply(player, {sun = amount})
    else
        player:set_hp(player:get_hp() - amount)
    end
end

local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer > time then
        for _,player in ipairs(minetest.get_connected_players()) do
            if minetest.get_node_light(vector.add(player:getpos(), vector.new(0, 1.5, 0))) == minetest.LIGHT_MAX then
                local damage = math.floor(simple_sunburn.get_damage(player) * (timer / time) + 0.5)
                do_damage(player, damage)
            end
        end
        timer = 0
    end
end)
