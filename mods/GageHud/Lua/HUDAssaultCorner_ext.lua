if not mod_collection then
	return
end

function HUDAssaultCorner:init(hud, full_hud)
	self._hud_panel = hud.panel
	self._full_hud_panel = full_hud.panel
	self._casing_color = Color.white
	if self._hud_panel:child("assault_panel") then
		self._hud_panel:remove(self._hud_panel:child("assault_panel"))
	end

	local size = 200
	local assault_panel = self._hud_panel:panel({
		visible = false,
		name = "assault_panel",
		w = 270,
		h = 100
	})
	assault_panel:set_center(self._hud_panel:center())
	assault_panel:set_top(0)
	self._assault_color = Color(1, 1, 1, 0)

	local icon_assaultbox = assault_panel:bitmap({
		halign = "right",
		valign = "top",
		color = Color.yellow,
		name = "icon_assaultbox",
		blend_mode = "add",
		visible = true,
		layer = 0,
		texture = "guis/textures/pd2/hud_icon_assaultbox",
		w = 24,
		h = 24
	})
	icon_assaultbox:set_right(icon_assaultbox:parent():w())
	self._bg_box = HUDBGBox_create(assault_panel, {
		w = 242,
		h = 38,
	}, {
		color = self._assault_color,
		blend_mode = "add"
	})
	self._bg_box:set_right(icon_assaultbox:left() - 3)
	local yellow_tape = assault_panel:rect({
		visible = false,
		name = "yellow_tape",
		h = tweak_data.hud.location_font_size * 1.5,
		w = size * 3,
		color = Color(1, 0.8, 0),
		layer = 1
	})
	yellow_tape:set_center(10, 10)
	yellow_tape:set_rotation(30)
	yellow_tape:set_blend_mode("add")
	assault_panel:panel({
		name = "text_panel",
		layer = 1,
		w = yellow_tape:w()
	}):set_center(yellow_tape:center())
	if self._hud_panel:child("point_of_no_return_panel") then
		self._hud_panel:remove(self._hud_panel:child("point_of_no_return_panel"))
	end

	--TODO: Fix text alignment
	local size = 300
	local point_of_no_return_panel = self._hud_panel:panel({
		visible = false,
		name = "point_of_no_return_panel",
		w = size,
		h = 40
	})
	point_of_no_return_panel:set_center(self._hud_panel:center())
	point_of_no_return_panel:set_top(0)
	self._noreturn_color = Color(1, 1, 0, 0)
	local icon_noreturnbox = point_of_no_return_panel:bitmap({
		halign = "right",
		valign = "top",
		color = self._noreturn_color,
		name = "icon_noreturnbox",
		blend_mode = "add",
		visible = true,
		layer = 0,
		texture = "guis/textures/pd2/hud_icon_noreturnbox",
		w = 24,
		h = 24
	})
	icon_noreturnbox:set_right(icon_noreturnbox:parent():w())
	self._noreturn_bg_box = HUDBGBox_create(point_of_no_return_panel, {
		w = 242,
		h = 38,
	}, {
		color = self._noreturn_color,
		blend_mode = "add"
	})
	self._noreturn_bg_box:set_right(icon_noreturnbox:left() - 3)
	local w = point_of_no_return_panel:w()
	local size = 200 - tweak_data.hud.location_font_size
	local point_of_no_return_text = self._noreturn_bg_box:text({
		name = "point_of_no_return_text",
		text = "",
		blend_mode = "add",
		layer = 1,
		valign = "center",
		align = "right",
		vertical = "center",
		color = self._noreturn_color,
		font_size = tweak_data.hud_corner.noreturn_size,
		font = tweak_data.hud_corner.assault_font
	})
	point_of_no_return_text:set_text(utf8.to_upper(managers.localization:text("hud_assault_point_no_return_in", {time = ""})))
	point_of_no_return_text:set_size(self._noreturn_bg_box:w(), self._noreturn_bg_box:h())
	local point_of_no_return_timer = self._noreturn_bg_box:text({
		name = "point_of_no_return_timer",
		text = "",
		blend_mode = "add",
		layer = 1,
		valign = "center",
		align = "center",
		vertical = "center",
		color = self._noreturn_color,
		font_size = tweak_data.hud_corner.noreturn_size,
		font = tweak_data.hud_corner.assault_font
	})
	local _, _, w, h = point_of_no_return_timer:text_rect()
	point_of_no_return_timer:set_size(46, self._noreturn_bg_box:h())
	point_of_no_return_timer:set_right(point_of_no_return_timer:parent():w())
	point_of_no_return_text:set_right(math.round(point_of_no_return_timer:left()))
end

function HUDAssaultCorner:sync_start_assault(data)
	if self._point_of_no_return then
		return
	end

	if managers.job:current_difficulty_stars() > 0 then
		local ids_risk = Idstring("risk")
		self:_start_assault({
			"hud_assault_assault",
			"hud_assault_end_line",
			ids_risk,
			"hud_assault_end_line",
			"hud_assault_assault",
			"hud_assault_end_line",
			ids_risk,
			"hud_assault_end_line"
		})
	else
		self:_start_assault({
			"hud_assault_assault",
			"hud_assault_end_line",
			"hud_assault_assault",
			"hud_assault_end_line",
			"hud_assault_assault",
			"hud_assault_end_line"
		})
	end
end

function HUDAssaultCorner:show_point_of_no_return_timer()
	local delay_time = self._assault and 1.2 or 0
	self:_end_assault()
	local point_of_no_return_panel = self._hud_panel:child("point_of_no_return_panel")
	point_of_no_return_panel:stop()
	point_of_no_return_panel:animate(callback(self, self, "_animate_show_noreturn"), delay_time)
	self._point_of_no_return = true
end

function HUDAssaultCorner:hide_point_of_no_return_timer()
	self._noreturn_bg_box:stop()
	self._hud_panel:child("point_of_no_return_panel"):set_visible(false)
	self._point_of_no_return = false
end

function HUDAssaultCorner:set_control_info(...) end
function HUDAssaultCorner:show_casing(...) end
function HUDAssaultCorner:hide_casing(...) end

local orig_init = HUDAssaultCorner.init
function HUDAssaultCorner:init(hud, full_hud)
	orig_init(self, hud, full_hud)
	self._hud_panel = hud.panel
	self._full_hud_panel = full_hud.panel
	if self._hud_panel:child("hostages_panel") then
		self:_hide_hostages()
	end
end

function HUDAssaultCorner:_show_hostages()
	if not self._casing_panel then
	end
end

CloneClass(HUDAssaultCorner)

local assault_texts = {
		"SNAKE IN PROGRESS",
		"WOW THERE ARE SO MANY HUMANS! - RUMIA",
"DO YOU NEED A LIFE? - DAIYOUSEI",
"THERE'S WAY TOO MANY!! - CIRNO",
"IF I CAN PUNCH OUT A CLOAKER, SO CAN YOU! - HONG MEILING",
"PLEASE WATCH YOUR HEAD - KOAKUMA",
"REFRAIN FROM TAKING ANY BOOKS - PATCHOULI KNOWLEDGE",
"THE SLOW MOTION ONLY AFFECTS YOU - SAKUYA IZAYOI",
"HOW DOES THIS EVEN WORK, SAKUYA? - REMILIA SCARLET",
"YOU DON'T SEEM LIKE YOU'LL BREAK AS EASY AS THE REST OF MY TOYS - FLANDRE SCARLET",
"THERE ISN'T MUCH TO SAY - LETTY WHITEROCK",
"I ROLLED INTO A TREE ONCE - CHEN",
"YOU NEED MORE COLOURS - ALICE MARGATROID",
"IT'S SPRING! - LILY WHITE",
"NO IT'S NOT - LILY BLACK",
"YOU WANT ME TO WHAT WITH THE KITCHEN KNIFE? - LUNASA PRISMRIVER",
"SCARE CHORDS? - LYRICA PRISMRIVER",
"CAN I THROW IT AT YOU? - MERLIN PRISMRIVER",
"SLOWLY, THESE WEEDS SHALL DISAPPEAR! - YOUMU KONPAKU",
"ANOTHER PEACEFUL DAY... - YUYUKO SAIGYOUJI",
"CHEN? - RAN YAKUMO",
"I HAPPENED TO FIND THESE. - YUKARI YAKUMO",
"DID YOU SAY ANOTHER GATHERING? - SUIKA IBUKI",
"GIVE THEM A KICK! - WRIGGLE NIGHTBUG",
"I CAN'T HELP YOU WITH THOSE FLASHBANGS - MYSTIA LORELEI",
"NO I WON'T. - KEINE KAMISHIRASAWA",
"HEY WANNA GET RICH? - TEWI",
"MY EYES DON'T WORK ON THOSE GOGGLES - REISEN UDONGEIN INABA",
"EIENTEI IS ALWAYS OPEN - EIRIN YAGOKORO",
"I WANT A TURN - KAGUYA HOURAISAN",
"HOW MANY LIVES DO YOU HAVE? - MOKOU FUJIWARA",
"HERE FOR THE DIRT! - AYA SHAMEIMARU",
"POISON? SURE! - MEDICINE MELANCHOLY",
"I HOPE YOU HAVEN'T BURNT ANY FLOWERS - YUUKA KAZAMI",
"OUT OF AMMO? THROW COINS! - KOMACHI ONOZUKA",
"HOW DID YOU EVEN GET HERE? - SHIKI EIKI",
"YOU WHAT? - HATATE HIMEKAIDOU",
"OH EXCUSE ME - SHIZUHA AKI",
"WOW I SMELL DELICIOUS TODAY - MINORIKO AKI",
"DID YOU NEED THAT MISFORTUNE? - HINA KAGIYAMA",
"I CAN MAKE SOMETHING BETTER! - NITORI KAWASHIRO",
"HOW DID YOU GET THIS FAR UP? - MOMIJI INUBASHIRI",
"WELCOME TO THE MORIYA TEMPLE - SANAE KOCHIYA",
"ANOTHER CHALLENGER? - KANAKO YASAKA",
"HIYA - SUWAKO MORIYA",
"DO THAT AGAIN! - TENSHI HINANAWI",
"STUN THEM? IT SEEMS TO ME THAT YOU'RE FINE.- IKU NAGAE",
"... - KISUME",
"NO WEBS FOR YOU - YAMAME KURODANI",
"KEEP THEM OFF MY BRIDGE - PARSEE MIZUHASHI",
"HEY LET'S DRINK AFTER THIS! - YUUGI HOSHIGUMA",
"I... SEE - SATORI KOMEIJI",
"WHOA LOOK AT ALL THESE DEAD BODIES - RIN KAENBYOU",
"DO THIS AND THIS AND... DONE - UTSUHOU REIUJI",
"HELLO - KOISHI KOMEIJI",
"I SEEM TO HAVE TAKEN THE WRONG TURN - NAZRIN",
"BOO! - KOGASA TATARA",
"UNZAN WHERE ARE MY RINGS? - ICHIRIN KUMOI",
"WHOOPS - MURASA MINAMITSU",
"NOW WHAT WAS I DOING? - SHOU TORAMARU",
"WELCOME TO MYOURENJI TEMPLE - BYAKUREN HIJIRI",
"HAVING FUN I SEE - NUE HOUJUU",
"HOW MANY HUMANS CAN WE TRAP SUNNY? - LUNA CHILD",
"FORGET THEM! LET'S GO FOR THE SHRINE MAIDEN! - SUNNY MILK",
"I'LL GET THE BAND-AIDS - STAR SAPPHIRE",
"ECHO! - KYOUKO KASODANI",
"OH WHY HELLO - YOSHIKA MIYAKO",
"LEAVE MY HAIRPIN ALONE - SEIGA KAKU",
"YOU CAN'T SEE YOUR LEGS TOO? - TOJIKO SOGA",
"WHERE'S THAT DAMN SEIJA?! - FUTO MONONOBE",
"WHERE'D KOKORO GO? - MIKO TOYOSATOMIMI",
"INTERESTING - MAMIZOU FUTATSUIWA",
"YOU CAME TO SEE ME? - WAKASAGIHIME",
"LET GO OF THE CAPE - SEKIBANKI",
"I'D RATHER NOT SCRATCH YOU - KAGEROU IMAIZUMI",
"PLEASE KEEP YATSUHASHI IN CHECK - BENBEN TSUKUMO",
"TAKE HIM OUT TOO! - YATSUHASHI TSUKUMO",
"GOING FOR THAT PERFECT AIM? WHOOPS MY BAD - SEIJA KIJIN",
"TAKE MY NEEDLE! - SHINMYOUMARU SUKUNA",
"ONE, TWO, ONE, TWO - RAIKO HORIKAWA",
"REIMU STOP RUNNING! - KASEN IBARAKI",
"IT'S HOOOOT - RENKO USAMI",
"IT IS INDEED... - MARIBEL HEARN",
"BACK TO SLEEP! - SUMIREKO USAMI",
"ANOTHER INCIDENT? - REIMU HAKUREI",
"MOVE BITCH GET OUT THE WAY - MARISA KIRISAME",
"THE CAKE IS A LIE!",
"THE DESYNC IS REAL!",
"I GOT YOUR DLC RIGHT HERE!",
"WAR. WAR NEVER CHANGES.",
"M-M-M-M-MONSTERKILL!!!",
"PREPARE FOR UNFORESEEN CONSEQUENCES.",
"I AM ERROR.",
"YOU WERE ALMOST A JILL SANDWICH!",
"IT'S TIME TO KICK ASS AND CHEW BUBBLE GUM, AND I'M ALL OUT OF GUM!",
"WELCOME TO QUAKE 3 ARENA. ENTER THE PORTAL TO BEGIN COMBAT.",
"ITS'A ME, MARIO!",
"THAT'S THE SECOND BIGGEST MONKEY HEAD I'VE EVER SEEN!",
"ALL YOUR BASE ARE BELONG TO US!",
"DO A BARREL ROLL!",
"FUS-RO-DAH!",
"DID I EVER TELL YOU THE DEFINITION OF INSANITY?",
"WAKKA WAKKA!",
"THE PRESIDENT HAS BEEN KIDNAPPED BY NINJAS.",
"NUCLEAR LAUNCH DETECTED.",
"FINISH HIM!!",
"FIRST BLOOD!",
"THANK YOU MARIO! BUT OUR PRINCESS IS IN ANOTHER CASTLE!",
"STAY A WHILE, AND LISTEN.",
"WOULD YOU KINDLY?",
"NEVER PAY MORE THAN 20 BUCKS FOR A COMPUTER GAME.",
"RISE AND SHINE, MR. FREEMAN. RISE... AND... SHINE.",
"THE RIGHT MAN IN THE WRONG PLACE CAN MAKE ALL THE DIFFERENCE IN THE WORLD.",
"WELCOME TO WARP ZONE!",
"FLAWLESS VICTORY!",
"THIS IS IT. THIS IS YOUR STORY. IT ALL BEGINS HERE.",
"CONGRATULATION!!! YOU HAVE COMPLETED A GREAT GAME.",
"I AM THE GREAT MIGHTY POO AND I'M GOING TO THROW MY SHIT AT YOU!",
"I USED TO BE AN ADVENTURER LIKE YOU, BUT THEN I TOOK AN ARROW IN THE KNEE.",
"YOU HAVE DIED OF DYSENTERY.",
"CONGRATULATION. THIS STORY IS HAPPY END.",
"A WINNER IS YOU!",
"KILLTACULAR!",
"A MAN CHOOSES. A SLAVE OBEYS. OBEY!",
"SNAKE? SNAAAAAAAAAAAAAAKE?!",
"E! A! SPORTS! IT'S IN THE GAME!",
"WAITWAITWAIT! THAT'S NOT HOW IT HAPPENED.",
"HEY! LISTEN!",
"WASTED!",
"X-MEN, WELCOME TO DIE!",
"EXPLOSIONS?!?!?!?!",
"SIZE DOESN'T MATTER. EXCEPT WHEN IT DOES. WHICH IS ALWAYS.",
"YIPPEE KI-YAY, MOTHERFUCKER!",
"I WILL KILL YOUR DICKS!",
"C-C-C-COMBO BREAKER!",
"WAR HAS CHANGED.",
"HEY DUDES THANKS, FOR RESCUING ME. LET'S GO FOR A BURGER...HA! HA! HA! HA!",
"REQUIESCAT IN PACE!",
"AREEEEEEEEEEEEES!!!!!!!",
"JOB'S DONE.",
"IT'S DANGEROUS TO GO ALONE! TAKE THIS.",
"WELCOME TO SUMMONERS RIFT.",
"YOUR FACE. YOUR ASS. WHAT'S THE DIFFERENCE?",
"YOU'RE AN INSPIRATION FOR BIRTH CONTROL!",
"TWINKLE, TWINKLE, LITTLE BAT. WATCH ME KILL YOUR FAVORITE CAT.",
"ENDURE AND SURVIVE.",
"A HERO NEED NOT SPEAK. WHEN HE IS GONE, THE WORLD WILL SPEAK FOR HIM.",
"YOU AND YOUR FRIENDS ARE DEAD!",
"GAME OVER!",
"I FELL ASLEEP!!",
"GOTTA CATCH 'EM ALL!",
"QUAD DAMAGE!",
"OH LOOK, ANOTHER VISITOR. STAY AWHILE... STAY FOREVER!",
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
