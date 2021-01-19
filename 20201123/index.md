---
title: "httr Two Common Authentication Methods"
output: hugodown::md_document
status: "publish"
comment_status: "open"
categories: R Programming
tags:
  - httr
  - httr Authentication
  - httr API key
  - httr OAuth
rmd_hash: 8d7b73e75b395793

---

What I just learned that there can be a couple of authentication methods used in R API wrapper packages but the most common ones are `API Key` and `OAuth 2.0`.

API Key
-------

`API Key` normally can be generated on a developer dashboard and can be regenerated later for security reason.

`API Key` can be saved as an environment variable in a `.Renviron` file and then we can use [`Sys.getenv()`](https://rdrr.io/r/base/Sys.getenv.html) to get access to it, as shown here: <a href="https://github.com/maelle/goodpress/blob/main/R/utils-http.R" class="uri">https://github.com/maelle/goodpress/blob/main/R/utils-http.R</a>.

`keyring` package is another common way to manage `API Key`: `key_set()` to create api key and `key_get()` to get access to the api key, as shown here: <a href="https://github.com/lockedata/hubspot/blob/master/R/hubspot_key.R" class="uri">https://github.com/lockedata/hubspot/blob/master/R/hubspot_key.R</a>.

Lastly, there are two different ways to include an api key in api calls: **including it as part of the URL or adding it in the HTTP header**.

<!-- wp:more -->
<!--more-->
<!-- /wp:more -->

For example, HubSpot requires that api key needs to be added in the url (<a href="https://developers.hubspot.com/docs/api/intro-to-auth" class="uri">https://developers.hubspot.com/docs/api/intro-to-auth</a>), while Leadfeeder asks developers to include it in the HTTP header (<a href="https://docs.leadfeeder.com/api/#authentication" class="uri">https://docs.leadfeeder.com/api/#authentication</a>).

OAuth 2.0
---------

Take HubSpot for example. <a href="https://developers.hubspot.com/docs/api/oauth-quickstart-guide" class="uri">https://developers.hubspot.com/docs/api/oauth-quickstart-guide</a> illustrates the steps in working with OAuth 2.0.

Accordingly, the steps in `httr` are:

-   **Step 1: provide the app information with `oauth_app()`**

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>oauth_app</span> <span class='o'>&lt;-</span> <span class='nf'>oauth_app</span>(
  appname = <span class='k'>app_name</span>, 
  key = <span class='k'>client_id</span>, <span class='c'># from developer dashboard</span>
  secret = <span class='k'>client_secret</span> <span class='c'># from developer dashboard</span>
)</code></pre>

</div>

-   **Step 2: build an endpoint with `oauth_endpoint()`**

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>oauth_endpoint</span> <span class='o'>&lt;-</span> <span class='nf'>oauth_endpoint</span>(
  authorize = <span class='k'>authorize_url</span>, <span class='c'># needs to be constructed first</span>
  access = <span class='k'>access_url</span> <span class='c'># needs to be constructed first</span>
)</code></pre>

</div>

-   **Step 3: create a token with `oauth2.0_token()`**

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>token</span> <span class='o'>&lt;-</span> <span class='nf'>oauth2.0_token</span>(
  endpoint = <span class='k'>oauth_endpoint</span>,
  app = <span class='k'>oauth_app</span>
)</code></pre>

</div>

-   **Step 4: save the token into a file and create an environment variable pointing to it**

-   **Step 5: use the token in every api call**

Token can be accessed with `token$credentials$access_token` and should be added in HTTP headers with `add_headers()` or `config()`.

-   **Step 6: refresh token with `token$refresh()`**

Here is an example that implements all the steps above for HubSpot OAuth 2.0: <a href="https://github.com/lockedata/hubspot/blob/master/R/hubspot_oauth.R" class="uri">https://github.com/lockedata/hubspot/blob/master/R/hubspot_oauth.R</a>.

Besides learning from the source code on github, I found the following articles very useful:

-   [An Introduction to APIs](https://zapier.com/learn/apis/)
-   [Best practices for API packages](https://httr.r-lib.org/articles/api-packages.html)

