---
title: "R Markdown to WordPress with goodpress"
author: "Henry"
date: "2020-06-26T00:00:00"
output: hugodown::md_document
status: "publish"
slug: "rmarkdown-wordpress-goodpress"
categories: R Programming
tags:
  - R Markdown
  - goodpress
  - WordPress
rmd_hash: 489ad5a28aa73883

---

I have been writing a few posts about R on my blog and are getting annoyed with the workflow back and forth between RStudio and WordPress. Overall, the previous workflow has two main pitfalls making me frustrated:

-   **R Code**

Coping R code from RStudio and pasting it to WordPress can take me much time. Code highlight is also challenging, although eventually I figured out that the plugin of [SyntaxHighlighter Evolved](https://wordpress.org/plugins/syntaxhighlighter/) did a great job.

-   **R Output**

Often I need to export R outputs (e.g., ggplot2 plots) and upload them to WordPress, sometimes formatting them a bit.

<!-- wp:more -->
<!--more-->
<!-- /wp:more -->

goodpress
---------

These frustrations makes me seriously thinking about migrating my blog to [blogdown](https://bookdown.org/yihui/blogdown/) so that I could write blogs in R Markdown. However, for some reason, I kind of want to stick with WordPress and don't want a major change. For example, I really like this [Twenty Twelve](https://wordpress.org/themes/twentytwelve/) theme...

Finally, I came across [goodpress](https://maelle.github.io/goodpress/) package from [Maëlle Salmon](https://twitter.com/ma_salmon), which **allows me to post from R Markdown to WordPress and keep the WordPress theme as is**. So here comes my first experience with `goodpress`, which is really fun and thanks to Maëlle's help I finally work through the whole workflow.

Example
-------

As mentioned above, the most important feature I need is if `goodpress` could post R code and outputs to WordPress and render them as I expect, so I first checked with my previous [Tidytuesday](https://github.com/rfordatascience/tidytuesday) case.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span>)

<span class='k'>firsts</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span>(<span class='s'>'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/firsts.csv'</span>)</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>firsts</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 479 x 5</span></span>
<span class='c'>#&gt;     year accomplishment              person                gender     category  </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                       </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                 </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>  </span><span style='text-decoration: underline;'>1</span><span>738 First free African-America… Gracia Real de Santa… African-A… Social &amp; …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>  </span><span style='text-decoration: underline;'>1</span><span>760 First known African-Americ… Jupiter Hammon (poem… Female Af… Arts &amp; En…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>  </span><span style='text-decoration: underline;'>1</span><span>768 First known African-Americ… Wentworth Cheswell, … African-A… Social &amp; …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>  </span><span style='text-decoration: underline;'>1</span><span>773 First known African-Americ… Phillis Wheatley (Po… Female Af… Arts &amp; En…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>  </span><span style='text-decoration: underline;'>1</span><span>773 First separate African-Ame… Silver Bluff Baptist… African-A… Religion  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>  </span><span style='text-decoration: underline;'>1</span><span>775 First African-American to … Prince Hall           African-A… Social &amp; …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>  </span><span style='text-decoration: underline;'>1</span><span>778 First African-American U.S… the 1st Rhode Island… African-A… Military  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>  </span><span style='text-decoration: underline;'>1</span><span>783 First African-American to … James Derham, who di… African-A… Education…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>  </span><span style='text-decoration: underline;'>1</span><span>785 First African-American ord… Rev. Lemuel Haynes. … African-A… Religion  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>  </span><span style='text-decoration: underline;'>1</span><span>792 First major African-Americ… 3,000 Black Loyalist… African-A… Social &amp; …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 469 more rows</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span>(<span class='k'>firsts</span>, <span class='nf'>aes</span>(<span class='k'>year</span>, <span class='k'>category</span>, color = <span class='k'>category</span>)) <span class='o'>+</span>
  <span class='nf'>geom_point</span>(alpha = <span class='m'>0.6</span>) <span class='o'>+</span>
  <span class='nf'>scale_x_continuous</span>(breaks = <span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span>(<span class='m'>1730</span>, <span class='m'>2020</span>, <span class='m'>10</span>),
                     expand = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>0.015</span>, <span class='m'>0.975</span>)) <span class='o'>+</span>
  <span class='nf'>labs</span>(x = <span class='kr'>NULL</span>,
       y = <span class='kr'>NULL</span>,
       title = <span class='s'>"African American Achievements"</span>) <span class='o'>+</span>
  <span class='nf'>theme</span>(legend.position = <span class='s'>"none"</span>,
        plot.background = <span class='nf'>element_rect</span>(fill = <span class='s'>"black"</span>),
        plot.title = <span class='nf'>element_text</span>(color = <span class='s'>"white"</span>,
                                      margin = <span class='nf'>margin</span>(t = <span class='m'>10</span>)),
        panel.background = <span class='nf'>element_rect</span>(fill = <span class='s'>"black"</span>),
        panel.grid.major.x = <span class='nf'>element_blank</span>(),
        panel.grid.major.y = <span class='nf'>element_line</span>(color = <span class='s'>"white"</span>, size = <span class='m'>0.1</span>, linetype = <span class='s'>"dotted"</span>),
        panel.grid.minor = <span class='nf'>element_blank</span>(),
        axis.text = <span class='nf'>element_text</span>(color = <span class='s'>"white"</span>),
        axis.text.x = <span class='nf'>element_text</span>(angle = <span class='o'>-</span><span class='m'>60</span>, vjust = <span class='m'>1</span>, hjust = <span class='m'>0</span>),
        axis.title = <span class='nf'>element_text</span>(color = <span class='s'>"white"</span>))
</code></pre>
<img src="figs/unnamed-chunk-3-1.png" width="700px" style="display: block; margin: auto;" />

</div>

It looks everything is perfect! For more inspirations, check `goodpress` demo site: <https://rmd-wordpress.eu/>.

Issues
------

The `goodpress` [instructions](https://maelle.github.io/goodpress/index.html) are quite straightforward and you can follow the documentation step by step, but when I first tried `goodpress` I did have some issues that I want to point out so that you don't make the same mistakes I made.

### Authentication Setup

Following the steps in [Authentication](https://maelle.github.io/goodpress/articles/setup.html#authentication-1), the first mistake I made is that I should not use the WordPress user and password for `WP_USER` and `WP_PWD`. Instead, I should use the information of `Application Passwords` in WordPress, as shown below.

<div class="highlight">

<img src="figs/wpuser.png" width="700px" style="display: block; margin: auto;" />

</div>

### YAML Format

So far, `goodpress` seems very strict with the YAML metadata format. For example, for the `Author` you can either eliminate it or use one of the **existing usernames** of your WordPress. I suggest to copy the YAML header from the documentation: <https://maelle.github.io/goodpress/index.html>.

More features
-------------

`goodpress` is still a WIP package and only has one function of [wp\_post](https://maelle.github.io/goodpress/reference/wp_post.html). While it solves my problem, I do look forward to more features to improve the whole experience. For example, I cannot remember all the category and tag names and I have to go back to check them on WordPress dashboard. Probably it can be done with another function so that I can forget WordPress dashboard?

Final Note
----------

As shown above, `goodpress` is what I want and the workflow from R Markdown to WordPress is way better than before. I highly recommend it to WordPress users who often write blogs about R.

*This post is written in R Markdown and posted to WordPress via `goodpress`(version: 0.0.0.9000)*.

