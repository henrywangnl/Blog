library(searchConsoleR)
library(tidyverse)
library(ggrepel)

scr_auth()

list_websites()

# dimensions & metrics
# tidy data format and google products

page_query <- search_analytics(
  siteURL = "https://henrywang.nl/",
  dimensions = c("page", "query")
) %>% 
  as_tibble()

page_query %>% 
  glimpse()

page_query %>% 
  group_by(page) %>% 
  arrange(desc(impressions)) %>% 
  view()

query <- search_analytics(
  siteURL = "https://henrywang.nl/",
  dimensions = "query"
) %>% 
  as_tibble()

page <- search_analytics(
  siteURL = "https://henrywang.nl/",
  dimensions = "page"
) %>% 
  as_tibble()

save(page_query, query, page, file = file.path("console.rda"))

query %>% 
  filter(impressions > 20) %>% 
  ggplot(aes(ctr, impressions, label = query)) +
  geom_point(alpha = .5, size = .8) +
  geom_text_repel(size = 3) +
  geom_hline(yintercept = 90, color = "red", linetype = "dotdash") +
  geom_vline(xintercept = .06, color = "red", linetype = "dotdash") +
  scale_y_log10() +
  scale_x_continuous(labels = scales::label_percent(accuracy = 1),
                     breaks = seq(0, .3, .05))


query %>% 
  filter(impressions > 20) %>% 
  summarise(imp = mean(impressions))

query %>% 
  count(query, sort = TRUE)

query %>%
  skimr::skim()

ggplot(query, aes(impressions)) +
  geom_histogram()
