---
title: "R to WordPress"
author: "Henry"
date: "2020-06-25T00:00:00"
slug: "rmd"
output: hugodown::md_document
status: "draft"
rmd_hash: abea8b450757313c

---

I have been writing a few posts about R on my blog and are getting annoyed with the workflow back and forth between RStudio and WordPress. Overall, the previous workflow has two main pitfalls making me frustrated:

-   **R Code**

Coping R code from RStudio and pasting it to WordPress can take me much time. Code highlight is also challenging, although eventually I figured out that the plugin of [SyntaxHighlighter Evolved](https://wordpress.org/plugins/syntaxhighlighter/) did a great job.

-   **R Output**

Often I need to export R outputs (e.g., ggplot2 plots) and upload to WordPress, sometimes formatting them a bit.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span>)

<span class='k'>firsts</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span>(<span class='s'>'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/firsts.csv'</span>)
<span class='k'>firsts</span>
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
<img src="figs/unnamed-chunk-2-1.png" width="700px" style="display: block; margin: auto;" />

</div>

