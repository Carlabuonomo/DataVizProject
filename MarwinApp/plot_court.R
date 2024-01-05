theme_court = '#fffcf2'
theme_lines = '#999999'
theme_text = '#222222'
theme_made = '#00bfc4'
theme_missed = '#f8766d'
theme_hex_border_size = 0.3
theme_hex_border_color = "#cccccc"


circle_points = function(center = c(0, 0), radius = 1, npoints = 360) {
  angles = seq(0, 2 * pi, length.out = npoints)
  return(tibble(x = center[1] + radius * cos(angles),
                    y = center[2] + radius * sin(angles)))
}

width = 50
height = 94 / 2
key_height = 19
inner_key_width = 12
outer_key_width = 16
backboard_width = 6
backboard_offset = 4
neck_length = 0.5
hoop_radius = 0.75
hoop_center_y = backboard_offset + neck_length + hoop_radius
three_point_radius = 23.75
three_point_side_radius = 22
three_point_side_height = 14

plot_court = function() {
  court_points = tibble(
    x = c(width / 2, width / 2, -width / 2, -width / 2, width / 2),
    y = c(height, 0, 0, height, height),
    desc = "perimeter"
  )

  court_points = bind_rows(court_points , tibble(
    x = c(outer_key_width / 2, outer_key_width / 2, -outer_key_width / 2, -outer_key_width / 2),
    y = c(0, key_height, key_height, 0),
    desc = "outer_key"
  ))

  court_points = bind_rows(court_points , tibble(
    x = c(-backboard_width / 2, backboard_width / 2),
    y = c(backboard_offset, backboard_offset),
    desc = "backboard"
  ))

  court_points = bind_rows(court_points , tibble(
    x = c(0, 0), y = c(backboard_offset, backboard_offset + neck_length), desc = "neck"
  ))

  foul_circle = circle_points(center = c(0, key_height), radius = inner_key_width / 2)

  foul_circle_top = filter(foul_circle, y > key_height) %>%
    mutate(desc = "foul_circle_top")

  foul_circle_bottom = filter(foul_circle, y < key_height) %>%
    mutate(
      angle = atan((y - key_height) / x) * 180 / pi,
      angle_group = floor((angle - 5.625) / 11.25),
      desc = paste0("foul_circle_bottom_", angle_group)
    ) %>%
    filter(angle_group %% 2 == 0) %>%
    select(x, y, desc)

  hoop = circle_points(center = c(0, hoop_center_y), radius = hoop_radius) %>%
    mutate(desc = "hoop")

  restricted = circle_points(center = c(0, hoop_center_y), radius = 4) %>%
    filter(y >= hoop_center_y) %>%
    mutate(desc = "restricted")

  three_point_circle = circle_points(center = c(0, hoop_center_y), radius = three_point_radius) %>%
    filter(y >= three_point_side_height, y >= hoop_center_y)

  three_point_line = tibble(
    x = c(three_point_side_radius, three_point_side_radius, three_point_circle$x, -three_point_side_radius, -three_point_side_radius),
    y = c(0, three_point_side_height, three_point_circle$y, three_point_side_height, 0),
    desc = "three_point_line"
  )

  court_points = bind_rows(
    court_points,
    foul_circle_top,
    foul_circle_bottom,
    hoop,
    restricted,
    three_point_line
  )

  court_points <<- court_points

  ggplot() +
    geom_path(
      data = court_points,
      aes(x = x, y = y, group = desc),
      color = 
        theme_lines
    ) +
    coord_fixed(ylim = c(0, 35), xlim = c(-25, 25)) +
    theme_minimal(base_size = 22) +
    theme(
      text = element_text(color = theme_text),
      plot.background = element_rect(fill = theme_court, color = theme_court),
      panel.background = element_rect(fill = theme_court, color = theme_court),
      panel.grid = element_blank(),
      panel.border = element_blank(),
      axis.text = element_blank(),
      axis.title = element_blank(),
      axis.ticks = element_blank(),
      legend.background = element_rect(fill = theme_court, color = theme_court),
      legend.margin = margin(-1, 0, 0, 0, unit = "lines"),
      legend.position = "bottom",
      legend.key = element_blank(),
      legend.text = element_text(size = rel(1.0))
    )
}

generate_heatmap_chart = function(shots, base_court) {
  base_court +
    stat_density_2d(
      data = shots,
      aes(x = shotX-24, y = shotY, fill = after_stat(density / max(density))),
      geom = "raster", contour = FALSE, interpolate = TRUE, n = 200
    ) +
    geom_path(
      data = court_points,
      aes(x = x, y = y, group = desc),
      color = theme_lines
    ) +
    scale_fill_viridis_c(
      "Shot Frequency    ",
      limits = c(0, 1),
      breaks = c(0, 1),
      labels = c("lower", "higher"),
      option = "inferno",
      guide = guide_colorbar(barwidth = 15)
    ) +
    theme(legend.text = element_text(size = rel(0.6)))
}

generate_scatter_chart = function(shots, base_court, alpha = 0.8, size = 2.5) {
  base_court +
    geom_point(
      data = shots,
      aes(x = shotX-24, y = shotY, color = made),
      alpha = alpha, size = size
    )
}

