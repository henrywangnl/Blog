---
title: "ROC Curve Simulation - Classification Performance"
author: "Henry"
date: "2020-07-14T19:00:00"
output: hugodown::md_document
status: "publish"
slug: "roc-curve-simulation-classification-performance"
categories: R Programming
tags:
  - ROC Curve
  - Classification
  - Logistic Regression
rmd_hash: 812720258d18dc8f

---

> "A receiver operating characteristic curve, or ROC curve, is a graphical plot that illustrates the diagnostic ability of a binary classifier system as its discrimination threshold is varied. The ROC curve is created by plotting the true positive rate against the false positive rate at various threshold settings." - Wikipedia

Simulation can be very useful for us to understand some concepts in Statistics, as shown in [Probability in R](https://henrywang.nl/probability-in-r/). Here is another example that I used simulation to understand ROC Curve and AUC, the metrics in classification models that I had never fully understand.

Data
----

The simulation in this post was inspired by [OpenIntro Statistics](https://www.amazon.com/OpenIntro-Statistics-Third-David-Diez/dp/194345003X) and the `email` dataset I used can be found in `openintro` package.

<!-- wp:more -->
<!--more-->
<!-- /wp:more -->

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span>)

<span class='c'># For the email dataset</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/OpenIntroStat/openintro'>openintro</a></span>)

<span class='c'># For ROC curve plots </span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/tidymodels/tidymodels'>tidymodels</a></span>)</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>email</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3,921 x 21</span></span>
<span class='c'>#&gt;     spam to_multiple  from    cc sent_email time                image attach</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dttm&gt;</span><span>              </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>     0           0     1     0          0 2012-01-01 </span><span style='color: #555555;'>07:16:41</span><span>     0      0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>     0           0     1     0          0 2012-01-01 </span><span style='color: #555555;'>08:03:59</span><span>     0      0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>     0           0     1     0          0 2012-01-01 </span><span style='color: #555555;'>17:00:32</span><span>     0      0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>     0           0     1     0          0 2012-01-01 </span><span style='color: #555555;'>10:09:49</span><span>     0      0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>     0           0     1     0          0 2012-01-01 </span><span style='color: #555555;'>11:00:01</span><span>     0      0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>     0           0     1     0          0 2012-01-01 </span><span style='color: #555555;'>11:04:46</span><span>     0      0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>     0           1     1     0          1 2012-01-01 </span><span style='color: #555555;'>18:55:06</span><span>     0      0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>     0           1     1     1          1 2012-01-01 </span><span style='color: #555555;'>19:45:21</span><span>     1      1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>     0           0     1     0          0 2012-01-01 </span><span style='color: #555555;'>22:08:59</span><span>     0      0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>     0           0     1     0          0 2012-01-01 </span><span style='color: #555555;'>19:12:00</span><span>     0      0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 3,911 more rows, and 13 more variables: dollar </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, winner </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   inherit </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, viagra </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, password </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, num_char </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   line_breaks </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span style='color: #555555;'>, format </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, re_subj </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, exclaim_subj </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   urgent_subj </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, exclaim_mess </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, number </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span></span></code></pre>

</div>

These data represent incoming emails for the first three months of 2012 for an email account. The variables are explained clearly [here](http://openintrostat.github.io/openintro/reference/email.html).

Logistic Regression Model
-------------------------

Basically the research question is to develop a valid `logistic regression` to predict if an email is `spam`. This post focuses on the ROC curve simulation so we will just jump to the final refined model as shown below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># data preparation</span>
<span class='k'>df</span> <span class='o'>&lt;-</span> <span class='k'>email</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span>(<span class='nf'>across</span>(<span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='k'>to_multiple</span>, <span class='k'>cc</span>, <span class='k'>image</span>, <span class='k'>attach</span>, <span class='k'>password</span>, <span class='k'>re_subj</span>, <span class='k'>urgent_subj</span>), <span class='o'>~</span><span class='nf'>if_else</span>(<span class='k'>.x</span> <span class='o'>&gt;</span> <span class='m'>0</span>, <span class='s'>"yes"</span>, <span class='s'>"no"</span>))) <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span>(format = <span class='nf'>if_else</span>(<span class='k'>format</span> <span class='o'>==</span> <span class='m'>0</span>, <span class='s'>"Plain"</span>, <span class='s'>"Formated"</span>))

<span class='c'># fit logistic regression model</span>
<span class='k'>g_refined</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/glm.html'>glm</a></span>(<span class='k'>spam</span> <span class='o'>~</span> <span class='k'>to_multiple</span> <span class='o'>+</span> <span class='k'>cc</span> <span class='o'>+</span> <span class='k'>image</span> <span class='o'>+</span> <span class='k'>attach</span> <span class='o'>+</span> <span class='k'>winner</span>
                       <span class='o'>+</span> <span class='k'>password</span> <span class='o'>+</span> <span class='k'>line_breaks</span> <span class='o'>+</span> <span class='k'>format</span> <span class='o'>+</span> <span class='k'>re_subj</span>
                       <span class='o'>+</span> <span class='k'>urgent_subj</span> <span class='o'>+</span> <span class='k'>exclaim_mess</span>, data=<span class='k'>df</span>, family=<span class='k'>binomial</span>)

<span class='nf'><a href='https://rdrr.io/r/base/summary.html'>summary</a></span>(<span class='k'>g_refined</span>)
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Call:</span>
<span class='c'>#&gt; glm(formula = spam ~ to_multiple + cc + image + attach + winner + </span>
<span class='c'>#&gt;     password + line_breaks + format + re_subj + urgent_subj + </span>
<span class='c'>#&gt;     exclaim_mess, family = binomial, data = df)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Deviance Residuals: </span>
<span class='c'>#&gt;     Min       1Q   Median       3Q      Max  </span>
<span class='c'>#&gt; -1.7389  -0.4640  -0.2162  -0.1008   3.7746  </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Coefficients:</span>
<span class='c'>#&gt;                  Estimate Std. Error z value Pr(&gt;|z|)    </span>
<span class='c'>#&gt; (Intercept)    -1.7594438  0.1177345 -14.944  &lt; 2e-16 ***</span>
<span class='c'>#&gt; to_multipleyes -2.7367955  0.3155876  -8.672  &lt; 2e-16 ***</span>
<span class='c'>#&gt; ccyes          -0.5358071  0.3142521  -1.705 0.088190 .  </span>
<span class='c'>#&gt; imageyes       -1.8584670  0.7701428  -2.413 0.015815 *  </span>
<span class='c'>#&gt; attachyes       1.2002443  0.2391097   5.020 5.18e-07 ***</span>
<span class='c'>#&gt; winneryes       2.0432610  0.3527599   5.792 6.95e-09 ***</span>
<span class='c'>#&gt; passwordyes    -1.5618002  0.5353765  -2.917 0.003532 ** </span>
<span class='c'>#&gt; line_breaks    -0.0030972  0.0004894  -6.328 2.48e-10 ***</span>
<span class='c'>#&gt; formatPlain     1.0130019  0.1379651   7.342 2.10e-13 ***</span>
<span class='c'>#&gt; re_subjyes     -2.9934921  0.3777998  -7.923 2.31e-15 ***</span>
<span class='c'>#&gt; urgent_subjyes  3.8829719  1.0054222   3.862 0.000112 ***</span>
<span class='c'>#&gt; exclaim_mess    0.0092727  0.0016248   5.707 1.15e-08 ***</span>
<span class='c'>#&gt; ---</span>
<span class='c'>#&gt; Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; (Dispersion parameter for binomial family taken to be 1)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     Null deviance: 2437.2  on 3920  degrees of freedom</span>
<span class='c'>#&gt; Residual deviance: 1861.3  on 3909  degrees of freedom</span>
<span class='c'>#&gt; AIC: 1885.3</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Number of Fisher Scoring iterations: 7</span></code></pre>

</div>

The logistic regression model `g_refined` is developed and then we can fit it to our data (in practice you may want to fit it to your testing data instead of training data).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>pred</span> <span class='o'>&lt;-</span> <span class='k'>df</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>select</span>(spam_true = <span class='k'>spam</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>bind_cols</span>(spam_prob = <span class='nf'><a href='https://rdrr.io/r/base/Round.html'>round</a></span>(<span class='nf'><a href='https://rdrr.io/r/stats/predict.html'>predict</a></span>(<span class='k'>g_refined</span>, newdata = <span class='k'>df</span>, type = <span class='s'>"response"</span>), digits = <span class='m'>3</span>))

<span class='k'>pred</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3,921 x 2</span></span>
<span class='c'>#&gt;    spam_true spam_prob</span>
<span class='c'>#&gt;        <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>         0     0.084</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>         0     0.085</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>         0     0.091</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>         0     0.109</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>         0     0.084</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>         0     0.085</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>         0     0.006</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>         0     0.002</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>         0     0.279</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>         0     0.122</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 3,911 more rows</span></span></code></pre>

</div>

As shown above, `spam_true` is the truth which shows if an email is a spam whereas `spam_prob` is the predicted probability that an email is a spam. Take the first email for example. Our `g_refined` predicted that there is only 8.4% chance that this email is a spam, which seems quite accurate.

Probability Threshold
---------------------

The problem remains that what the probability threshold should be for the model to make the final prediction that an email is a spam or not. First, let's try an example of threshold of 0.75, which means that the model thinks an email is a spam if the predicted probability `spam_prob` higher than or equal to 0.75, otherwise not a spam, as shown below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>pred_cutoff</span> <span class='o'>&lt;-</span> <span class='k'>pred</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span>(cutoff = <span class='m'>0.75</span>,
         spam_pred = <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span>(<span class='k'>spam_prob</span> <span class='o'>&gt;=</span> <span class='k'>cutoff</span>, <span class='m'>1</span>, <span class='m'>0</span>))

<span class='k'>pred_cutoff</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3,921 x 4</span></span>
<span class='c'>#&gt;    spam_true spam_prob cutoff spam_pred</span>
<span class='c'>#&gt;        <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>         0     0.084   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>         0     0.085   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>         0     0.091   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>         0     0.109   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>         0     0.084   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>         0     0.085   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>         0     0.006   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>         0     0.002   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>         0     0.279   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>         0     0.122   0.75         0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 3,911 more rows</span></span></code></pre>

</div>

As the predicted probability of the first email is 0.084, which is less than 0.75, this email is not identified as a spam (`spam_pred` = 0).

Next, the metrics of this model can be computed as follows.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>pred_cutoff</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>summarize</span>(cutoff = <span class='m'>0.75</span>, 
          TP = <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span>(<span class='k'>spam_true</span> <span class='o'>==</span> <span class='m'>1</span> <span class='o'>&amp;</span> <span class='k'>spam_pred</span> <span class='o'>==</span> <span class='m'>1</span>),
          FP = <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span>(<span class='k'>spam_true</span> <span class='o'>==</span> <span class='m'>0</span> <span class='o'>&amp;</span> <span class='k'>spam_pred</span> <span class='o'>==</span> <span class='m'>1</span>),
          TN = <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span>(<span class='k'>spam_true</span> <span class='o'>==</span> <span class='m'>0</span> <span class='o'>&amp;</span> <span class='k'>spam_pred</span> <span class='o'>==</span> <span class='m'>0</span>),
          FN = <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span>(<span class='k'>spam_true</span> <span class='o'>==</span> <span class='m'>1</span> <span class='o'>&amp;</span> <span class='k'>spam_pred</span> <span class='o'>==</span> <span class='m'>0</span>),
          sensitivity = <span class='k'>TP</span> <span class='o'>/</span> (<span class='k'>TP</span> <span class='o'>+</span> <span class='k'>FN</span>), 
          specificity = <span class='k'>TN</span> <span class='o'>/</span> (<span class='k'>FP</span> <span class='o'>+</span> <span class='k'>TN</span>))
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 x 7</span></span>
<span class='c'>#&gt;   cutoff    TP    FP    TN    FN sensitivity specificity</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>   0.75    13     3  </span><span style='text-decoration: underline;'>3</span><span>551   354      0.035</span><span style='text-decoration: underline;'>4</span><span>       0.999</span></span></code></pre>

</div>

Overall, these metrics of classification models are illustrated below.

<div class="highlight">

<div class="figure" style="text-align: center">

<img src="figs/classification_metrics.png" alt="Classification Metrics from OpenIntro Statistics" width="700px" />
<p class="caption">
Classification Metrics from OpenIntro Statistics
</p>

</div>

</div>

Here is a nice way to illustrate these metrics graphically.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span>(<span class='k'>pred</span>, <span class='nf'>aes</span>(<span class='k'>spam_prob</span>, <span class='k'>spam_true</span>)) <span class='o'>+</span>
  <span class='nf'>geom_jitter</span>(height = <span class='m'>0.1</span>, alpha = <span class='m'>0.5</span>) <span class='o'>+</span>
  <span class='nf'>geom_vline</span>(xintercept = <span class='m'>0.75</span>, color = <span class='s'>"red"</span>) <span class='o'>+</span>
  <span class='nf'>geom_hline</span>(yintercept = <span class='m'>0.5</span>, color = <span class='s'>"red"</span>) <span class='o'>+</span>
  <span class='nf'>scale_y_continuous</span>(breaks = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>0</span>, <span class='m'>1</span>)) <span class='o'>+</span>
  <span class='nf'>geom_text</span>(label = <span class='s'>"FN(354)"</span>, x = <span class='m'>0.35</span>, y = <span class='m'>0.75</span>, color = <span class='s'>"red"</span>) <span class='o'>+</span>
  <span class='nf'>geom_text</span>(label = <span class='s'>"TP(13)"</span>, x = <span class='m'>0.85</span>, y = <span class='m'>0.75</span>, color = <span class='s'>"red"</span>) <span class='o'>+</span>
  <span class='nf'>geom_text</span>(label = <span class='s'>"TN(3551)"</span>, x = <span class='m'>0.35</span>, y = <span class='m'>0.35</span>, color = <span class='s'>"red"</span>) <span class='o'>+</span>
  <span class='nf'>geom_text</span>(label = <span class='s'>"FP(3)"</span>, x = <span class='m'>0.85</span>, y = <span class='m'>0.35</span>, color = <span class='s'>"red"</span>) <span class='o'>+</span>
  <span class='nf'>labs</span>(x = <span class='s'>"Predicted Probability of Being Spam"</span>,
       y = <span class='s'>"Spam"</span>)
</code></pre>
<img src="figs/classification_metrics_illustration-1.png" width="700px" style="display: block; margin: auto;" />

</div>

ROC Simulation
--------------

Now, after examining these metrics with the probability threshold of 0.75, we can move forward with simulation of all possible probability thresholds.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>metrics_fun</span> <span class='o'>&lt;-</span> <span class='nf'>function</span>(<span class='k'>cutoff</span>) {
  <span class='k'>pred</span> <span class='o'>%&gt;%</span> 
    <span class='nf'>mutate</span>(spam_pred = <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span>(<span class='k'>spam_prob</span> <span class='o'>&gt;=</span> <span class='k'>cutoff</span>, <span class='m'>1</span>, <span class='m'>0</span>)) <span class='o'>%&gt;%</span> 
    <span class='nf'>summarize</span>(cutoff = <span class='k'>cutoff</span>, 
          TP = <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span>(<span class='k'>spam_true</span> <span class='o'>==</span> <span class='m'>1</span> <span class='o'>&amp;</span> <span class='k'>spam_pred</span> <span class='o'>==</span> <span class='m'>1</span>),
          FP = <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span>(<span class='k'>spam_true</span> <span class='o'>==</span> <span class='m'>0</span> <span class='o'>&amp;</span> <span class='k'>spam_pred</span> <span class='o'>==</span> <span class='m'>1</span>),
          TN = <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span>(<span class='k'>spam_true</span> <span class='o'>==</span> <span class='m'>0</span> <span class='o'>&amp;</span> <span class='k'>spam_pred</span> <span class='o'>==</span> <span class='m'>0</span>),
          FN = <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span>(<span class='k'>spam_true</span> <span class='o'>==</span> <span class='m'>1</span> <span class='o'>&amp;</span> <span class='k'>spam_pred</span> <span class='o'>==</span> <span class='m'>0</span>),
          sensitivity = <span class='k'>TP</span> <span class='o'>/</span> (<span class='k'>TP</span> <span class='o'>+</span> <span class='k'>FN</span>), 
          specificity = <span class='k'>TN</span> <span class='o'>/</span> (<span class='k'>FP</span> <span class='o'>+</span> <span class='k'>TN</span>))
}</code></pre>

</div>

We simulate around 1000 possible values of probability thresholds and compute `sensitivity` and `specificity` metrics accordingly.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>cutoff</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span>(<span class='m'>0</span>, <span class='m'>1</span>, <span class='m'>0.001</span>)

<span class='k'>metrics</span> <span class='o'>&lt;-</span> <span class='k'>cutoff</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>map</span>(<span class='k'>metrics_fun</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>bind_rows</span>()

<span class='k'>metrics</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1,001 x 7</span></span>
<span class='c'>#&gt;    cutoff    TP    FP    TN    FN sensitivity specificity</span>
<span class='c'>#&gt;     <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>  0       367  </span><span style='text-decoration: underline;'>3</span><span>554     0     0       1          0     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>  0.001   367  </span><span style='text-decoration: underline;'>3</span><span>444   110     0       1          0.031</span><span style='text-decoration: underline;'>0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>  0.002   366  </span><span style='text-decoration: underline;'>3</span><span>344   210     1       0.997      0.059</span><span style='text-decoration: underline;'>1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>  0.003   366  </span><span style='text-decoration: underline;'>3</span><span>232   322     1       0.997      0.090</span><span style='text-decoration: underline;'>6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>  0.004   366  </span><span style='text-decoration: underline;'>3</span><span>131   423     1       0.997      0.119 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>  0.005   365  </span><span style='text-decoration: underline;'>3</span><span>001   553     2       0.995      0.156 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>  0.006   362  </span><span style='text-decoration: underline;'>2</span><span>915   639     5       0.986      0.180 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>  0.007   362  </span><span style='text-decoration: underline;'>2</span><span>791   763     5       0.986      0.215 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>  0.008   362  </span><span style='text-decoration: underline;'>2</span><span>660   894     5       0.986      0.252 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>  0.009   359  </span><span style='text-decoration: underline;'>2</span><span>520  </span><span style='text-decoration: underline;'>1</span><span>034     8       0.978      0.291 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 991 more rows</span></span></code></pre>

</div>

With the metrics value in place, we can plot `sensitivity`, true positive rate, against `1 - specificity`, false positive rate.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span>(<span class='k'>metrics</span>, <span class='nf'>aes</span>(x = <span class='m'>1</span> <span class='o'>-</span> <span class='k'>specificity</span>, y = <span class='k'>sensitivity</span>)) <span class='o'>+</span>
  <span class='nf'>geom_line</span>(color = <span class='s'>"red"</span>) <span class='o'>+</span>
  <span class='nf'>geom_abline</span>(linetype = <span class='s'>"dotted"</span>, color = <span class='s'>"grey50"</span>) <span class='o'>+</span>
  <span class='nf'>labs</span>(x = <span class='s'>"False Positive Rate"</span>, y = <span class='s'>"True Positive Rate"</span>) <span class='o'>+</span>
  <span class='nf'>coord_equal</span>()
</code></pre>
<img src="figs/ROC_curve_manually-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This plot is called ROC curve, which shows the trade off between `sensitivity` and `specificity` for all possible probability thresholds. ROC curve is a straightforward way to compare classification model performance. More specifically, the area under the curve (AUC) can be used to assess the model performance.

Tidymodels Approach
-------------------

While simulation is a good way to understand the concepts of classification metrics, it is not convenient to plot ROC curve. In essence, R has some packages to do this automatically. For example, [Tidymodels](https://www.tidymodels.org/) provides some tools such as `roc_curve()` and `roc_auc()` to plot ROC curve and calculate AUC.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># plot ROC Curve in tidymodels</span>
<span class='k'>pred</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>roc_curve</span>(truth = <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span>(<span class='k'>spam_true</span>), <span class='k'>spam_prob</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>autoplot</span>() <span class='o'>+</span>
  <span class='nf'>labs</span>(x = <span class='s'>"False Positve Rate"</span>, y = <span class='s'>"True Positive Rate"</span>)
</code></pre>
<img src="figs/ROC_curve_tidymodels-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>pred</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>roc_auc</span>(truth = <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span>(<span class='k'>spam_true</span>), <span class='k'>spam_prob</span>)
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 x 3</span></span>
<span class='c'>#&gt;   .metric .estimator .estimate</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>          </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> roc_auc binary         0.855</span></span></code></pre>

</div>

