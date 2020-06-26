library(tidyverse)
library(ggthemes)
library(ggtext)

firsts <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/firsts.csv')

glimpse(firsts)

skimr::skim(firsts)

view(firsts)


firsts %>% 
  count(person, sort = TRUE)

firsts %>% 
  count(category)


firsts %>% 
  add_count(decades = (year %/% 10) * 10, category) 


# First try with bar geom -------------------------------------------------


firsts %>% 
  mutate(decades = (year %/% 10) * 10) %>% 
  ggplot(aes(decades, 1, fill = category)) +
  geom_col(color = "#1b1f2b",
           size = 1.5,
           width = 8) +
  geom_text(x = 1800, 
            y = 61, 
            label = "The First Achievements by African Americans",
            family = "mono",
            size = 7,
            color = "white") +
  scale_x_continuous(name = "Decades",
                     breaks = seq(1730, 2010, 10),
                     labels = paste0(seq(1730, 2010, 10), "s"),
                     expand = c(0, 1)) +
  scale_y_continuous(name = NULL,
                     breaks = NULL,
                     labels = NULL,
                     expand = c(0, 1)) +
  scale_fill_brewer(palette = "Dark2") +
  labs(caption = "Source: TidyTuesday Week24, 2020") +
  guides(fill = guide_legend(direction = "horizontal",
                             nrow = 1,
                             title = NULL)) +
  theme(plot.background = element_rect(fill = "#1b1f2b"),
        panel.background = element_rect(fill = "#1b1f2b"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.key.size = unit(.2, "cm"),
        legend.key.width = unit(0.7,"cm"),
        legend.key = element_rect(color = "#1b1f2b"),
        legend.position = c(0.29, 0.87),
        legend.background = element_rect(fill = "#1b1f2b"),
        legend.text = element_text(color = "white"),
        axis.text.x = element_text(color = "white",
                                   margin = margin(b = 5)),
        axis.title.x = element_text(color = "white"),
        plot.caption = element_text(color = "white"))



# Simplifying -------------------------------------------------------------


data <- tribble(
  ~x, ~y,  ~z,
   1,  2, "a",
   2,  2, "c",
   1,  3, "b",
   3,  5, "a",
   1,  9, "c",
   2,  8, "c",
   3,  4, "d",
   4,  1, "b"
)

data %>% 
  count(x)


p <- ggplot(data, aes(x, y, fill = z)) +
  geom_col(color = "red")

p
layer_data(p)


ggplot(data, aes(x)) +
  geom_bar(color = "red")


# Second try with point geom -------------------------------------------------------------

firsts %>% 
  count(year, category) %>% 
  mutate(decades = (year %/% 10) * 10) %>% 
  ggplot(aes(decades, 1, color = category)) +
  geom_point(position = "stack", size = 5) +
  scale_x_continuous(name = "Decades",
                     breaks = seq(1730, 2010, 10),
                     labels = paste0(seq(1730, 2010, 10), "s"),
                     expand = c(0.015, 0.975)) +
  scale_y_continuous(name = NULL,
                     breaks = NULL,
                     labels = NULL,
                     expand = c(0, 1)) +
  scale_color_brewer(palette = "Dark2") +
  labs(caption = "Source: TidyTuesday Week24, 2020") +
  guides(color = guide_legend(direction = "horizontal",
                             nrow = 1,
                             title = NULL)) +
  theme(plot.background = element_rect(fill = "black"),
        panel.background = element_rect(fill = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.key = element_rect(fill = "black"),
        legend.position = c(0.275, 0.87),
        legend.background = element_rect(fill = "black"),
        legend.text = element_text(color = "white"),
        axis.text.x = element_text(color = "white",
                                   margin = margin(b = 5)),
        axis.title.x = element_text(color = "white"),
        plot.caption = element_text(color = "white", face = "italic"))


# Third try with dotplot geom ---------------------------------------------

library(tidyverse)
library(ggtext)

firsts <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/firsts.csv')

ggplot(firsts, aes(year, category, color = category)) +
  geom_point(alpha = 0.6) +
  scale_x_continuous(breaks = seq(1730, 2020, 10),
                     expand = c(0.015, 0.975)) +
  labs(x = NULL,
       y = NULL,
       title = "African American Achievements <br> <br>
               <i style = 'font-size:10pt'>479 records of African-Americans breaking the color barrier across a wide range of topics</i>",
       subtitle = "Source: TidyTuesday Week24, 2020 <br> Dataviz: @henrywangnl") +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "black"),
        plot.title = element_markdown(color = "white",
                                      margin = margin(t = 10)),
        plot.subtitle = element_markdown(color = "white", 
                                         face = "italic", 
                                         size = 8,
                                         hjust = 1, 
                                         lineheight = 1.5,
                                         margin = margin(t = -30)),
        panel.background = element_rect(fill = "black"),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "white", size = 0.1, linetype = "dotted"),
        panel.grid.minor = element_blank(),
        axis.text = element_text(color = "white"),
        axis.title = element_text(color = "white"))

        