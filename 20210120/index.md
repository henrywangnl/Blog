---
title: "Transform List into Dataframe With tidyr and purrr"
output: hugodown::md_document
status: "publish"
comment_status: "open"
categories: R Programming
tags:
  - List Manipulation in R
  - hoist() vs map()
  - list with tidyr vs purrr
rmd_hash: 40647307390f7e1e

---

As a data structure in R, list is not as familiar to me as vector and dataframe. I knew that list is often returned by function calls and I didn't pay much attention to it until I started working on the API wrapper package [RLeadfeeder](https://github.com/henrywangnl/RLeadfeeder). It turned out that list can be very useful to hold all kinds of data returned from API platforms and I had to make an effort to learn how to work with it, namely extract useful elements from a list and turn them into a dataframe.

This post is an example of how to transfrom a list into a dataframe with two different approaches: tidyr and purrr. The packages used in this post are as follows:

<!-- wp:more -->
<!--more-->
<!-- /wp:more -->

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyr.tidyverse.org'>tidyr</a></span><span class='o'>)</span> <span class='c'># for hoist() and unnest_longer()</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://magrittr.tidyverse.org'>magrittr</a></span><span class='o'>)</span> <span class='c'># for extract()</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://purrr.tidyverse.org'>purrr</a></span><span class='o'>)</span> <span class='c'># for map()</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/timelyportfolio/listviewer'>listviewer</a></span><span class='o'>)</span> <span class='c'># for jsonedit()</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/jennybc/repurrrsive'>repurrrsive</a></span><span class='o'>)</span> <span class='c'># for gh_repos dataset</span>
</code></pre>

</div>

Inspection
----------

Start with the inspection of list elements using `listviewer` package.

**Task 1: Examine and understand list elements interactively.**

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/pkg/listviewer/man/jsonedit.html'>jsonedit</a></span><span class='o'>(</span><span class='nv'>gh_repos</span><span class='o'>)</span>
</code></pre>

</div>

Extract Multiple Elements at the same level
-------------------------------------------

**Task 2: Extract each repository's name and full name.**

### purrr approach

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gh_repos</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map_df</a></span><span class='o'>(</span><span class='o'>~</span><span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map</a></span><span class='o'>(</span><span class='nv'>.x</span>, <span class='nv'>`[`</span>, <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"name"</span>, <span class='s'>"full_name"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># replace `[` with magrittr::extract() </span>
<span class='nv'>gh_repos</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map_df</a></span><span class='o'>(</span><span class='o'>~</span><span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map</a></span><span class='o'>(</span><span class='nv'>.x</span>, <span class='nf'>magrittr</span><span class='nf'>::</span><span class='nv'><a href='https://magrittr.tidyverse.org/reference/aliases.html'>extract</a></span>, <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"name"</span>, <span class='s'>"full_name"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 176 x 2</span></span>
<span class='c'>#&gt;    name        full_name              </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> after       gaborcsardi/after      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> argufy      gaborcsardi/argufy     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> ask         gaborcsardi/ask        </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> baseimports gaborcsardi/baseimports</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> citest      gaborcsardi/citest     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> clisymbols  gaborcsardi/clisymbols </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> cmaker      gaborcsardi/cmaker     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> cmark       gaborcsardi/cmark      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> conditions  gaborcsardi/conditions </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> crayon      gaborcsardi/crayon     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 166 more rows</span></span>
</code></pre>

</div>

### tidyr approach

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>repo <span class='o'>=</span> <span class='nv'>gh_repos</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/hoist.html'>unnest_longer</a></span><span class='o'>(</span><span class='nv'>repo</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/hoist.html'>hoist</a></span><span class='o'>(</span><span class='nv'>repo</span>, <span class='s'>"name"</span>, <span class='s'>"full_name"</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 176 x 3</span></span>
<span class='c'>#&gt;    name        full_name               repo             </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;list&gt;</span><span>           </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> after       gaborcsardi/after       </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> argufy      gaborcsardi/argufy      </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> ask         gaborcsardi/ask         </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> baseimports gaborcsardi/baseimports </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> citest      gaborcsardi/citest      </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> clisymbols  gaborcsardi/clisymbols  </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> cmaker      gaborcsardi/cmaker      </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> cmark       gaborcsardi/cmark       </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> conditions  gaborcsardi/conditions  </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> crayon      gaborcsardi/crayon      </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 166 more rows</span></span>
</code></pre>

</div>

Extract Multiple Elements at different levels
---------------------------------------------

**Task 3: Extract each repository's name, full name, and owner's username (`owner` -&gt; `login`).**

### purrr approach

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>name</span> <span class='o'>&lt;-</span> <span class='nv'>gh_repos</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map</a></span><span class='o'>(</span><span class='o'>~</span><span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map_chr</a></span><span class='o'>(</span><span class='nv'>.x</span>, <span class='s'>"name"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://purrr.tidyverse.org/reference/flatten.html'>flatten_chr</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>full_name</span> <span class='o'>&lt;-</span> <span class='nv'>gh_repos</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map</a></span><span class='o'>(</span><span class='o'>~</span><span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map_chr</a></span><span class='o'>(</span><span class='nv'>.x</span>, <span class='s'>"full_name"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://purrr.tidyverse.org/reference/flatten.html'>flatten_chr</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>username</span> <span class='o'>&lt;-</span> <span class='nv'>gh_repos</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map</a></span><span class='o'>(</span><span class='o'>~</span><span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map_chr</a></span><span class='o'>(</span><span class='nv'>.x</span>, <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"owner"</span>, <span class='s'>"login"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://purrr.tidyverse.org/reference/flatten.html'>flatten_chr</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span><span class='nv'>name</span>, <span class='nv'>full_name</span>, <span class='nv'>username</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 176 x 3</span></span>
<span class='c'>#&gt;    name        full_name               username   </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> after       gaborcsardi/after       gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> argufy      gaborcsardi/argufy      gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> ask         gaborcsardi/ask         gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> baseimports gaborcsardi/baseimports gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> citest      gaborcsardi/citest      gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> clisymbols  gaborcsardi/clisymbols  gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> cmaker      gaborcsardi/cmaker      gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> cmark       gaborcsardi/cmark       gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> conditions  gaborcsardi/conditions  gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> crayon      gaborcsardi/crayon      gaborcsardi</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 166 more rows</span></span>
</code></pre>

</div>

### tidyr approach

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>repo <span class='o'>=</span> <span class='nv'>gh_repos</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/hoist.html'>unnest_longer</a></span><span class='o'>(</span><span class='nv'>repo</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/hoist.html'>hoist</a></span><span class='o'>(</span><span class='nv'>repo</span>, <span class='s'>"name"</span>, <span class='s'>"full_name"</span>,
        username <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"owner"</span>, <span class='s'>"login"</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 176 x 4</span></span>
<span class='c'>#&gt;    name        full_name               username    repo             </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;list&gt;</span><span>           </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> after       gaborcsardi/after       gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> argufy      gaborcsardi/argufy      gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> ask         gaborcsardi/ask         gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> baseimports gaborcsardi/baseimports gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> citest      gaborcsardi/citest      gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> clisymbols  gaborcsardi/clisymbols  gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> cmaker      gaborcsardi/cmaker      gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> cmark       gaborcsardi/cmark       gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> conditions  gaborcsardi/conditions  gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> crayon      gaborcsardi/crayon      gaborcsardi </span><span style='color: #555555;'>&lt;named list [66]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 166 more rows</span></span>
</code></pre>

</div>

Preference
----------

As shown above, both approaches work fine but `tidyr` approach seems easier and more flexible to me. For example, considering the following question:

**Task 4: Extract the full name of each user's first repository.**

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>repo <span class='o'>=</span> <span class='nv'>gh_repos</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/hoist.html'>hoist</a></span><span class='o'>(</span><span class='nv'>repo</span>, 
        full_name <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>3</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 2</span></span>
<span class='c'>#&gt;   full_name           repo       </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>               </span><span style='color: #555555;font-style: italic;'>&lt;list&gt;</span><span>     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> gaborcsardi/after   </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> jennybc/2013-11_sfu </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> jtleek/advdatasci   </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> juliasilge/2016-14  </span><span style='color: #555555;'>&lt;list [26]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> leeper/ampolcourse  </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> masalmon/aqi_pdf    </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>repo <span class='o'>=</span> <span class='nv'>gh_repos</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/hoist.html'>hoist</a></span><span class='o'>(</span><span class='nv'>repo</span>, 
        full_name <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='s'>"full_name"</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 2</span></span>
<span class='c'>#&gt;   full_name           repo       </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>               </span><span style='color: #555555;font-style: italic;'>&lt;list&gt;</span><span>     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> gaborcsardi/after   </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> jennybc/2013-11_sfu </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> jtleek/advdatasci   </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> juliasilge/2016-14  </span><span style='color: #555555;'>&lt;list [26]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> leeper/ampolcourse  </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> masalmon/aqi_pdf    </span><span style='color: #555555;'>&lt;list [30]&gt;</span></span>
</code></pre>

</div>

Resources
---------

Last but not least I find these two resources are very useful for me to learn how to work with list:

-   purrr tutorial: <a href="https://jennybc.github.io/purrr-tutorial/index.html" class="uri">https://jennybc.github.io/purrr-tutorial/index.html</a>
-   tidyr rectangling: <a href="https://tidyr.tidyverse.org/articles/rectangle.html" class="uri">https://tidyr.tidyverse.org/articles/rectangle.html</a>

