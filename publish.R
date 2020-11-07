
library(goodpress)

post_folder <- "20201107"
wordpress_url <- "https://henrywang.nl"

wp_post(post_folder, wordpress_url)

categories <- wp_categories(wordpress_url)

tags <- wp_tags(wordpress_url)
View(tags)


text <- "HubSpot Contact Properties List"
gsub(" ", "-", tolower(text))


time <- "YYYY-MM-DDTHH:MM:SS"
format(Sys.time(), '%Y-%m-%dT%H:%M:%S')

toString(text)
?sub


