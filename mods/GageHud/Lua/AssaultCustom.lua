CloneClass(HUDAssaultCorner)

local assault_texts = {
		"SNAKE IN PROGRESS",
    "example 2",
}
Chance = 40


function HUDAssaultCorner:_animate_text(text_panel, bg_box, color)
	local text_list = bg_box or self._bg_box:script().text_list
	local text_index = 0
	local texts = {}
	local padding = 10
	local function create_new_text(text_panel, text_list, text_index, texts)
		if texts[text_index] and texts[text_index].text then
			text_panel:remove(texts[text_index].text)
			texts[text_index] = nil
		end
		if math.random(Chance) < 10 then
		randomstring = assault_texts[math.random(#assault_texts)]
		else
		randomstring = nil
		end
		
		local text_id = text_list[text_index]
		local text_string = ""
		if type(text_id) == "string" then
		
		if randomstring ~= nil and text_id ~= managers.localization:to_upper_text("hud_assault_end_line") then
			text_string = string.upper(randomstring)
			else
			text_string = managers.localization:to_upper_text(text_id)
			end
		elseif text_id == Idstring("risk") then
			for i = 1, managers.job:current_difficulty_stars() do
			if randomstring ~= nil and text_id ~= managers.localization:to_upper_text("hud_assault_end_line") and text_panel ~= self._casing_bg_box then
				text_string = string.upper(randomstring)
				else
				text_string = text_string .. managers.localization:get_default_macro("BTN_SKULL")
			end
			end
		end
		local text = text_panel:text({
			text = text_string,
			layer = 1,
			align = "center",
			vertical = "center",
			blend_mode = "add",
			color = color or self._assault_color,
			font_size = tweak_data.hud_corner.assault_size,
			font = tweak_data.hud_corner.assault_font,
			w = 10,
			h = 10
		})
		local _, _, w, h = text:text_rect()
		text:set_size(w, h)
		texts[text_index] = {
			x = text_panel:w() + w * 0.5 + padding * 2,
			text = text
		}
	end
	while true do
		local dt = coroutine.yield()
		local last_text = texts[text_index]
		if last_text and last_text.text then
			if last_text.x + last_text.text:w() * 0.5 + padding < text_panel:w() then
				text_index = text_index % #text_list + 1
				create_new_text(text_panel, text_list, text_index, texts)
			end
		else
			text_index = text_index % #text_list + 1
			create_new_text(text_panel, text_list, text_index, texts)
		end
		local speed = 90
		for i, data in pairs(texts) do
			if data.text then
				data.x = data.x - dt * speed
				data.text:set_center_x(data.x)
				data.text:set_center_y(text_panel:h() * 0.5)
				if 0 > data.x + data.text:w() * 0.5 then
					text_panel:remove(data.text)
					data.text = nil
				end
			end
		end
	end
end
