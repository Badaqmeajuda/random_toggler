require "math"

obs           = obslua
source_name   = ""

hotkey_id_random     = obs.OBS_INVALID_HOTKEY_ID

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_list(props, "source", "Text source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
	return props
end

function script_description()
	return "Toggle between random sources visible in a scene"
end

function random(pressed)
    if not pressed then
		return
	end
    local source = obs.obs_get_source_by_name(source_name)
    local scene = obs.obs_scene_from_source(source)
    local sceneitems = obs.obs_scene_enum_items(scene)
    local count = #sceneitems
    math.randomseed(os.time())
    local randomIndex = math.random(count)
    obs.blog(obs.LOG_INFO, randomIndex)
    for i, sceneitem in ipairs(sceneitems) do 
        if i ~= randomIndex then
            if obs.obs_sceneitem_visible(sceneitem) then
                obs.obs_sceneitem_set_visible(sceneitem, false)
            end
        elseif not obs.obs_sceneitem_visible(sceneitem) then
            obs.obs_sceneitem_set_visible(sceneitem, true)
        end    
    end
    obs.sceneitem_list_release(sceneitems)
    obs.obs_source_release(source)
end

function script_update(settings)
    local sourceNames =  obs.obs_data_get_array(settings, "sources");   
    source_name = obs.obs_data_get_string(settings, "source") 
end

function script_defaults(settings)

end

function script_save(settings)
    local hotkey_save_array_random = obs.obs_hotkey_save(hotkey_id_random)
	obs.obs_data_set_array(settings, "random_hotkey", hotkey_save_array_random)
	obs.obs_data_array_release(hotkey_save_array_random)
end

function script_load(settings)

	hotkey_id_random = obs.obs_hotkey_register_frontend("random_toggle", "Random Toggle", random)
	local hotkey_save_array_random = obs.obs_data_get_array(settings, "random_hotkey")
	obs.obs_hotkey_load(hotkey_id_random, hotkey_save_array_random)
	obs.obs_data_array_release(hotkey_save_array_random)

	script_update(settings)
    
end

function script_unload()

end
