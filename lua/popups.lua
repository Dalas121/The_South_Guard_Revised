local _ = wesnoth.textdomain "wesnoth-h2tt"

-- https://wiki.wesnoth.org/LuaAPI/types/widget

-- metatable for GUI tags
local T = wml.tag

-- helpful debug function for printing a table
function tprint (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2 
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "   
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end
























--###########################################################################################################################################################
--                                                                 SCENARIO PREVIEW
--###########################################################################################################################################################
function display_tip(cfg)
	local tutor_title = cfg.title
	local tutor_message = cfg.message
	local tutor_image = cfg.image
	
	--###############################
	-- DEFINE GRID
	--###############################
	local grid = T.grid{ T.row{ 
		T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }}, 
		T.column{ T.grid{ 
			-------------------------
			-- TITLE
			-------------------------
			T.row{ T.column{ 
				horizontal_alignment="center",
				T.label{  definition="title",  label=_"Tip: "..tutor_title,  }
			}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}}, 
			-------------------------
			-- INFO
			-------------------------
			T.row{ T.column{ T.grid{ T.row{
				T.column{
					T.image{  label=tutor_image  }
				},
-- 				T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }},
				T.column{ T.label{  use_markup=true,  label="<span size='80000'> </span>"  }},
				T.column{ 
					horizontal_alignment="left",
					T.label{
						use_markup=true,
						label=tutor_message,
					}
				}
			}}}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}}, 
			-------------------------
			-- BUTTONS
			-------------------------
			T.row{ T.column{ T.button{
				return_value=1, use_markup=true,
				label=_"Understood",
			}}},
		}},
		T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }}, 
	}}
	
	--###############################
	-- CREATE DIALOG
	--###############################
	local result = wesnoth.sync.evaluate_single(function()
		local button = gui.show_dialog({
			T.helptip{ id="tooltip_large" }, -- mandatory field
			T.tooltip{ id="tooltip_large" }, -- mandatory field
			grid
		})
		return { button=button }
	end)
end


















--###########################################################################################################################################################
--                                                                      "MAIN"
--###########################################################################################################################################################
-------------------------
-- DEFINE WML TAGS
-------------------------
function wesnoth.wml_actions.display_tip(cfg)
	display_tip(cfg)
end

