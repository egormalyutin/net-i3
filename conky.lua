require "cairo"
require "drawlib"

function prep(elem)
	check_requirements({elem})
	fill_defaults({elem})
	return elem
end

-- TODO: cache imgs

function draw_image(cr, path, x, y, width, height)
	img = cairo_image_create_surface_from_png(path)
	cairo_translate(cr, x, y)
	cairo_scale(cr, width / cairo_image_surface_get_width(img), height / cairo_image_surface_get_height(img))
	cairo_set_source_surface(cr, img, 0, 0)
	cairo_paint(cr)
	cairo_surface_destroy(image)
end

function conky_main()
	if conky_window == nil then
		return
	end

	local cs = cairo_xlib_surface_create(
		conky_window.display,
		conky_window.drawable,
		conky_window.visual,
		conky_window.width,
		conky_window.height
	)
	local cr = cairo_create(cs)

	colors = {}
	colors.bg = {1,1,1,1}

	GX = -10
	GY = -5

	cores = {"α", "β", "γ", "Δ"}

	function gb(offset)
		draw_static_text(cr, prep{
			kind = "static_text",

			from = {x = 725 - offset * 20 + 5 + GX, y = (offset + 0.7) * 40 + GY},

			text = "core " .. cores[offset],

			font = "Hack",
			font_size = 13,
			color = 0xffffff
		})

		draw_bar_graph(cr, prep{
			kind = 'bar_graph',
			conky_value = 'cpu cpu' .. offset,
			from = {x = 725 - offset * 20 + GX, y = (offset + 1) * 40 + GY},
			to = {x = 970  - offset * 20 + GX, y = (offset + 1) * 40 + GY},

			background_thickness = 13,
			background_color = 0xFFFFFF,
			background_alpha = 0.1,

			bar_thickness = 13,
			bar_color = 0xffffff,

			critical_threshold = 60,

			change_color_on_critical = true,

			background_color_critical = 0xFFA0A0,

			bar_color_critical = 0xFFAAAA,

			graduated = true,
			number_graduation = 100,
			space_between_graduation = 2,
		})
	end

	draw_static_text(cr, prep{
		kind = "static_text",

		from = {x = 580 + GX, y = 220 + GY},

		rotation_angle = 360 - 61.5,

		text = "PORTABLE FUSION REACTOR LOAD",

		font = "Hack",
		font_size = 12,
		bold = true,
		color = 0xffffff
	})

	-- LEFT

	draw_line(cr, prep{
		kind = "line",

		from = {x = 702 + GX, y = 42 + GY},
		to = {x = 600 + GX, y = 230 + GY},

		color = 0xffffff,
		alpha = 1,
		thickness = 1
	})

	-- RIGHT

	draw_line(cr, prep{
		kind = "line",

		from = {x = 999 + GX, y = 42 + GY},
		to = {x = 899 + GX, y = 230 + GY},

		color = 0xffffff,
		alpha = 1,
		thickness = 1
	})

	-- BOTTOM

	draw_line(cr, prep{
		kind = "line",

		from = {x = 600 + GX, y = 230 + GY},
		to = {x = 899 + GX, y = 230 + GY},

		color = 0xffffff,
		alpha = 1,
		thickness = 1
	})

	-- TOP

	draw_line(cr, prep{
		kind = "line",

		from = {x = 702 + GX, y = 42 + GY},
		to = {x = 999 + GX, y = 42 + GY},

		color = 0xffffff,
		alpha = 1,
		thickness = 1
	})

	gb(1)
	gb(2)
	gb(3)
	gb(4)

	draw_static_text(cr, prep{
		kind = "static_text",

		from = {x = 638 + GX, y = 316 + GY},

		text = "FUEL",

		font = "Hack",
		font_size = 18,
		bold = true,
		color = 0xffffff
	})

	batp = (conky_parse"${execi 2 acpi | grep -Eo '([0-9]+%)' | grep -Eo '([0-9])+'}")
	batp = tonumber(batp)
	charging = "" ~= conky_parse"${execi 2 acpi | grep Charging}"

	color = 0xFFFFFF
	-- critical_threshold = 70,
	-- bar_color_critical = 0xFF3030,
	-- background_color_critical = 0xEE0000,

	if batp < 20 then
		color = 0xFF2828
	end

	if charging == true then
		color = 0x3bFF3b
	end

	draw_ring_graph(cr, prep{
		kind = 'ring_graph',
		-- conky_value = "execi 2 acpi | grep -Eo '([0-9])+%' | grep -Eo '([0-9])+'",
		conky_value = "execi 2 acpi | grep -Eo '([0-9]+%)' | grep -Eo '([0-9])+'",
		center = {x = 660 + GX, y = 310 + GY},
		radius = 50,

		background_color = color, 
		background_alpha = 0.3,
		background_thickness = 3,

		bar_color = color,
		bar_alpha = 1,
		bar_thickness = 8,

		max_value = 100,

		change_color_on_critical = false,

		start_angle = -240,
		end_angle = 60,
	})

	draw_static_text(cr, prep{
		kind = "static_text",

		from = {x = 797 + GX, y = 316 + GY},

		text = "OXYGEN",

		font = "Hack",
		font_size = 18,
		bold = true,
		color = 0xffffff
	})

	draw_ring_graph(cr, prep{
		kind = 'ring_graph',
		-- conky_value = "execi 2 acpi | grep -Eo '([0-9])+%' | grep -Eo '([0-9])+'",
		conky_value = "memperc",
		center = {x = 829 + GX, y = 310 + GY},
		radius = 50,

		background_color = 0xFFFFFF, 
		background_alpha = 0.3,
		background_thickness = 3,

		bar_color = 0xFFFFFF, 
		bar_alpha = 1,
		bar_thickness = 8,

		max_value = 100,

		start_angle = -240,
		end_angle = 60,

		critical_threshold = 60,

		change_color_on_critical = true,

		background_color_critical = 0xFF2828,

		bar_color_critical = 0xFF2828,
	})




	xoff = 0 - 102
	yoff = 230 - 42 + (50 + 30) * 2

	-- LEFT

	draw_line(cr, prep{
		kind = "line",

		from = {x = 702 + xoff + GX, y = 42 + yoff + GY},
		to = {x = 600 + xoff + GX, y = 230 + yoff + GY},

		color = 0xffffff,
		alpha = 1,
		thickness = 1
	})

	-- RIGHT

	draw_line(cr, prep{
		kind = "line",

		from = {x = 999 + xoff + GX, y = 42 + yoff + GY},
		to = {x = 899 + xoff + GX, y = 230 + yoff + GY},

		color = 0xffffff,
		alpha = 1,
		thickness = 1
	})

	-- BOTTOM

	draw_line(cr, prep{
		kind = "line",

		from = {x = 600 + xoff + GX, y = 230 + yoff + GY},
		to = {x = 899 + xoff + GX, y = 230 + yoff + GY},

		color = 0xffffff,
		alpha = 1,
		thickness = 1
	})

	-- TOP

	draw_line(cr, prep{
		kind = "line",

		from = {x = 702 + xoff + GX, y = 42 + yoff + GY},
		to = {x = 999 + xoff + GX, y = 42 + yoff + GY},

		color = 0xffffff,
		alpha = 1,
		thickness = 1
	})

	xoff2 = xoff + GX + 10 - 5
	yoff2 = yoff + GY + 10 + 60

	dtx = 16
	dty = 0

	draw_static_text(cr, prep{
		kind = "static_text",

		from = {x = 702 + xoff2 + dtx, y = yoff2 + 18 + dty},

		text = os.date"%H:%M",

		font = "Hack",
		font_size = 36,
		bold = true,
		color = 0xffffff
	})

	assert(os.setlocale"C")

	draw_static_text(cr, prep{
		kind = "static_text",

		from = {x = 702 + xoff2 + 120 + dtx, y = yoff2 + 2 + dty},

		text = os.date"%A",

		font = "Hack",
		font_size = 15,
		bold = true,
		color = 0xffffff
	})

	draw_static_text(cr, prep{
		kind = "static_text",

		from = {x = 702 + xoff2 + 120 + dtx, y = yoff2 + 18 + dty},

		text = os.date"%d.%m.%y",

		font = "Hack",
		font_size = 15,
		bold = true,
		color = 0xffffff
	})

	lx = 40
	ly = 60

	draw_static_text(cr, prep{
		kind = "static_text",
		
		from = {x = 702 + xoff2 + lx - 20 + 11, y = yoff2 + 18 + ly + 5},

		text = "DU",

		font = "Hack",
		font_size = 15,
		bold = true,
		color = 0xffffff
	})


	draw_ring_graph(cr, prep{
		kind = 'ring_graph',
		conky_value = "fs_used_perc /",
		center = {x = 702 + xoff2 + lx, y = yoff2 + 18 + ly},
		radius = 30,

		background_color = 0xFFFFFF, 
		background_alpha = 0.3,
		background_thickness = 3,

		bar_color = 0xFFFFFF, 
		bar_alpha = 1,
		bar_thickness = 5,

		max_value = 100,

		start_angle = -240,
		end_angle = 60,
	})

	lx = 130
	ly = 60

	draw_static_text(cr, prep{
		kind = "static_text",
		
		from = {x = 702 + xoff2 + lx - 20 + 7, y = yoff2 + 18 + ly + 5},

		text = "SWP",

		font = "Hack",
		font_size = 15,
		bold = true,
		color = 0xffffff
	})


	draw_ring_graph(cr, prep{
		kind = 'ring_graph',
		conky_value = "swapperc",
		center = {x = 702 + xoff2 + lx, y = yoff2 + 18 + ly},
		radius = 30,

		background_color = 0xFFFFFF, 
		background_alpha = 0.3,
		background_thickness = 3,

		bar_color = 0xFFFFFF, 
		bar_alpha = 1,
		bar_thickness = 5,

		max_value = 100,

		start_angle = -240,
		end_angle = 60,
	})

	net = conky_parse("${wireless_essid wlp2s0}")
	nettext = "Nearest station: " .. net
	if #net > 12 then
		nettext = "Nearest station: " .. net:sub(0, 11) .. "…"
	end

	if net == "off/any" then
		nettext = "Not found any station"
	end

	draw_static_text(cr, prep{
		kind = "static_text",
		
		from = {x = 702 + xoff2 - 50, y = yoff2 + 18 + ly + 5 + 60},

		text = nettext,

		font = "Hack",
		font_size = 12,
		bold = true,
		color = 0xffffff
	})

	cairo_destroy(cr)
	cairo_surface_destroy(cs)
end
