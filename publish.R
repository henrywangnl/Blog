
library(goodpress)

# setup
post_folder <- "20211005"
wordpress_url <- "https://henrywang.nl"

# publish
wp_post(post_folder, wordpress_url)


# helpers
categories <- wp_categories(wordpress_url)
tags <- wp_tags(wordpress_url)
