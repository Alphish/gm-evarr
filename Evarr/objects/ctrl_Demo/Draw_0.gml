draw_set_color(c_white);
draw_set_font(fnt_Demo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(room_width div 2, room_height div 2 - 60, $"2 + (9 / 3) * (4 - 5) = {result}");

draw_text(room_width div 2, room_height div 2, $"dist(t=10, acc=1, v0=0) = {distance_1}");
draw_text(room_width div 2, room_height div 2 + 40, $"dist(t=5, acc=3, v0=5) = {distance_2}");

draw_text(room_width div 2, room_height div 2 + 80, $"counter = {counter_context.values.counter}");
