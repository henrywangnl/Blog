---
title: "Marketing Analytics with R - Google Search Console"
author: "Henry"
date: "2020-10-25T11:30:00"
output: hugodown::md_document
status: "publish"
slug: "google-search-console-r"
categories: Marketing Analytics
tags:
  - Marketing Analytics with R
  - Google Search Console with R
  - searchConsoleR package
rmd_hash: 9e452d09294ba574

---

I have been exploring a couple of marketing platforms in my new job as a Marketing Analyst. One of the daily jobs which I like most is to use R to dig into data across different marketing channels to come up with new ideas and recommendations for our marketing activities.

Google Search Console
---------------------

Google Search Console is one of the platforms I have been playing with recently. As you may already know, Google Search Console is a useful website tool for marketers to check website overall performance (e.g., search engine crawl and index issues, google search performance). For example, here is the performance report for my personal blog:

<!-- wp:more -->
<!--more-->
<!-- /wp:more -->

<div class="highlight">

<div class="figure" style="text-align: center">

<img src="figs/console.png" alt="Google Search Performance report for my blog" width="700px" />
<p class="caption">
Google Search Performance report for my blog
</p>

</div>

</div>

As you can see from the report, my blog has an average position of 28.4 on the search results, with a gradual increase in terms of impressions and clicks in the past 3 months.

Besides the overall performance report, Google Search Console also provides detailed information for different dimensions, such as `query`, `page` and `country` etc.

searchConsoleR Package
----------------------

[searchConsoleR](https://github.com/MarkEdmondson1234/searchConsoleR) is the r package I'm using to work with Google Search Console data. It is developed by [Mark Edmondson](http://code.markedmondson.me/), who also developed a bunch of other Google related r packages such as [googleAnalyticsR](https://code.markedmondson.me/googleAnalyticsR/). Highly recommend to check out his work if you want to do marketing analytics with R.

Pull Data from Google Search Console
------------------------------------

I mainly use search\_analytics() function in `searchConsoleR` to access my Google Search Console.

Firt load the packages:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://code.markedmondson.me/searchConsoleR'>searchConsoleR</a></span>)
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span>)
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://github.com/slowkow/ggrepel'>ggrepel</a></span>)</code></pre>

</div>

Get the `query` data in the last 3 months (by default):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># authentication </span>
<span class='nf'><a href='https://rdrr.io/pkg/searchConsoleR/man/scr_auth.html'>scr_auth</a></span>()

<span class='k'>query</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/searchConsoleR/man/search_analytics.html'>search_analytics</a></span>(
  siteURL = <span class='s'>"https://henrywang.nl/"</span>,
  dimensions = <span class='s'>"query"</span>
) <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span>()

<span class='k'>query</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span>(<span class='m'>10</span>)</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 x 5</span></span>
<span class='c'>#&gt;    query                            clicks impressions    ctr position</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                             </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> quadratic programming in r           44         162 0.272      2.44</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> quadratic programming r              26         105 0.248      2.50</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> media mix modeling in r              21          63 0.333      3.97</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> r quadratic programming              18          93 0.194      4.08</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> marketing mix modeling in r          14          75 0.187      8.32</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> quadprog in r                         4          53 0.075</span><span style='text-decoration: underline;'>5</span><span>     7.74</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> kindle vocabulary builder export      3          87 0.034</span><span style='text-decoration: underline;'>5</span><span>     8.34</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> quadratic optimization in r           3          41 0.073</span><span style='text-decoration: underline;'>2</span><span>     6.05</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> assignment problem in r               2           3 0.667      2   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> ggplot theme elements                 2         134 0.014</span><span style='text-decoration: underline;'>9</span><span>     5.61</span></span></code></pre>

</div>

Get the `page` data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>page</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/searchConsoleR/man/search_analytics.html'>search_analytics</a></span>(
  siteURL = <span class='s'>"https://henrywang.nl/"</span>,
  dimensions = <span class='s'>"query"</span>
) <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span>()

<span class='k'>page</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span>(<span class='m'>10</span>)</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 x 5</span></span>
<span class='c'>#&gt;    page                                       clicks impressions    ctr position</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                                       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> https://henrywang.nl/quadratic-programmin…    223        </span><span style='text-decoration: underline;'>1</span><span>718 0.130      10.2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> https://henrywang.nl/transportation-and-a…    149        </span><span style='text-decoration: underline;'>1</span><span>076 0.138      20.5</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> https://henrywang.nl/media-mix-modeling-i…    120        </span><span style='text-decoration: underline;'>2</span><span>125 0.056</span><span style='text-decoration: underline;'>5</span><span>     38.7</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> https://henrywang.nl/kindle-vocabulary-bu…     30         705 0.042</span><span style='text-decoration: underline;'>6</span><span>     21.4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> https://henrywang.nl/maximum-flow-problem…     22         356 0.061</span><span style='text-decoration: underline;'>8</span><span>     39.3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> https://henrywang.nl/ggplot2-theme-elemen…     21        </span><span style='text-decoration: underline;'>2</span><span>093 0.010</span><span style='text-decoration: underline;'>0</span><span>     26.5</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> https://henrywang.nl/category/optimizatio…     13         111 0.117      19.4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> https://henrywang.nl/linear-programming-w…      5         293 0.017</span><span style='text-decoration: underline;'>1</span><span>     33.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> https://henrywang.nl/mediation-analysis-i…      4         342 0.011</span><span style='text-decoration: underline;'>7</span><span>     52.1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> https://henrywang.nl/                           2          60 0.033</span><span style='text-decoration: underline;'>3</span><span>     16.9</span></span></code></pre>

</div>

Get query data for each page (answer questions like *which keyword is driving traffic to one specific page?*):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>page_query</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/searchConsoleR/man/search_analytics.html'>search_analytics</a></span>(
  siteURL = <span class='s'>"https://henrywang.nl/"</span>,
  dimensions = <span class='s'>"query"</span>
) <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span>() <span class='o'>%&gt;%</span> 
  <span class='nf'>group_by</span>(<span class='k'>page</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>arrange</span>(<span class='nf'>desc</span>(<span class='k'>impressions</span>)) <span class='o'>%&gt;%</span> 

<span class='k'>page_query</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span>(<span class='m'>10</span>)</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 x 6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># Groups:   page [5]</span></span>
<span class='c'>#&gt;    page                         query        clicks impressions     ctr position</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                        </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> https://henrywang.nl/media-… media mix m…      0         795 0          47.6 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> https://henrywang.nl/ggplot… ggplot2 the…      1         275 0.003</span><span style='text-decoration: underline;'>64</span><span>    37.9 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> https://henrywang.nl/ggplot… ggplot them…      1         248 0.004</span><span style='text-decoration: underline;'>03</span><span>    40.6 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> https://henrywang.nl/ggplot… theme ggplot      0         183 0          31.6 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> https://henrywang.nl/quadra… quadratic p…     44         162 0.272       2.44</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> https://henrywang.nl/probab… rbinom in r       0         139 0          79.1 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> https://henrywang.nl/probab… rbinom in r       0         138 0          79.1 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> https://henrywang.nl/ggplot… ggplot them…      2         134 0.014</span><span style='text-decoration: underline;'>9</span><span>      5.61</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> https://henrywang.nl/ggplot… ggplot theme      1         129 0.007</span><span style='text-decoration: underline;'>75</span><span>    34.9 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> https://henrywang.nl/quadra… quadprog r        2         126 0.015</span><span style='text-decoration: underline;'>9</span><span>      9.81</span></span></code></pre>

</div>

Query Performance Analysis
--------------------------

Depends on different marketing objectives, these data can be used in different ways. As suggested by Google, one of the use cases is to **identify queries with high impressions but low ctr and then try to improve them**. These keywords are important because, for example, my blog is shown quite often for those queries on the search results but people don't click the link to my blog proportionally.

These keywords can be identified as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>query</span> <span class='o'>%&gt;%</span> 
  <span class='c'># remove queries with very few impressions</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>impressions</span> <span class='o'>&gt;</span> <span class='m'>20</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span>(<span class='nf'>aes</span>(<span class='k'>ctr</span>, <span class='k'>impressions</span>, label = <span class='k'>query</span>)) <span class='o'>+</span>
  <span class='nf'>geom_point</span>(alpha = <span class='m'>.5</span>, size = <span class='m'>.8</span>) <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/ggrepel/man/geom_text_repel.html'>geom_text_repel</a></span>(size = <span class='m'>3</span>) <span class='o'>+</span>
  <span class='c'># average impression is around 90</span>
  <span class='nf'>geom_hline</span>(yintercept = <span class='m'>90</span>, color = <span class='s'>"red"</span>, linetype = <span class='s'>"dotdash"</span>) <span class='o'>+</span>
  <span class='c'># average ctr is 6%</span>
  <span class='nf'>geom_vline</span>(xintercept = <span class='m'>.06</span>, color = <span class='s'>"red"</span>, linetype = <span class='s'>"dotdash"</span>) <span class='o'>+</span>
  <span class='nf'>scale_y_log10</span>() <span class='o'>+</span>
  <span class='nf'>scale_x_continuous</span>(labels = <span class='k'>scales</span>::<span class='nf'><a href='https://scales.r-lib.org//reference/label_percent.html'>label_percent</a></span>(accuracy = <span class='m'>1</span>),
                     breaks = <span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span>(<span class='m'>0</span>, <span class='m'>.3</span>, <span class='m'>.05</span>))
</code></pre>

<div class="figure" style="text-align: center">

<img src="figs/google-search-console-data-analysis-r-1.png" alt="Queries with High Impressions but Low CTR" width="700px" />
<p class="caption">
Queries with High Impressions but Low CTR
</p>

</div>

</div>

As you can see from the graph, the top-left grid of the plot shows the queries with high impressions but low ctr, among which are a few keywords (e.g., `ggplot2 themes`) linked to [ggplot2 Theme Elements Demonstration](https://henrywang.nl/ggplot2-theme-elements-demonstration/).

<div class="highlight">

<div class="figure" style="text-align: center">

<img src="figs/ggplot2themes.png" alt="Page Title and Snippet to My Blog on SERP" width="700px" />
<p class="caption">
Page Title and Snippet to My Blog on SERP
</p>

</div>

</div>

What I can do next is to improve the page title and meta description to make it more relevant on the search results so that the CTR could be increased, resulting in more traffic to my blog. *I didn't do this for my blog as I don't want to go that far in that direction but it is highly recommended to implement it for your company website.*

This is an example of what we can do with R to conduct marketing analyses. I hope I can share with you more and will keep writing blogs about marketing analysis with R in the next coming weeks!

